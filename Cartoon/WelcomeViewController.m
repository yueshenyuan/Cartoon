//
//  WelcomeViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-7-14.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RecoveryViewController.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    self.navigationItem.title = @"欢迎";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeWindow)];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    [btn addTarget:self action:@selector(openRecoveryPage) forControlEvents:UIControlEventTouchUpInside];
}
- (void) closeWindow
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void) openRecoveryPage
{
    RecoveryViewController *rvc = [[RecoveryViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
    [rvc release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
