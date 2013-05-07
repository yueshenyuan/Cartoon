//
//  ShowDetailViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-22.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray *_imgsArr;
    UIScrollView *_mainScroll;
    
    NSMutableArray *_arr;
}
@property(nonatomic,retain) NSArray *imgsArr;
@property(nonatomic,retain) UIScrollView *mainScroll;
@property(nonatomic,retain) NSMutableArray *arr;
@end
