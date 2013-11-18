//
//  SearchViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-7-29.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    self.searchBar.hidden = NO;
    self.title = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _api = [[NetAPI alloc] init];
    _api.delegate = self;
    
    self.searchBar = [[[UISearchBar alloc] init] autorelease];
    self.searchBar.delegate = self;
    CGRect rect = self.view.frame;
    self.searchBar.frame = CGRectMake((rect.size.width-500)/2, 2, 500, 40);
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
    
    [self closeKeyboard];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    NSString *val = searchBar.text;
    NSMutableDictionary *cmtData = [NSMutableDictionary dictionary];
    [cmtData setObject:@"full.search.get" forKey:@"method"];
    [cmtData setObject:val forKey:@"keyword"];
    [_api sendRequest:cmtData];
}
#pragma mark 获取数据成功
- (void)requestDidFinished:(NSDictionary *)dict
{
    NSArray *lists = (NSArray *)[dict objectForKey:@"lists"];
    
    if (lists.count > 0) {
        NSArray *comics = (NSArray *)[[lists objectAtIndex:0] objectForKey:@"comics"];
        if (comics.count > 0) {
            int row = 0;
            NSArray *views = [self.view subviews];
            for(UIView *view in views)
            {
                if ([view isKindOfClass:[UIView class]] && ![view isKindOfClass:[UIControl class]]) {
                  [view removeFromSuperview];
                }
            }
            for (int i=0;i<comics.count;i++) {
                NSDictionary *obj = [comics objectAtIndex:i];
                NSString *cover = (NSString *)[obj objectForKey:@"cover"];
                int pid = [[obj objectForKey:@"id"] intValue];
                int product_count = [[obj objectForKey:@"product_count"] intValue];
                NSString *title = (NSString *)[obj objectForKey:@"title"];
                
                if (i%4 == 0) {
                    row = i/4;
                }
                
                UIView *itemView = [[[UIView alloc] init] autorelease];
                itemView.frame = CGRectMake((i%4)*190+10, row*250+10*row, 200, 250);
                itemView.tag = pid;
                UITapGestureRecognizer *tapGest = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)] autorelease];
                [itemView addGestureRecognizer:tapGest];
                UIImageView *itemImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 180, 220)] autorelease];
                itemImg.layer.borderWidth = 3;
                itemImg.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
                itemImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cover]]];
                
                UILabel *itemLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 220, 180, 30)] autorelease];
                itemLab.text = title;
                itemLab.textAlignment = UITextAlignmentCenter;
                [itemView addSubview:itemImg];
                [itemView addSubview:itemLab];
                
                [self.view addSubview:itemView];
                
            }
        }else{
            SHOWALERT(@"未查询到相应作品，请更改关键字重新搜索");
        }
    }
}
#pragma mark   数据请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    LOADINGDISMISS;
    SHOWALERT(@"获取数据失败");
}
//到达详情页
- (void)downComic:(UITapGestureRecognizer *)tapGest
{
    int pid = tapGest.view.tag;
    DetailViewController *dvc = [[[DetailViewController alloc] init] autorelease];
    dvc.product_id = [NSString stringWithFormat:@"%d",pid];
    NSArray *views = self.navigationController.navigationBar.subviews;
    for (id view in views) {
        if ([view isKindOfClass:[UISearchBar class]]) {
            UISearchBar *seg = (UISearchBar *)view;
            seg.hidden = YES;
        }
    }
    [self.navigationController pushViewController:dvc animated:YES];
}

//关闭键盘
- (void) closeKeyboard
{
    //创建一个UIControl对象
    UIControl *bgControl = [[UIControl alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    [bgControl addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgControl];
    //将UIControl移动到view的最底层
    [self.view sendSubviewToBack:bgControl];
}
//点击背景关闭键盘
- (void)backgroundTap:(id)sender{
    //使UITextField对象失去焦点
    [self.searchBar resignFirstResponder];
}
- (void)dealloc{
    [self.searchBar release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
