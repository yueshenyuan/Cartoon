//
//  ListPageViewController1.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-8.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ListPageViewController1.h"
#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
@interface ListPageViewController1 ()

@end

@implementation ListPageViewController1
@synthesize mainScrollView = _mainScrollView;
@synthesize mainView = _mainView;
@synthesize topView = _topView;
@synthesize winHV = _winHV;
@synthesize listView = _listView;
@synthesize tabView = _tabView;
@synthesize listID = _listID;
@synthesize listArr = _listArr;
@synthesize mcell = _mcell;
@synthesize leftView = _leftView, rightView = _rightView;
@synthesize leftCellImg1 = _leftCellImg1, leftCellLab1 = _leftCellLab1, leftCellLab2 = _leftCellLab2, leftCellBtn = _leftCellBtn;
@synthesize rightCellImg1 = _rightCellImg1, rightCellLab1 = _rightCellLab1, rightCellLab2 = _rightCellLab2, rightCellBtn = _rightCellBtn;
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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"推荐主题";
    
    _api = [[NetAPI alloc] init];
    _api.delegate = self;
    _mainScrollView = [[[UIScrollView alloc] init] autorelease];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainView = [[[UIView alloc] init] autorelease];
    self.listArr = [[[NSMutableArray alloc] init] autorelease];
    
    int special_id = self.listID;
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    [mdict setValue:@"full.special.get" forKey:@"method"];
    [mdict setValue:[NSString stringWithFormat:@"%d",special_id] forKey:@"special_id"];
    [_api sendRequest:mdict];
    
    _topView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)] autorelease];
    _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    //生成分类列表
//    _listView = [[[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 600)] autorelease];
//    _listView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _tabView = [[[UITableView alloc] initWithFrame:CGRectMake(-20,300, 768+40, 600) style:UITableViewStyleGrouped] autorelease];
    _tabView.hidden = YES;
    _tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.scrollEnabled = NO;
    _tabView.backgroundView = nil;
    _tabView.backgroundColor = [UIColor clearColor];
    _tabView.sectionHeaderHeight = 30.0;
//    [_listView addSubview:_tabView];
//    _mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, _topView.frame.size.height+_listView.frame.size.height+500);
//    _mainScrollView.contentSize = _mainView.frame.size;
    
//    [_mainView addSubview:_topView];
//    [_mainView addSubview:_tabView];
    [_mainScrollView addSubview:_topView];
    [_mainScrollView addSubview:_tabView];
    [self.view addSubview:_mainScrollView];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return  [[self.listArr objectAtIndex:section] objectForKey:@"name"];
//}
#pragma  mark 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArr.count;
}

