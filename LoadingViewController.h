//
//  LoadingViewController.h
//  Pingan
//
//  Created by suchangqin on 11-2-21.
//  Copyright 2011 Magus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hitView.h"
typedef enum
{
    MODELODING,
    DISMODELODING
} LOADSTYLE;

@interface LoadingViewController : UIViewController {
  UILabel *_label;
  UIActivityIndicatorView *_loadingView;
  BOOL animating;
}
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (retain, nonatomic) IBOutlet UIImageView *activeImage;
@property (nonatomic, retain) IBOutlet UIView *maskView;
- (BOOL)isAnimating;
- (void)startAnimating;
- (void)stopAnimating;
- (void)spin;

-(void)showLoadingWithTitle:(NSString *) title inView:(UIView *) parentView mode:(LOADSTYLE)mode;
-(void)dismissLoading;

@end
