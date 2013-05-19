//
//  ShowDetailViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-22.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import "ShowDetailViewController.h"

@interface ShowDetailViewController ()

@end

@implementation ShowDetailViewController
{
    
}
@synthesize imgsArr = _imgsArr;
@synthesize mainScroll = _mainScroll;
@synthesize currentImageCount = _currentImageCount;
@synthesize imageView1, imageView2, imageView3;
@synthesize dataList,currentPage,currentIndex;
@synthesize curScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.dataList = [[[NSMutableArray alloc] init] autorelease];
    
    self.navigationItem.title = @"漫画浏览";
    self.navigationController.navigationBarHidden = YES;
    int winWidth = self.view.frame.size.width;
    int winHeight = self.view.frame.size.height;
    
    _mainScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _mainScroll.contentSize = CGSizeMake(winWidth*3, winHeight-42);
    _mainScroll.pagingEnabled = YES;
    _mainScroll.maximumZoomScale = 1.0;
    _mainScroll.minimumZoomScale = 1.0;
    _mainScroll.showsVerticalScrollIndicator = NO;
    [_mainScroll setShowsHorizontalScrollIndicator:NO];
    _mainScroll.alwaysBounceHorizontal = NO;
    _mainScroll.alwaysBounceVertical = NO;
    _mainScroll.delegate = self;
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
    [_mainScroll addGestureRecognizer:tapClick];
    [self.view addSubview:_mainScroll];
    _arr=[[[NSMutableArray alloc] init] autorelease];

    for (int i=0; i<self.imgsArr.count; i++) {
        UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],[_imgsArr objectAtIndex:i]]];
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, winWidth, _mainScroll.frame.size.height)];
        subScrollView.tag = 1;
        subScrollView.delegate = self;
        subScrollView.maximumZoomScale = 1.5;
        subScrollView.minimumZoomScale = 1.0;
        subScrollView.alwaysBounceVertical = NO;
        subScrollView.alwaysBounceHorizontal = NO;
        UIImageView *imgView = [[[UIImageView alloc] initWithImage:img] autorelease];
        imgView.frame = subScrollView.bounds;
        [subScrollView addSubview:imgView];
        [self.dataList addObject:subScrollView];
    }
    self.currentIndex = 0;
    self.currentPage = 0;
    
    [self setPage];
}
// 设置UIScrollView中要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imgView = (UIImageView *)[self.curScrollView.subviews objectAtIndex:0];
    return imgView;
}

//滚动结束后
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    int pageWidth = scrollView.frame.size.width;
    int index = _mainScroll.contentOffset.x/pageWidth;
    if(index>currentIndex)
    {
        currentPage = currentPage+1==dataList.count?currentPage:currentPage+1;
    }
    else if(index<currentIndex)
    {
        currentPage = currentPage-1>=0?currentPage-1:dataList.count-1;
    }
    
    if (currentPage+1 < dataList.count) {
        for (UIScrollView *bv in self.mainScroll.subviews)
        {
            [bv removeFromSuperview];
        }
        [self setPage];
    }else if((currentPage+1) == dataList.count){
        self.currentIndex = 2;
    }
}
- (void) setPage
{
    UIScrollView *nv;
    int pageWidth = self.view.frame.size.width;
    if (self.currentPage == 0) {
        UIScrollView *cv = [dataList objectAtIndex:currentPage];
        cv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.curScrollView = cv;
        [self.mainScroll addSubview:cv];
    }else{
        UIScrollView *cv = [dataList objectAtIndex:currentPage];
        cv.frame = CGRectMake(pageWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.curScrollView = cv;
        [self.mainScroll addSubview:cv];
    }
    
    
    if (self.currentPage > 0) {
        int prvIndex = self.currentPage - 1;
        UIScrollView *pv = [self.dataList objectAtIndex:prvIndex];
        pv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.mainScroll addSubview:pv];
    }
    
    if ((self.currentPage+1) < self.dataList.count) {
        int nextIndex = self.currentPage+1;
        nv = [self.dataList objectAtIndex:nextIndex];
        nv.frame = CGRectMake(pageWidth*2, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.mainScroll addSubview:nv];
    }
    
    if (self.currentPage == 0) {
        currentIndex = 0;
        nv.frame = CGRectMake(pageWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.mainScroll setContentOffset:CGPointMake(0, 0)];
    }else {
        currentIndex = 1;
        [self.mainScroll setContentOffset:CGPointMake(pageWidth, 0)];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void) showNavigationBar
{
//    if (self.navigationController.navigationBar.alpha == 0.0) {
//        [UIView animateWithDuration:1.0 animations:^{
//            self.navigationController.navigationBar.alpha = 1.0;
//        }];
//    }else{
//        [UIView animateWithDuration:1.0 animations:^{
//            self.navigationController.navigationBar.alpha = 0.0;
//        }];
//    }
    if (self.navigationController.navigationBar.hidden) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }else{
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    _mainScroll.frame = self.view.bounds;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void) dealloc{
    [_imgsArr release];
    [super release];
}
@end
