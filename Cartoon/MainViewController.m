//
//  MainViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-4.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import "MainViewController.h"
#import "FeaturedViewController.h"
#import "PublishersViewController.h"
#import "DownLoadViewController.h"
#import "DetailViewController.h"
#import "FreeViewController.h"
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
    fvc.title = @"Featured";
    fvc.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0] autorelease];
    fvc.tabBarItem.title = @"精选";
    UINavigationController *fvcNav = [[[UINavigationController alloc] initWithRootViewController:fvc] autorelease];
    
    PublishersViewController *pvc = [[[PublishersViewController alloc] init] autorelease];
    pvc.title = @"Publishers";
    pvc.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1] autorelease];
    UINavigationController *svcNav = [[[UINavigationController alloc] initWithRootViewController:pvc] autorelease];
    
    FreeViewController *freeVc= [[[FreeViewController alloc] init] autorelease];
    freeVc.title = @"FREE";
    freeVc.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:2] autorelease];
    UINavigationController *freeNav = [[UINavigationController alloc] initWithRootViewController:freeVc];
    
    DownLoadViewController *dvc = [[[DownLoadViewController alloc] init] autorelease];
    dvc.title = @"下载管理";
    dvc.view;
    dvc.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:3] autorelease];
    UINavigationController *dvcNav = [[[UINavigationController alloc] initWithRootViewController:dvc] autorelease];

    DetailViewController *detailV = [[[DetailViewController alloc] init] autorelease];
    detailV.delete = dvc;
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
