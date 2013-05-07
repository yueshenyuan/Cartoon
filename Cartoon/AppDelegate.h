//
//  AppDelegate.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-4.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *_window;
    LoadingViewController *loadingViewController;
}
@property(nonatomic,retain) UIWindow *window;
@property(nonatomic,retain) LoadingViewController *loadingViewController;
@end
