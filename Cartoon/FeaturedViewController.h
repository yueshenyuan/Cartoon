//
//  FeaturedViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-6.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "BaseViewController.h"
@interface FeaturedViewController : BaseViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,requestDelete>
{
    NetAPI *_api;
}
@property(nonatomic,retain) ASIHTTPRequest *request;
@property(nonatomic,retain) UIScrollView *mainScrollView;
@property(nonatomic,retain) UISegmentedControl *segControl;
@property(nonatomic,assign) int currentModule;
@property(nonatomic,retain) UIView *featuredSubModule0;
@property(nonatomic,retain) UIView *featuredSubModule1;
@property(nonatomic,retain) UIView *featuredSubModule2;
@property(nonatomic,retain) UITableView *tabView;

@property(nonatomic,retain) NSArray *dataList_M1;
@property(nonatomic,retain) NSArray *dataList_M2;
@property(nonatomic,retain) IBOutlet UIView *leftView_M1;
@property(nonatomic,retain) IBOutlet UIImageView *leftImgView_M1;
@property(nonatomic,retain) IBOutlet UILabel *leftLab1_M1;
@property(nonatomic,retain) IBOutlet UILabel *leftLab2_M1;
@property(nonatomic,retain) IBOutlet UIView *rightView_M1;
@property(nonatomic,retain) IBOutlet UIImageView *rightImgView_M1;
@property(nonatomic,retain) IBOutlet UILabel *rightLab1_M1;
@property(nonatomic,retain) IBOutlet UILabel *rightLab2_M1;

@property(nonatomic,retain) IBOutlet UIView *featuredView;
@property(nonatomic,retain) IBOutlet UIView *justAddedView;
@end
