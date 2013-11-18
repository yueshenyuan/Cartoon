//
//  SearchViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-7-29.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    UISearchBar *sbar = [[[UISearchBar alloc] init] autorelease];
    sbar.delegate = self;
    CGRect rect = self.view.frame;
    sbar.frame = CGRectMake((rect.size.width-500)/2, 2, 500, 40);
    [self.navigationController.navigationBar addSubview:sbar];
    [sbar becomeFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    NSLog(@"====");
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    NSString *val = searchBar.text;
    NSLog(@"-------%@",val);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
