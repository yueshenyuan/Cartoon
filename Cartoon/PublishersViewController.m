//
//  PublishersViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-7.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import "PublishersViewController.h"

@interface PublishersViewController ()

@end

@implementation PublishersViewController

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
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    // Do any additional setup after loading the view from its nib.
    
    UIScrollView *uv = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 700, 800)] autorelease];
    uv.contentSize = CGSizeMake(800, 100);
    uv.backgroundColor = [UIColor greenColor];
    
    UIScrollView *subuv = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 500, 200)];
    subuv.contentSize = CGSizeMake(1000, 200);
    subuv.backgroundColor = [UIColor redColor];
    [uv addSubview:subuv];
    
//    [self.view addSubview:uv];
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

@end
