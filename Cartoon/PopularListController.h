//
//  PopularListController.h
//  Cartoon
//
//  Created by yueshenyuan on 13-4-17.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalData.h"
@interface PopularListController : UIViewController<UITableViewDataSource,UITableViewDelegate,requestDelete>
{
    NetAPI *_api;
}
@property(nonatomic,retain) NSArray *dataList;
@property(nonatomic,retain)UITableView *tabView;

@property(nonatomic,retain) IBOutlet UIView *leftView;
@property(nonatomic,retain) IBOutlet UIImageView *leftImgView;
@property(nonatomic,retain) IBOutlet UILabel *leftLab1;
@property(nonatomic,retain) IBOutlet UILabel *leftLab2;

@property(nonatomic,retain) IBOutlet UIView *rightView;
@property(nonatomic,retain) IBOutlet UIImageView *rightImgView;
@property(nonatomic,retain) IBOutlet UILabel *rightLab1;
@property(nonatomic,retain) IBOutlet UILabel *rightLab2;
@end
