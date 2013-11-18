//
//  PopularListController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-4-17.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "PopularListController.h"
#import "ASIHTTPRequest.h"
#import "DetailViewController.h"
@interface PopularListController ()

@end

@implementation PopularListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"最受欢迎";
    self.view.backgroundColor=[UIColor redColor];
    self.tabView.hidden=YES;

    _api = [[NetAPI alloc] init];
    _api.delegate = self;
    [self getIndex];
}
- (void)getIndex
{
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    [mdict setValue:@"full.popular.products.get" forKey:@"method"];
    [_api sendRequest:mdict];
}
//获取数据成功
- (void)requestDidFinished:(NSDictionary *)dict
{
    self.dataList = [dict objectForKey:@"products"];
    if (self.dataList.count>0) {
//        for (int i=0; i<self.dataList.count; i++) {
//            int pid = [[self.dataList objectAtIndex:i] objectForKey:@"id"];
//            NSString *name = [[self.dataList objectAtIndex:i] objectForKey:@"name"];
//            NSString *comic_name = [[self.dataList objectAtIndex:i] objectForKey:@"comic_name"];
//            NSString *intro = [[self.dataList objectAtIndex:i] objectForKey:@"intro"];
//            NSString *cover = [[self.dataList objectAtIndex:i] objectForKey:@"cover"];
//            
//        }
        self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabView.delegate = self;
        self.tabView.dataSource = self;
        [self.view addSubview:self.tabView];
    } else {
        SHOWALERT(@"未查询到相应信息");
    }
//    [self.tabView reloadData];
}
//获取数据失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    LOADINGDISMISS;
    NSLog(@"失败");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int sec = self.dataList.count;
    if(sec == 1){
        sec = 1;
    }else if(sec%2 == 0){
        sec = sec/2;
    }else {
        sec = sec%2+1;
    }
    return sec;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopularListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    int row = indexPath.row;
    int lpid = [[self.dataList objectAtIndex:row*2] objectForKey:@"id"];
    NSString *lname = [[self.dataList objectAtIndex:row*2] objectForKey:@"name"];
    NSString *lcomic_name = [[self.dataList objectAtIndex:row*2] objectForKey:@"comic_name"];
    NSString *lintro = [[self.dataList objectAtIndex:row*2] objectForKey:@"intro"];
    NSString *lcover = [[self.dataList objectAtIndex:row*2] objectForKey:@"cover"];
    self.leftImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:lcover]]];
    self.leftLab1.text = lcomic_name;
    self.leftLab2.text = lintro;
    self.leftView.tag = lpid;
    UITapGestureRecognizer *leftGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)];
    self.leftView.userInteractionEnabled = YES;
    [self.leftView addGestureRecognizer:leftGest];
    
    if (self.dataList.count > ((row*2)+1)) {
        int rpid = [[self.dataList objectAtIndex:(row*2)+1] objectForKey:@"id"];
        NSString *rname = [[self.dataList objectAtIndex:(row*2)+1] objectForKey:@"name"];
        NSString *rcomic_name = [[self.dataList objectAtIndex:(row*2)+1] objectForKey:@"comic_name"];
        NSString *rintro = [[self.dataList objectAtIndex:(row*2)+1] objectForKey:@"intro"];
        NSString *rcover = [[self.dataList objectAtIndex:(row*2)+1] objectForKey:@"cover"];
        self.rightImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rcover]]];
        self.rightLab1.text = rcomic_name;
        self.rightLab2.text = rintro;
        self.rightView.tag = rpid;
        UITapGestureRecognizer *rightGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)];
        self.rightView.userInteractionEnabled = YES;
        [self.rightView addGestureRecognizer:rightGest];
    }
    
    return cell;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

//到达详情页
- (void)downComic:(UIGestureRecognizer *)gr
{
    int pid = gr.view.tag;
    DetailViewController *dvc = [[[DetailViewController alloc] init] autorelease];
    dvc.product_id = pid;
    NSArray *views = self.navigationController.navigationBar.subviews;
    for (id view in views) {
        if ([view isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl *seg = (UISegmentedControl *)view;
            seg.hidden = YES;
        }
    }
    
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_api release];
    [super dealloc];
}
@end
