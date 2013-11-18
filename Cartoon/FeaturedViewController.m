//
//  FeaturedViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-6.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FeaturedViewController.h"
#import "ListPageViewController1.h"
#import "PopularListController.h"
#import "DetailViewController.h"
#import "asiHTTP/ASIHTTPRequest.h"
#import "DetailClass.h"
#import "UIImage+UIImageExtras.h"
#import "LoadingViewController.h"
#import "SettingView.h"
#import <QuartzCore/QuartzCore.h>
#import "WelcomeViewController.h"
@interface FeaturedViewController ()

@end

@implementation FeaturedViewController
{
    int _segIndex;
}
@synthesize request = _request;
@synthesize mainScrollView = _mainScrollView;
@synthesize segControl = _segControl;
@synthesize currentModule;
@synthesize featuredSubModule0 = _featuredSubModule0, featuredSubModule1 = _featuredSubModule1;
@synthesize featuredSubModule2 = _featuredSubModule2;
@synthesize tabView = _tabView;

@synthesize dataList_M1 = _dataList_M1, dataList_M2 = _dataList_M2;
@synthesize leftView_M1 = _leftView_M1, leftImgView_M1 = _leftImgView_M1, leftLab1_M1 = _leftLab1_M1;
@synthesize leftLab2_M1 = _leftLab2_M1;
@synthesize rightView_M1 = _rightView_M1, rightImgView_M1 = _rightImgView_M1, rightLab1_M1 = _rightLab1_M1;
@synthesize rightLab2_M1 = _rightLab2_M1;

@synthesize featuredView;
@synthesize justAddedView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    _segControl.hidden = NO;
    self.title = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"首页";
    _api = [[NetAPI alloc] init];
    _api.delegate = self;
    
    NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]);
    //设置顶部导航栏
    _segControl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"推荐",@"最新更新",
                                                                                @"热门",nil]] autorelease];
    [_segControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    _segControl.tintColor = [UIColor grayColor];
    _segControl.frame = CGRectMake((self.view.frame.size.width-300)/2, 5, 300, 35);
    _segIndex = 0;
    _segControl.selectedSegmentIndex = 0;
    [_segControl addTarget:self action:@selector(clickSeg:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:_segControl];
    
    self.tabView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    
    //添加导航控制器左右按钮
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonSystemItemAction target:self action:@selector(openTool)] autorelease];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.currentModule = 0;
    //创建子栏目对应的UIView
    self.featuredSubModule0 = [[[UIView alloc] init] autorelease];
    self.featuredSubModule0.frame = [[UIScreen mainScreen] bounds];
    
    self.featuredSubModule1 = [[[UIView alloc] init] autorelease];
    self.featuredSubModule1.frame = [[UIScreen mainScreen] bounds];
    self.featuredSubModule1.hidden = YES;
    
    self.featuredSubModule2 = [[[UIView alloc] init] autorelease];
    self.featuredSubModule2.frame = [[UIScreen mainScreen] bounds];
    self.featuredSubModule2.hidden = YES;
    [self.view addSubview:self.featuredSubModule0];
    [self.view addSubview:self.featuredSubModule1];
    [self.view addSubview:self.featuredSubModule2];
    
    
    NSTimer *myTimer = [NSTimer  timerWithTimeInterval:0.5 target:self selector:@selector(getModuleData1)userInfo:nil repeats:NO];
    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark 获取第一个栏目数据
