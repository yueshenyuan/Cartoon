//
//  DetailViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-8.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//
#import "GlobalData.h"
#import "DetailViewController.h"
#import "CoverFlowView.h"
#import "DetailClass.h"
#import "ASIHTTPRequest.h"
#import "DownLoadViewController.h"
#import "DownComicInfo.h"
#import "DownComicInfo.h"
#import "UIImage+UIImageExtras.h"
@interface DetailViewController ()

@end



@implementation DetailViewController
@synthesize delete = _delete;
@synthesize product_id = _product_id;
@synthesize coverFlowView = _coverFlowView;
@synthesize imgArr = _imgArr;
@synthesize netWordType = _netWordType;

@synthesize productNameLab = _productNameLab, comicNameLab = _comicNameLab, downBtn = _downBtn;
@synthesize summaryTextView = _summaryTextView;
@synthesize previewsView = _previewsView;
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
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    NSString *urlStr = [NSString stringWithFormat:@"%@interface.action?method=full.product.get&product_id=%@&format=json",API_URL,self.product_id];
    
    NSURL *url = [NSURL URLWithString: urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
    self.netWordType = @"detail";
    LOADINGSHOW_MESSAGE(nil, DISMODELODING);
    
    [self.downBtn addTarget:self action:@selector(downFun) forControlEvents:UIControlEventTouchUpInside];
}
//coverflow中选择某一商品后,加载商品详细信息
-(void)ClickCurrentImageIndex:(int)theIndex
{
    NSString *pid = [[self.imgArr objectAtIndex:theIndex] objectForKey:@"id"];
    self.product_id = pid;
    NSString *urlStr = [NSString stringWithFormat:@"%@interface.action?method=full.product.get&product_id=%@&format=json",API_URL,pid];
    NSURL *url = [NSURL URLWithString:urlStr];
    self.netWordType = @"detail2";
    LOADINGSHOW_MESSAGE(nil, DISMODELODING);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}
