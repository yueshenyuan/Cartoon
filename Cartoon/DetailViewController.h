//
//  DetailViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-8.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CoverFlowView.h"
#import "DownLoadViewController.h"
@interface DetailViewController : BaseViewController<CoverFlowViewDelegate,requestDelete>
{
    NetAPI *_api;
}
@property(nonatomic,retain) id delete;
@property(nonatomic,copy) NSString *product_id;
@property(nonatomic,retain) UIView *coverFlowView;
@property(nonatomic,retain) NSMutableArray *imgArr;
@property(nonatomic,copy) NSString *netWordType;

@property(nonatomic,retain) IBOutlet UILabel *productNameLab;
@property(nonatomic,retain) IBOutlet UILabel *comicNameLab;
@property(nonatomic,retain) IBOutlet UIButton *downBtn;

@property(nonatomic,retain) IBOutlet UITextView *summaryTextView;

@property(nonatomic,retain) IBOutlet UIView *previewsView;
@end
