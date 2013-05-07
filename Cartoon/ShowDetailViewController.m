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
@synthesize arr= _arr;
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
    self.navigationItem.title = @"漫画浏览";
    self.navigationController.navigationBarHidden = YES;
    int winWidth = self.view.frame.size.width;
    int winHeight = self.view.frame.size.height;
    _mainScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _mainScroll.contentSize = CGSizeMake(_imgsArr.count*winWidth, winHeight-42);
    _mainScroll.pagingEnabled = YES;
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
    [_mainScroll addGestureRecognizer:tapClick];
    _arr=[[NSMutableArray alloc] init];
    int cou = 0;
    if (_imgsArr.count>15) {
        cou = 15;
    }else{
        cou = _imgsArr.count;
    }
    for (int i=0; i<cou; i++) {
        UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],[_imgsArr objectAtIndex:i]]];
        UIImageView *imgView=[[[UIImageView alloc] initWithImage:img] autorelease];
        UIScrollView *_subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(768*i, 0, winWidth, _mainScroll.frame.size.height)];
        _subScrollView.delegate = self;
        _subScrollView.maximumZoomScale = 2.0;
        _subScrollView.minimumZoomScale = 1.0;
        _subScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imgView.frame = _subScrollView.bounds;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_subScrollView addSubview:imgView];
        [_arr addObject:imgView];
        [_mainScroll addSubview:_subScrollView];
    }
    [self.view addSubview:_mainScroll];
}
// 设置UIScrollView中要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    int index=_mainScroll.contentOffset.x/768;
    UIImageView *view = [_arr objectAtIndex:index];
    return view;
}
//滚动结束后
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    int index = scrollView.contentOffset.x;
    NSLog(@"%d",index);
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
    float x = (self.view.frame.size.width-768)/2;
    _mainScroll.contentSize = CGSizeMake(_imgsArr.count*768, self.view.frame.size.height);
    _mainScroll.frame = CGRectMake(x, 0, 768, self.view.frame.size.height);
	return YES;
}
- (void) dealloc{
    [_imgsArr release];
    [_mainScroll release];
    [_arr release];
    [super release];
}
@end
