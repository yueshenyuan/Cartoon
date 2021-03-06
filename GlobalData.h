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

#pragma mark coverflow详情页

#pragma mark 下载页

//下载

extern Boolean isDownLoadStatus;
@interface GlobalData : UIViewController
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
