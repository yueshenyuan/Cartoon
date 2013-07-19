//
//  BaseViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-6-27.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "BaseViewController.h"

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
    self.navigationItem.title = @"tesltkj";
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
