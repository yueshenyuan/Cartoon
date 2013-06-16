//
//  GlobalURL.h
//  Cartoon
//
//  Created by yueshenyuan on 13-3-30.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "NetAPI.h"

#define API_URL @"http://comicservice.ifun360.com/comic_service_test/interface.action"  //接口域名
#define LOADINGSHOW_MESSAGE(m,modes) [((AppDelegate *)[[UIApplication sharedApplication] delegate]).loadingViewController showLoadingWithTitle:m inView:[UIApplication sharedApplication].keyWindow mode:modes];
#define LOADINGDISMISS [((AppDelegate *)[[UIApplication sharedApplication] delegate]).loadingViewController dismissLoading];
//提示框
#define SHOWALERT(m) \
{\
UIAlertView *alert1 = [[[UIAlertView alloc] initWithTitle:@"提示" message:m delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] autorelease];\
[alert1 show]; \
}
//设置颜色
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

#pragma mark coverflow详情页

#pragma mark 下载页

//下载

extern Boolean isDownLoadStatus;
@interface GlobalData : NSObject
@property(nonatomic,assign) int curTimeVal;

+ (GlobalData *) getGlobalData;
+ (NSMutableArray *) getCurrentDownList;
+ (void) setCurrentDownList:(id)arr;
+ (void) removeCurrentDownList:(int)pid;
+ (NSString *) getDownLoadStatus;
+ (void) setDownLoadStatus:(Boolean)b;
+ (Boolean) viewExists:(UIView *)mView tag:(int)tag;
+ (NSMutableArray *) getSaveLocalDownList;
+ (void)setSaveLocalDownList:(NSMutableArray *)arr;
@end
