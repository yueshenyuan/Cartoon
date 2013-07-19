//
//  RecoveryViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-7-14.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "RecoveryViewController.h"
#import "LoginViewController.h"
@interface RecoveryViewController ()

@end

@implementation RecoveryViewController

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
    self.navigationItem.title = @"恢复";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(closeWindow)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    [btn addTarget:self action:@selector(recoveryComic) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 关闭欢迎页
- (void)closeWindow
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma  mark 立即恢复
- (void)recoveryComic
{
    LoginViewController *lvc = [[[LoginViewController alloc] init] autorelease];
    [self.navigationController pushViewController:lvc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
