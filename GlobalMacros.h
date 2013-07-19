//
//  GlobalMacros.h
//  Cartoon
//
//  Created by yueshenyuan on 13-6-27.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#define API_URL @"http://comicservice.ifun360.com/comic_service_test/interface.action"  //接口域名
#define LOADINGSHOW_MESSAGE(m,modes) [((AppDelegate *)[[UIApplication sharedApplication] delegate]).loadingViewController showLoadingWithTitle:m inView:[UIApplication sharedApplication].keyWindow mode:modes];[UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
#define LOADINGDISMISS [((AppDelegate *)[[UIApplication sharedApplication] delegate]).loadingViewController dismissLoading];[UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
//提示框
#define SHOWALERT(m) \
{\
UIAlertView *alert1 = [[[UIAlertView alloc] initWithTitle:@"提示" message:m delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] autorelease];\
[alert1 show]; \
}
//设置颜色
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

@interface GlobalMacros : NSObject

@end
