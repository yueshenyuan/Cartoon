//
//  BaseViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 13-6-27.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetAPI.h"
#import "DownComicInfo.h"
#import "GlobalMacros.h"
#import "UIView+BFExtension.h"
extern Boolean isDownLoadStatus;
@interface BaseViewController : UIViewController
@property(nonatomic,assign) int curTimeVal;

+ (BaseViewController *) getGlobalData;
+ (NSMutableArray *) getCurrentDownList;
+ (void) setCurrentDownList:(id)arr;
+ (void) removeCurrentDownList:(int)pid;
+ (void) setDownLoadStatus:(Boolean)b;
+ (Boolean) viewExists:(UIView *)mView tag:(int)tag;
+ (NSMutableArray *) getSaveLocalDownList;
+ (void)setSaveLocalDownList:(NSMutableArray *)arr;
@end
