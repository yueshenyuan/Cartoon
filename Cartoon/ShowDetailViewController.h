//
//  ShowDetailViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-22.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ShowDetailViewController : BaseViewController<UIScrollViewDelegate>
{
    NSArray *_imgsArr;
}
@property(nonatomic,retain) NSArray *imgsArr;
@property(nonatomic,retain) UIScrollView *mainScroll;
@property(nonatomic,retain) NSMutableArray *arr;

@property(nonatomic,assign) int currentImageCount;
@property(nonatomic,retain) UIImageView *imageView1;
@property(nonatomic,retain) UIImageView *imageView2;
@property(nonatomic,retain) UIImageView *imageView3;

@property(nonatomic,retain) NSMutableArray *dataList;
@property(nonatomic,assign) int currentIndex;
@property(nonatomic,assign) int currentPage;
@property(nonatomic,retain) UIScrollView *curScrollView;
@end