//获取数据成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    LOADINGDISMISS;
    NSData *data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [data objectFromJSONData];
    if ([self.netWordType isEqualToString:@"detail"]) {
        self.imgArr = [dict objectForKey:@"all_products"];
        
        NSMutableArray *sourceImages = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < self.imgArr.count; i++) {
            NSString *cover = [[self.imgArr objectAtIndex:i] objectForKey:@"cover"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cover]]];
            image = [image imageByScalingToSize:CGSizeMake(200, 300)];
            if (image) {
                [sourceImages addObject:image];
            }else{
                UIImage *defImg = [[UIImage imageNamed:@"vimg.png"] imageByScalingToSize:CGSizeMake(200, 300)];
                [sourceImages addObject:defImg];
            }
        }
        //初始化coverflow模块
        CoverFlowView *coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 250) andImages:sourceImages sideImageCount:2 sideImageScale:0.8 middleImageScale:0.8 currentImgIndex:0];
        coverFlowView.delegate=self;
        coverFlowView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:coverFlowView];
        
        NSString *name = [[dict objectForKey:@"product"] objectForKey:@"name"];
        NSString *comic_name = [[dict objectForKey:@"product"] objectForKey:@"comic_name"];
        NSString *intro = [[dict objectForKey:@"product"] objectForKey:@"intro"];
        NSArray *previews = [[dict objectForKey:@"product"] objectForKey:@"previews"];
        self.productNameLab.text = name;
        self.comicNameLab.text = comic_name;
        self.summaryTextView.text = intro;
        for (int i=0;i<previews.count;i++) {
            NSDictionary *prevDict = (NSDictionary *)[previews objectAtIndex:i];
            NSString *thumb = [prevDict objectForKey:@"thumb"];
            UIImage *prevImg = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]]];
            UIImageView *prevImgView = [[UIImageView alloc] initWithImage:prevImg];
            prevImgView.frame = CGRectMake(i*150+i*10, 5, 150, 190);
            [self.previewsView addSubview:prevImgView];
        }
    }else if([self.netWordType isEqualToString:@"detail2"]){
        NSString *name = [[dict objectForKey:@"product"] objectForKey:@"name"];
        NSString *comic_name = [[dict objectForKey:@"product"] objectForKey:@"comic_name"];
        NSString *intro = [[dict objectForKey:@"product"] objectForKey:@"intro"];
        NSArray *previews = [[dict objectForKey:@"product"] objectForKey:@"previews"];
        self.productNameLab.text = name;
        self.comicNameLab.text = comic_name;
        self.summaryTextView.text = intro;
        for (UIImageView *subView in self.previewsView.subviews) {
            [subView removeFromSuperview];
        }
        for (int i=0;i<previews.count;i++) {
            NSDictionary *prevDict = (NSDictionary *)[previews objectAtIndex:i];
            NSString *thumb = [prevDict objectForKey:@"thumb"];
            UIImage *prevImg = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]]];
            UIImageView *prevImgView = [[UIImageView alloc] initWithImage:prevImg];
            prevImgView.frame = CGRectMake(i*150+i*10, 5, 150, 190);
            [self.previewsView addSubview:prevImgView];
        }
    }else if([self.netWordType isEqualToString:@"down"]){
        int pid0 = [[[dict objectForKey:@"product"] objectForKey:@"id"] intValue];
        NSString *pid = [NSString stringWithFormat:@"%d", pid0];
        NSString *cover = [[dict objectForKey:@"product"] objectForKey:@"cover"];
        NSString *title = [[dict objectForKey:@"product"] objectForKey:@"name"];
        NSArray *pages = [dict objectForKey:@"pages"];
        
        //加入当前正在下载序列
        DownComicInfo *downInfo = [[[DownComicInfo alloc] init] autorelease];
        downInfo.pid = pid;
        downInfo.name = title;
        downInfo.icon = cover;
        downInfo.downList = pages;
        [GlobalData setCurrentDownList:downInfo];
        //判断当前是否正在下载状态，如下载中，则不立即进行下载。
        //将所有下载项存入磁盘
        NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"downList.txt"];
        NSMutableDictionary *saveHistoryDcit = [NSMutableDictionary dictionaryWithObjectsAndKeys:pid,@"pid",cover,@"cover",title,@"title",pages,@"pages",@"down",@"downStatus", nil];
        NSMutableArray *downListArr;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
            downListArr = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
            [downListArr addObject:saveHistoryDcit];
        }else{
            downListArr = [NSMutableArray arrayWithObjects:saveHistoryDcit, nil];
        }
        [downListArr writeToFile:path atomically:YES];
        
        NSDictionary *downInfoDict = [NSDictionary dictionaryWithObject:downInfo forKey:@"downInfo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"button1" object:downInfoDict];//注意object属性
        
    }
}
//获取数据失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    LOADINGDISMISS;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) downFun
{
    Boolean *b = [self isDownExistence:self.product_id];
    if (!b) {
        SHOWALERT(@"您已下载该商品");
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@interface.action?method=full.product.download.get&product_id=%@&format=json",API_URL,self.product_id];
    NSURL *url = [NSURL URLWithString:urlStr];
    self.netWordType = @"down";
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
    request.delegate = self;
    [request startAsynchronous];
    LOADINGSHOW_MESSAGE(nil, DISMODELODING);
}
//判断将要下载的文件是否已存在下载序列
- (Boolean)isDownExistence:(NSString *)pid
{
    Boolean *b = YES;
    NSMutableArray *arr = [GlobalData getSaveLocalDownList];
    //检查将要下载的商品是否已被下载或正在下载中
    for (NSDictionary *pDict in arr) {
        if ([pid intValue] == [[pDict objectForKey:@"pid"] intValue]) {
            b = NO;
        }
    }
    return b;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) dealloc
{
    [self.product_id release];
    [self.coverFlowView release];
    [self.imgArr release];
    [self.netWordType release];
    [self.productNameLab release];
    [self.comicNameLab release];
    [self.downBtn release];
    [self.summaryTextView release];
    [self.previewsView release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}



@end
