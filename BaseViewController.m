//
//  BaseViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-6-27.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "BookshelfIndexViewController.h"
#import "ShowDetailViewController.h"
@interface BaseViewController ()

@end
static BaseViewController *sharedObj = nil; //第一步：静态实例，并初始化。
static NSMutableArray *CurrentDownList;
static NSString *isDownLoad;
Boolean isDownLoadStatus = NO;
@implementation BaseViewController
@synthesize curTimeVal = _curTimeVal;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:12.0 green:95.0 blue:250.0 alpha:1.0];
    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithTitle:@"我的书架" style:UIBarButtonSystemItemAction target:self action:@selector(myComics)] autorelease];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarStyleBlack target:self action:@selector(backPrevPage)] autorelease];
    self.navigationItem.leftBarButtonItem = leftItem;
}
+ (BaseViewController *) getGlobalData
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (NSMutableArray *) getCurrentDownList
{
    if (!CurrentDownList) {
        CurrentDownList = [[NSMutableArray alloc] init];
    }
    return CurrentDownList;
}
+ (void) setCurrentDownList:(DownComicInfo *)dInfo{
    if (!CurrentDownList) {
        CurrentDownList = [[NSMutableArray alloc] init];
    }
    
    [CurrentDownList addObject:dInfo];
}
+ (void) removeCurrentDownList:(int)pid
{
    for (int i=0;i<CurrentDownList.count;i++) {
        DownComicInfo *info = (DownComicInfo *)[CurrentDownList objectAtIndex:i];
        if ([info.pid intValue] == pid) {
            [CurrentDownList removeObject:info];
        }
    }
}
+ (NSString *) downLoadStatus
{
    return isDownLoad;
}
+ (void) setDownLoadStatus:(Boolean)b
{
    isDownLoad = b;
}
//一个view中是否存在一个tag为某一直的子view
+ (Boolean) viewExists:(UIView *)mView tag:(int)tag
{
    Boolean *exists = NO;
    for(UIView *view in mView.subviews){
        if(view.tag == tag){
            exists = YES;
        }
    }
    return exists;
}
//获取本地存储的全部下载项目列表
+ (NSMutableArray *)getSaveLocalDownList
{
    NSMutableArray *downList = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"downList.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
    }
    return downList;
}
//设置本地存储的全部下载项目列表
+ (void)setSaveLocalDownList:(NSMutableArray *)arr
{
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"downList.txt"];
    [arr writeToFile:path atomically:YES];
}

#pragma mark 我的书架
- (void)myComics
{
    NSArray *navBarViews = self.navigationController.navigationBar.subviews;
    for (id viewObj in navBarViews) {
        if ([viewObj isKindOfClass:[UISegmentedControl class]]) {
            [viewObj setHidden:YES];
        }
    }
    BookshelfIndexViewController *bsiVC = [[[BookshelfIndexViewController alloc] init] autorelease];
    [self.navigationController pushViewController:bsiVC animated:YES];
}
#pragma mark  浏览漫画
- (void) showDetailComic:(id)clickPid{
    
    int tapPid = 0;
    UIButton *btn = (UIButton *)clickPid;
    tapPid = btn.superview.tag;
    
    ShowDetailViewController *sdvc = [[[ShowDetailViewController alloc] init] autorelease];
    NSMutableArray *imgsArr = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *currentDownList = [BaseViewController getSaveLocalDownList];
    for (int i=0; i<currentDownList.count; i++) {
        NSDictionary *browseComicDict = [currentDownList objectAtIndex:i];
        int pid = [[browseComicDict objectForKey:@"pid"] intValue];
        
        if (pid == tapPid) {
            NSArray *pages = [browseComicDict objectForKey:@"pages"];
            for (id page in pages) {
                NSString *img = [page objectForKey:@"img"];
                NSString *str_intercepted = [img substringFromIndex:46];
//                NSString *str_character = @"/";
//                NSRange range = [str_intercepted rangeOfString:str_character];
//                NSString *str_complete = [str_intercepted substringToIndex:range.location];
                NSString *imgPath = [NSString stringWithFormat:@"%d/%@",pid,str_intercepted.lastPathComponent];
                [imgsArr addObject:imgPath];
            }
        }
    }
    sdvc.imgsArr = imgsArr;
    [self.navigationController pushViewController:sdvc animated:YES];
}
#pragma mark 返回上一页
- (void) backPrevPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
