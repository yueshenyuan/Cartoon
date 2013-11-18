//
//  BuyViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-7-20.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "BuyViewController.h"
#import "LoginViewController.h"
@interface BuyViewController ()

@end

@implementation BuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    LoginViewController *lvc = [[[LoginViewController alloc] init] autorelease];
    lvc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:lvc animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
