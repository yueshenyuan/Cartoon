//
//  MainViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-4.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import "MainViewController.h"
#import "PublishersViewController.h"
#import "FeaturedViewController.h"
#import "DownLoadViewController.h"
#import "BuyViewController.h"
#import "SearchViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

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
    UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
    
    FeaturedViewController *fvc = [[[FeaturedViewController alloc] init] autorelease];
    fvc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"推荐" image:nil tag:0] autorelease];
    fvc.tabBarItem.title = @"推荐";
    fvc.tabBarItem.badgeValue = @"3";
    [fvc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"bottom_icon_press_01.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"bottom_icon_01.png"]];
    UINavigationController *fvcNav = [[[UINavigationController alloc] initWithRootViewController:fvc] autorelease];
    
    SearchViewController *svc = [[[SearchViewController alloc] init] autorelease];
    svc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"搜索" image:nil tag:1] autorelease];
    [svc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"bottom_icon_press_06.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"bottom_icon_06.png"]];
    UINavigationController *svcNav = [[[UINavigationController alloc] initWithRootViewController:svc] autorelease];
    
    BuyViewController *bVc= [[[BuyViewController alloc] init] autorelease];
    bVc.title = @"已购买";
    bVc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"已购买" image:nil tag:2] autorelease];
    [bVc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"bottom_icon_press_01-04.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"bottom_icon_01-04.png"]];
    UINavigationController *freeNav = [[UINavigationController alloc] initWithRootViewController:bVc];
    
    DownLoadViewController *dvc = [[[DownLoadViewController alloc] init] autorelease];
    dvc.title = @"下载管理";
    dvc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"下载管理" image:nil tag:3] autorelease];
    [dvc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"bottom_icon_press_01-05.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"bottom_icon_01-05.png"]];
    UINavigationController *dvcNav = [[[UINavigationController alloc] initWithRootViewController:dvc] autorelease];

    
    tabBarController.viewControllers = [[[NSArray alloc] initWithObjects:fvcNav,svcNav,freeNav,dvcNav, nil] autorelease];
    [self presentModalViewController:tabBarController animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"000000");
}

@end
