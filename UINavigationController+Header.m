//
//  UINavigationController+Header.m
//  Cartoon
//
//  Created by yueshenyuan on 13-7-20.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "UINavigationController+Header.h"

@implementation UINavigationController (Header)
- (void)setTitle:(NSString *)title
{
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGBCOLOR(20.0f, 100.0f, 250.0f, 1.0) forKey:UITextAttributeTextColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    [self.navigationBar setBarStyle:UIBarStyleBlack];
}

@end
