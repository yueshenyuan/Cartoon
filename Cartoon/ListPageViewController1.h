//
//  ListPageViewController1.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-8.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ListPageViewController1 : BaseViewController<UITableViewDataSource,UITableViewDelegate,requestDelete>
{
    NetAPI *_api;
}
@property(nonatomic,retain) UIScrollView *mainScrollView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIView *topView;
@property(nonatomic,assign) BOOL *winHV;
@property(nonatomic,retain) UIView *listView;
@property(nonatomic,retain) UITableView *tabView;
@property(nonatomic,assign) NSInteger *listID;
@property(nonatomic,retain) NSMutableArray *listArr;
@property(nonatomic,retain) IBOutlet UITableViewCell *mcell;

@property(nonatomic,retain) IBOutlet UIView *leftView;
@property(nonatomic,retain) IBOutlet UIImageView *leftCellImg1;
@property(nonatomic,retain) IBOutlet UILabel *leftCellLab1;
@property(nonatomic,retain) IBOutlet UILabel *leftCellLab2;
@property(nonatomic,retain) IBOutlet UIButton *leftCellBtn;

@property(nonatomic,retain) IBOutlet UIView *rightView;
@property(nonatomic,retain) IBOutlet UIImageView *rightCellImg1;
@property(nonatomic,retain) IBOutlet UILabel *rightCellLab1;
@property(nonatomic,retain) IBOutlet UILabel *rightCellLab2;
@property(nonatomic,retain) IBOutlet UIButton *rightCellBtn;

@end