- (void) getModuleData1
{
    NSMutableDictionary *cmtData = [NSMutableDictionary dictionary];
    [cmtData setObject:@"full.featured.get" forKey:@"method"];
    [_api sendRequest:cmtData];
}
#pragma mark 获取第二个栏目的数据
- (void) getModuleData2
{
    NSMutableDictionary *cmtData = [NSMutableDictionary dictionary];
    [cmtData setObject:@"full.new.get" forKey:@"method"];
    [_api sendRequest:cmtData];
}
#pragma mark 获取第三个栏目的数据
- (void) getModuleData3
{
    NSMutableDictionary *cmtData = [NSMutableDictionary dictionary];
    [cmtData setObject:@"full.popular.products.get" forKey:@"method"];
    [_api sendRequest:cmtData];
}
//点击UISegmentedControl 触发事件
- (void)clickSeg:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.currentModule = 0;
            [self.featuredSubModule0 setHidden:NO];
            [self.featuredSubModule1 setHidden:YES];
            [self.featuredSubModule2 setHidden:YES];
            if (self.featuredSubModule0.subviews.count <= 0) {
                [self getModuleData1];
            }
            break;
        case 1:
            self.currentModule = 1;
            [self.featuredSubModule0 setHidden:YES];
            [self.featuredSubModule1 setHidden:NO];
            [self.featuredSubModule2 setHidden:YES];
            if (self.featuredSubModule1.subviews.count <= 0) {
                [self getModuleData2];
            }
            break;
        case 2:
        {
            self.currentModule = 2;
            [self.featuredSubModule0 setHidden:YES];
            [self.featuredSubModule1 setHidden:YES];
            [self.featuredSubModule2 setHidden:NO];
            if (self.featuredSubModule2.subviews.count <= 0) {
                [self getModuleData3];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark 左上角按钮事件
- (void)openTool{
    NSLog(@"you click left is item");
    if (![self.view viewWithTag:100]) {
        SettingView *setView = [[SettingView alloc] initWithFrame:CGRectMake(10, 800, 300, 600)];
        setView.tag = 100;
        [self.view addSubview:setView];
        [UIView animateWithDuration:0.3 animations:^{
            setView.frame = CGRectMake(10, 10, 300, 600);
        }];
        [setView release];
    }else{
        UIView *setView = [self.view viewWithTag:100];
        [UIView animateWithDuration:0.3 animations:^{
            setView.frame = CGRectMake(10, 800, 300, 600);
        } completion:^(BOOL finished) {
            [setView removeFromSuperview];
        }];
    
    }
}
#pragma mark 点击页面头部大图片，转到漫画列表页
- (void)imgTypeClick:(id)sender{
    _segControl.hidden = YES;
    int tag = [(UIGestureRecognizer *)sender view].tag;//获得uiimaageview的tag
    
    ListPageViewController1 *listPage = [[ListPageViewController1 alloc] init];
    listPage.listID = tag;
    [self.navigationController pushViewController:listPage animated:YES];
}
#pragma mark 跳转到漫画章节页
- (void)comicChapters:(id) sender{
    _segControl.hidden = YES;
    int tag = [(UIGestureRecognizer *)sender view].tag;
    DetailViewController *dvc = [[[DetailViewController alloc] init] autorelease];
    dvc.product_id = [NSString stringWithFormat:@"%d", tag];
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark 获取数据成功
- (void)requestDidFinished:(NSDictionary *)dict
{
    if (self.currentModule == 0) {
        [self setModulePage0:dict];
        WelcomeViewController *wvc = [[WelcomeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wvc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:nav animated:YES];
        [wvc release];
        [nav release];
    }else if(self.currentModule == 1){
        self.dataList_M1 = [dict objectForKey:@"lists"];
        [self setModulePage1];
    }else if(self.currentModule == 2){
        self.dataList_M2 = [dict objectForKey:@"lists"];
        [self setModulePage2];
    }
}
#pragma mark   数据请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
//    LOADINGDISMISS;
    SHOWALERT(@"获取数据失败");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int sec = 0;
    if (self.currentModule == 1) {
        sec = self.dataList_M1.count;
        if(sec == 1){
            sec = 1;
        }else if(sec%2 == 0){
            sec = sec/2;
        }else {
            sec = sec%2+1;
        }
    }
    return sec;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeatureCell_M1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    int row = indexPath.row;
    if (self.currentModule == 1) {
        int lpid = [[self.dataList_M1 objectAtIndex:row*2] objectForKey:@"id"];
//        NSString *lname = [[self.dataList_M1 objectAtIndex:row*2] objectForKey:@"name"];
        NSString *lcomic_name = [[self.dataList_M1 objectAtIndex:row*2] objectForKey:@"comic_name"];
        NSString *lintro = [[self.dataList_M1 objectAtIndex:row*2] objectForKey:@"intro"];
        NSString *lcover = [[self.dataList_M1 objectAtIndex:row*2] objectForKey:@"cover"];
        self.leftImgView_M1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:lcover]]];
        self.leftLab1_M1.text = lcomic_name;
        self.leftLab2_M1.text = lintro;
        self.leftView_M1.tag = lpid;
        UITapGestureRecognizer *leftGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)];
        self.leftView_M1.userInteractionEnabled = YES;
        [self.leftView_M1 addGestureRecognizer:leftGest];
        
        if (self.dataList_M1.count > ((row*2)+1)) {
            int rpid = [[self.dataList_M1 objectAtIndex:(row*2)+1] objectForKey:@"id"];
//            NSString *rname = [[self.dataList_M1 objectAtIndex:(row*2)+1] objectForKey:@"name"];
            NSString *rcomic_name = [[self.dataList_M1 objectAtIndex:(row*2)+1] objectForKey:@"comic_name"];
            NSString *rintro = [[self.dataList_M1 objectAtIndex:(row*2)+1] objectForKey:@"intro"];
            NSString *rcover = [[self.dataList_M1 objectAtIndex:(row*2)+1] objectForKey:@"cover"];
            self.rightImgView_M1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rcover]]];
            self.rightLab1_M1.text = rcomic_name;
            self.rightLab2_M1.text = rintro;
            self.rightView_M1.tag = rpid;
            UITapGestureRecognizer *rightGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downComic:)];
            self.rightView_M1.userInteractionEnabled = YES;
            [self.rightView_M1 addGestureRecognizer:rightGest];
        }
    }
    
    return cell;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
