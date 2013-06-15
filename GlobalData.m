//
//  GlobalURL.m
//  Cartoon
//
//  Created by yueshenyuan on 13-3-30.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "GlobalData.h"
#import "DownComicInfo.h"
static GlobalData *sharedObj = nil; //第一步：静态实例，并初始化。
static NSMutableArray *CurrentDownList;
static NSString *isDownLoad;
Boolean isDownLoadStatus = NO;
@implementation GlobalData
@synthesize curTimeVal = _curTimeVal;
+ (GlobalData *) getGlobalData
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

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (oneway void) release
{
    
}

- (id) autorelease
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        [super init];//往往放一些要初始化的变量.
        return self;
    }
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
@end