#pragma mark 返回分组标题View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(60, 0, tableView.frame.size.width-60, 20)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *nameLab = [[[UILabel alloc] initWithFrame:CGRectMake(50, 0, headerView.frame.size.width, 20)] autorelease];
    nameLab.text = [[self.listArr objectAtIndex:section] objectForKey:@"name"];
    nameLab.font = [UIFont boldSystemFontOfSize:20.0f];
    nameLab.textColor = [UIColor blackColor];
    nameLab.backgroundColor = [UIColor clearColor];
    [headerView addSubview:nameLab];
    return  headerView;
}
#pragma mark 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *obj = [self.listArr objectAtIndex:section];
    int type = [[obj objectForKey:@"type"] intValue];
    
    NSArray *rowArr;
    if (type == 0) {
        rowArr = [obj objectForKey:@"products"];
    }else{
        rowArr = [obj objectForKey:@"comics"];
    }
    
    int sec = rowArr.count;
    if(sec == 1){
        sec = 1;
    }else if(sec%2 == 0){
        sec = sec/2;
    }else {
        sec = sec%2+1;
    }
    return sec;
}
#pragma 绘制cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    int type = [[[self.listArr objectAtIndex:section] objectForKey:@"type"] intValue];
    static NSString *CellIdentifier;
    if (type == 0) {
        CellIdentifier = @"listPageCell1";
    }else{
        CellIdentifier = @"listPageCell2";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.backgroundView = nil;
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = RGBCOLOR(16, 16, 16, 1);
    }else{
        cell.backgroundColor = RGBCOLOR(37, 37, 37, 1);
    }
    
    if (type == 0) {
        NSArray *productsArr = [[self.listArr objectAtIndex:section] objectForKey:@"products"];
        int leftId = [[productsArr objectAtIndex:row*2] objectForKey:@"id"];
        NSString *leftComic_name = [[productsArr objectAtIndex:row*2] objectForKey:@"comic_name"];
        NSString *leftName = [[productsArr objectAtIndex:row*2] objectForKey:@"name"];
        NSString *leftCover = [[productsArr objectAtIndex:row*2] objectForKey:@"cover"];
        
        int rightId = [[productsArr objectAtIndex:(row*2)+1] objectForKey:@"id"];
        NSString *rightComic_name = [[productsArr objectAtIndex:(row*2)+1] objectForKey:@"comic_name"];
        NSString *rightName = [[productsArr objectAtIndex:(row*2)+1] objectForKey:@"name"];
        NSString *rightCover = [[productsArr objectAtIndex:(row*2)+1] objectForKey:@"cover"];
        self.leftCellLab1.text = leftComic_name;
        self.leftCellLab2.text = leftName;
        self.leftCellImg1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:leftCover]]];
        self.leftView.tag = leftId;
        UITapGestureRecognizer *leftGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)];
        self.leftView.userInteractionEnabled = YES;
        [self.leftView addGestureRecognizer:leftGest];
        
        self.rightCellLab1.text = rightComic_name;
        self.rightCellLab2.text = rightName;
        self.rightCellImg1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rightCover]]];
        self.rightView.tag = rightId;
        UITapGestureRecognizer *rightGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)];
        self.rightView.userInteractionEnabled = YES;
        [self.rightView addGestureRecognizer:rightGest];
        UIView *leftBorderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, self.leftView.frame.size.height)] autorelease];
        leftBorderView.backgroundColor = RGBCOLOR(59, 59, 59, 1);
        [self.rightView addSubview:leftBorderView];
    }else{
        NSArray *comicsArr = [[self.listArr objectAtIndex:section] objectForKey:@"comics"];
        NSDictionary *lobj = [comicsArr objectAtIndex:row*2];
<<<<<<< HEAD
        int lcid = [[lobj objectForKey:@"id"] intValue];
=======
//        int lcid = [[lobj objectForKey:@"id"] intValue];
>>>>>>> 8231f451831a9eb694ecf29ae35d7c1c10ac4c0e
        int lproduct_count = [lobj objectForKey:@"product_count"];
        NSString *ltitle = [lobj objectForKey:@"title"];
        NSString *lcover = [lobj objectForKey:@"cover"];
        
        UIImageView *limg = (UIImageView *)[cell viewWithTag:201];
        UILabel *llab1 = (UILabel *)[cell viewWithTag:202];
        UILabel *llab2 = (UILabel *)[cell viewWithTag:203];
        limg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:lcover]]];
        llab1.text = ltitle;
        llab2.text = [NSString stringWithFormat:@"%d",lproduct_count];
        if (comicsArr.count > (row*2+1)) {
            NSDictionary *robj = [comicsArr objectAtIndex:0];
<<<<<<< HEAD
            int rcid = [[robj objectForKey:@"id"] intValue];
=======
//            int rcid = [[robj objectForKey:@"id"] intValue];
>>>>>>> 8231f451831a9eb694ecf29ae35d7c1c10ac4c0e
            int rproduct_count = [robj objectForKey:@"product_count"];
            NSString *rtitle = [robj objectForKey:@"title"];
            NSString *rcover = [robj objectForKey:@"cover"];
            UIImageView *rimg = (UIImageView *)[cell viewWithTag:205];
            UILabel *rlab1 = (UILabel *)[cell viewWithTag:206];
            UILabel *rlab2 = (UILabel *)[cell viewWithTag:207];
            rimg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rcover]]];
            rlab1.text = rtitle;
            rlab2.text = [NSString stringWithFormat:@"%d",rproduct_count];
        }
    
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark 点击 Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc = [[[DetailViewController alloc] init] autorelease];
    dvc.product_id = @"15";
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        _winHV = YES;
    }else{
        _winHV = NO;
    }
    _mainView.frame=CGRectMake(0, 0, self.view.frame.size.width, 1000);
     _mainScrollView.frame = self.view.frame;
    [_tabView reloadData];
	return YES;
}

#pragma mark 获取数据成功
- (void)requestDidFinished:(NSDictionary *)dict
{
    NSString *banner = [[dict objectForKey:@"special"] objectForKey:@"banner"];
    self.listArr = [dict objectForKey:@"lists"];
    
    NSArray *rowArr1 = [[self.listArr objectAtIndex:0] objectForKey:@"products"];
    NSArray *rowArr2 = [[self.listArr objectAtIndex:0] objectForKey:@"comics"];
    int sec = rowArr1.count + rowArr2.count;
    if(sec%2 == 0){
        sec = sec/2;
    }else {
        sec = sec%2+1;
    }
    _tabView.frame = CGRectMake(-20, 300, 768+40, sec*180+self.listArr.count*60);
    CGSize contentSize = CGSizeMake(self.view.frame.size.width, _tabView.frame.origin.y+_tabView.frame.size.height);
    _mainScrollView.contentSize = contentSize;
    [self.tabView reloadData];
    //头部大图
    UIImage *topImg = [UIImage imageWithData:[NSData dataWithContentsOfURL: [ NSURL URLWithString:banner]]];
    UIImageView *topImgView = [[[UIImageView alloc] initWithImage:topImg] autorelease];
    topImgView.frame = CGRectMake(0, 0, _topView.frame.size.width, 300);
    topImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_topView addSubview:topImgView];
    _tabView.hidden = NO;
    
}
#pragma mark 跳转漫画详情页
- (void) downComic:(UITapGestureRecognizer *)tap
{
    int pid = tap.view.tag;
    
    DetailViewController *dvc = [[[DetailViewController alloc] init] autorelease];
    dvc.product_id = pid;
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    LOADINGDISMISS;
    SHOWALERT(@"获取数据失败");
}

- (void) dealloc
{
    [_api release];
    [self.mainScrollView release];
    [self.mainView release];
    [self.topView release];
    [self.listView release];
    [self.tabView release];
    [self.listArr release];
    [self.mcell release];
    [self.leftView release];
    [self.rightView release];
    [self.leftCellImg1 release];
    [self.leftCellLab1 release];
    [self.leftCellLab2 release];
    [self.leftCellBtn release];
    [self.rightCellImg1 release];
    [self.rightCellLab1 release];
    [self.rightCellLab2 release];
    [self.rightCellBtn release];
    [super dealloc];
}
@end