#pragma mark 绘制第一个栏目
- (void) setModulePage0:(NSDictionary *)dictionary
{
    UIView *topView = [[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 430)] autorelease];
    UIImageView *topImg1 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]] autorelease];
    topImg1.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    topImg1.layer.borderWidth = 3;
    topImg1.frame = CGRectMake(0, 0, 482, 430);
    UIImageView *topImg2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]] autorelease];
    topImg2.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    topImg2.layer.borderWidth = 3;
    topImg2.frame = CGRectMake(492, 0, 235, 205);
    UIImageView *topImg3 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]] autorelease];
    topImg3.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    topImg3.layer.borderWidth = 3;
    topImg3.frame = CGRectMake(492, 225, 235, 205);
    topImg1.userInteractionEnabled = YES;
    topImg2.userInteractionEnabled = YES;
    topImg3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImg1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTypeClick:)] autorelease];
    UITapGestureRecognizer *tapImg2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTypeClick:)] autorelease];
    UITapGestureRecognizer *tapImg3 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTypeClick:)] autorelease];
    [topImg1 addGestureRecognizer:tapImg1];
    [topImg2 addGestureRecognizer:tapImg2];
    [topImg3 addGestureRecognizer:tapImg3];
    [topView addSubview:topImg1];
    [topView addSubview:topImg2];
    [topView addSubview:topImg3];
    
    
    UIView *midView = [[[UIView alloc] init] autorelease];
    midView.frame = CGRectMake(20, 440, self.view.frame.size.width-40, 125);
    UIImageView *midImg1 = [[[UIImageView alloc] initWithImage:nil] autorelease];
    midImg1.layer.borderWidth = 3;
    midImg1.userInteractionEnabled = YES;
    midImg1.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    UIImageView *midImg2 = [[[UIImageView alloc] initWithImage:nil] autorelease];
    midImg2.layer.borderWidth = 3;
    midImg2.userInteractionEnabled = YES;
    midImg2.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    UIImageView *midImg3 = [[[UIImageView alloc] initWithImage:nil] autorelease];
    midImg3.layer.borderWidth = 3;
    midImg3.userInteractionEnabled = YES;
    midImg3.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    midImg1.frame = CGRectMake(0, 0, 235, 125);
    midImg2.frame = CGRectMake(245, 0, 235, 125);
    midImg3.frame = CGRectMake(490, 0, 235, 125);
    UITapGestureRecognizer *tapImg4 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTypeClick:)] autorelease];
    UITapGestureRecognizer *tapImg5 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTypeClick:)] autorelease];
    UITapGestureRecognizer *tapImg6 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTypeClick:)] autorelease];
    [midImg1 addGestureRecognizer:tapImg4];
    [midImg2 addGestureRecognizer:tapImg5];
    [midImg3 addGestureRecognizer:tapImg6];
    [midView addSubview:midImg1];
    [midView addSubview:midImg2];
    [midView addSubview:midImg3];
    
    
    UIScrollView *mainScrollView = [[[UIScrollView alloc] init] autorelease];
    mainScrollView.frame = CGRectMake(0, 10, 828, 900);
    [mainScrollView addSubview:topView];
    [mainScrollView addSubview:midView];
    int mainHeight =  topView.frame.size.height+midView.frame.size.height;
