//
//  BookshelfIndexViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-10-10.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "BookshelfIndexViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface BookshelfIndexViewController ()

@end

@implementation BookshelfIndexViewController
@synthesize subView;
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
    self.navigationItem.title = @"我的书架";
    self.navigationItem.rightBarButtonItem=nil;
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:uibar target:self action:@selector(a:)] autorelease];
    leftItem.title = @"返回";
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    [self setupController];
}
- (void) setupController
{
    NSMutableArray *currentDownList = [BaseViewController getSaveLocalDownList];
    for (NSDictionary *d in currentDownList) {
        NSString *downStatus = [d objectForKey:@"downStatus"];
        if (![downStatus isEqualToString:@"success"]) {
            [currentDownList removeObject:d];
        }
    }
    int row = 0;
    for(int i=0;i<currentDownList.count;i++){
        if (i%4 == 0) {
            row = i/4;
        }
        NSDictionary *dict = [currentDownList objectAtIndex:i];
        int pid = [[dict objectForKey:@"pid"] intValue];
        NSString *downStatus = [dict objectForKey:@"downStatus"];
        NSString *imgFilePath = [dict objectForKey:@"cover"];
        NSString *title = [dict objectForKey:@"title"];
        if ([downStatus isEqualToString:@"success"]) {
            UIView *itemView = [[[UIView alloc] init] autorelease];
            itemView.frame = CGRectMake((i%4)*190+10, row*250+10*row, 200, 250);
            itemView.tag = pid;
            UIImageView *itemImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 180, 220)] autorelease];
            itemImg.layer.borderWidth = 3;
            itemImg.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
            itemImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgFilePath]]];
            
            UILabel *itemSize = [[[UILabel alloc] initWithFrame:CGRectMake(10, 198, 160, 20)] autorelease];
            itemSize.textAlignment = UITextAlignmentCenter;
            UILabel *itemLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 220, 180, 30)] autorelease];
            itemLab.text = title;
            itemLab.textAlignment = UITextAlignmentCenter;
            [itemView addSubview:itemImg];
            
            UIButton *showComic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            showComic.tag = 2;
            showComic.frame = CGRectMake(120, 190, 50, 25);
            [itemView addSubview:showComic];
            
            [showComic setTitle:@"阅读" forState:UIControlStateNormal];
            [showComic addTarget:self action:@selector(showDetailComic:) forControlEvents:UIControlEventTouchUpInside];
            
            [itemView addSubview:itemLab];
            UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            deleBtn.tag = 1;
            deleBtn.hidden = YES;
            deleBtn.frame = CGRectMake(120, 12, 50, 25);
            [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleBtn addTarget:self action:@selector(deleteDownComic:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:deleBtn];
//            if (self.currentDownId != pid) {
//                [self.view addSubview:itemView];
//            }
            [self.view addSubview:itemView];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