//    mainScrollView.frame = bounds;
    [self.featuredSubModule0 addSubview:mainScrollView];
    NSArray *specials=[dictionary objectForKey:@"specials"];
    for (int i=0; i<specials.count; i++) {
        int id = [[[specials objectAtIndex:i] objectForKey:@"id"] intValue];
        NSString *banner = [[specials objectAtIndex:i] objectForKey:@"pad2"];
//        NSString *name = [[specials objectAtIndex:i] objectForKey:@"name"];
    
            //为头部大图片添加点击事件
            UIImage *topImgBanner = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            UIImage *topImgBanner2;
            if(i == 0){
                topImgBanner2 = [topImgBanner imageByScalingToSize:CGSizeMake(482, 430)];
                topImg1.tag = id;
                topImg1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            }else if(i == 1){
                topImgBanner2 = [topImgBanner imageByScalingToSize:CGSizeMake(235, 205)];
                topImg2.tag = id;
                topImg2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            }
            if(i == 2){
                
                topImgBanner2 = [topImgBanner imageByScalingToSize:CGSizeMake(235, 205)];
                topImg3.tag = id;
                topImg3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            }
            if (i == 3) {
                topImgBanner2 = [topImgBanner imageByScalingToSize:CGSizeMake(235, 125)];
                midImg1.tag = id;
                midImg1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            }
            if (i == 4) {
                midImg2.tag = id;
                midImg2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            }
            if (i == 5) {
                midImg3.tag = id;
                midImg3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner]]];
            }
    }
    
    //商品分类
    NSArray *lists = [dictionary objectForKey:@"lists"];
    for (int j=0; j<lists.count; j++) {
        int type = [[[lists objectAtIndex:j] objectForKey:@"type"] intValue];
        NSString *name = [[lists objectAtIndex:j] objectForKey:@"name"];
        NSArray *products = [[lists objectAtIndex:j] objectForKey:@"products"];
        if(type == 0){
            UIView *listView = [[[UIView alloc] init] autorelease];
            listView.frame =  CGRectMake(20, 575+(mainScrollView.subviews.count-2)*260+j*10, self.view.frame.size.width-40, 260);
            listView.layer.borderWidth = 3;
            listView.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
            CGRect rect = CGRectMake(0, 0, listView.frame.size.width, listView.frame.size.height);
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = rect;
            //渐变颜色，可以调，各种样式的。
            gradient.colors = [NSArray arrayWithObjects:
                               (id)[RGBCOLOR(191, 207, 232,1) CGColor],
                               (id)[RGBCOLOR(177, 193, 216,1) CGColor],
                               (id)[RGBCOLOR(160, 171, 191,1) CGColor],
                               (id)[RGBCOLOR(131, 140, 157,1) CGColor],
                               (id)[RGBCOLOR(107, 115, 130,1) CGColor],
                               (id)[RGBCOLOR(91, 97, 111,1) CGColor],
                               (id)[RGBCOLOR(66, 72, 78,1) CGColor],
                               (id)[RGBCOLOR(21, 22, 24,1) CGColor],
                               nil];
            [listView.layer insertSublayer:gradient atIndex:0];
            
            UIView *listTitleView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width-40, 30)];
            listTitleView1.backgroundColor = [UIColor viewFlipsideBackgroundColor];
            listTitleView1.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            UILabel *listTitleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            listTitleLab1.backgroundColor = [UIColor clearColor];
            listTitleLab1.text = name;
            listTitleLab1.textColor = [UIColor whiteColor];
            listTitleLab1.font = [UIFont boldSystemFontOfSize:14.0];
            [listTitleView1 addSubview:listTitleLab1];
            UILabel *allComicLab = [[[UILabel alloc] initWithFrame:CGRectMake(listTitleView1.frame.size.width-100, 0, 100, 30)] autorelease];
            allComicLab.backgroundColor = [UIColor clearColor];
            allComicLab.text = @"全部漫画>>";
            allComicLab.textColor = [UIColor whiteColor];
            [listTitleView1 addSubview:allComicLab];
            [listView addSubview:listTitleView1];
            UIScrollView *fvcScrollView1 = [[[UIScrollView alloc] init] autorelease];
            fvcScrollView1.frame = CGRectMake(0, 40, self.view.frame.size.width-40, listView.frame.size.height);
            for(int i=0;i<products.count;i++) {
                int pid = [[[products objectAtIndex:i] objectForKey:@"id"] intValue];
                NSString *imgUrl = [[products objectAtIndex:i] objectForKey:@"cover"];
                NSString *name = [[products objectAtIndex:i] objectForKey:@"name"];
                NSString *comic_name = [[products objectAtIndex:i] objectForKey:@"comic_name"];
                
                UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(i*120+10*i+10, 0, 120, 160)] autorelease];
                UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_bookBg.png"]] autorelease];
                bgView.frame = view.bounds;
                [view addSubview:bgView];
                [view sendSubviewToBack:bgView];
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
                imgView.frame = CGRectMake(4, 0, 109, 156);
                imgView.userInteractionEnabled = YES;
                imgView.tag = pid;
                UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comicChapters:)];
                [imgView addGestureRecognizer:imgTap];
                [view addSubview:imgView];
                UILabel *nameLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height+5, view.frame.size.width, 15)] autorelease];
                nameLab.text = name;
                nameLab.textColor = [UIColor whiteColor];
                nameLab.backgroundColor = [UIColor clearColor];
                nameLab.textAlignment = UITextAlignmentCenter;
                UILabel *comic_nameLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height+27, view.frame.size.width, 15)] autorelease];
                comic_nameLab.text = comic_name;
                comic_nameLab.textAlignment = UITextAlignmentCenter;
                comic_nameLab.textColor = RGBCOLOR(154, 154, 154, 1);
                comic_nameLab.backgroundColor = [UIColor clearColor];
                UIFont *font = [UIFont fontWithName:@"Arial" size:14.0];
                comic_nameLab.font = font;
                [view addSubview:nameLab];
                [view addSubview:comic_nameLab];
                [fvcScrollView1 addSubview:view];
            }
            fvcScrollView1.maximumZoomScale = 1;
            fvcScrollView1.minimumZoomScale = 1;
            fvcScrollView1.contentSize = CGSizeMake(products.count*120+products.count*10, 160);
            fvcScrollView1.showsHorizontalScrollIndicator = NO;
            fvcScrollView1.showsVerticalScrollIndicator = NO;
            [listView addSubview:fvcScrollView1];
            [mainScrollView addSubview:listView];
            mainHeight += listView.frame.size.height+j*10;
        }
    }
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,mainHeight+30);
}
#pragma mark 绘制第二个栏目
- (void) setModulePage1
{
    if (self.dataList_M1.count > 0) {
        [self.featuredSubModule1 addSubview:self.tabView];
    }else{
        SHOWALERT(@"暂无数据");
    }
}
#pragma mark 绘制第三个栏目
- (void) setModulePage2
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        
    }
	return NO;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortraitUpsideDown;
//    return UIInterfaceOrientationMaskLandscape; //UIInterfaceOrientationMaskLandscape、UIInterfaceOrientationMaskAll、 UIInterfaceOrientationMaskAllButUpsideDown
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) dealloc
{
    [_api release];
    [self.request release];
    [self.mainScrollView release];
    [self.segControl release];
    [self.featuredSubModule0 release];
    [self.featuredSubModule1 release];
    [self.featuredSubModule2 release];
    [self.tabView release];
    [self.dataList_M1 release];
    [self.leftView_M1 release];
    [self.leftImgView_M1 release];
    [self.leftLab1_M1 release];
    [self.leftLab2_M1 release];
    [self.rightView_M1 release];
    [self.rightImgView_M1 release];
    [self.rightLab1_M1 release];
    [self.rightLab2_M1 release];
    [super dealloc];
}
@end
