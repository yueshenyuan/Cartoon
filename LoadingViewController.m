//
//  LoadingViewController.m
//  Pingan
//
//  Created by suchangqin on 11-2-21.
//  Copyright 2011 Magus. All rights reserved.
//

#import "LoadingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoadingViewController()

// 为了防止showLoading在不同地方被多次调用，这里加个计数器
// 每调用一次showLoading，次数加一，每调用一次dismiss，次数减一
// 当次数减到0，就隐藏loading
@property (nonatomic, assign) NSInteger loadingCount;

@end

@implementation LoadingViewController

@synthesize loadingView = _loadingView;
@synthesize activeImage = _activeImage;
@synthesize label = _label;
@synthesize animationDuration =_animationDuration;
@synthesize maskView;
@synthesize loadingCount = _loadingCount;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        _loadingCount = 0;
    }
    return self;
}

// Override to allow orientations other than the default portrait orientation.
#ifdef TARGET_IPAD
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}
#endif
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setMaskView:nil];
    [self setActiveImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.label = nil;
    self.loadingView = nil;
}


- (void)dealloc {
  [maskView release];
  [_label release];
  [_loadingView release];
  [_activeImage release];
  [super dealloc];
	
}

#pragma mark -
-(void)showLoadingWithTitle:(NSString *) title inView:(UIView *) parentView mode:(LOADSTYLE)mode
{
    // 计数器加1
    _loadingCount++;
    if(_loadingCount > 1) {
        _loadingCount--;
        return;
    }
    
  self.view.frame = parentView.bounds;
    if (mode == MODELODING)
    {    
        //[maskView setFrame:CGRectMake(0, 64, self.view.width,self.view.height-64 )];
        [self.view setUserInteractionEnabled:YES];
    }
    else
    {
        [self.view setUserInteractionEnabled:NO];
    }

  [parentView addSubview:self.view];
  if (!title)
  {
    title = @"加载中...";
  }
  [self.loadingView setHidden:YES];
  self.view.alpha = 0;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  //[UIView setAnimationDelegate:self];
  //[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop:finished:)];
  self.view.alpha = 1;
  [UIView commitAnimations];
  _label.text = title;
  [self.activeImage startAnimating];
  [self startAnimating];
	
}
#pragma mark -
-(void) dismissLoading{
    if(_loadingCount == 0) return;
    
    // 计数器减1
    _loadingCount--;
    if(_loadingCount > 0) {
        return;
    } else {
        _loadingCount = 0;
    }
    
    if(self.view.superview == nil) return;
    
	[UIView beginAnimations:nil context:nil];
	
	[UIView setAnimationDuration:0.5];
	
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
	
	[UIView setAnimationDidStopSelector:@selector(onAnimationComplete)];
		
	[UIView setAnimationDelegate:self];
	
	self.view.layer.opacity = 0.0;
	
	[UIView commitAnimations];
	
    
}
-(void)onAnimationComplete
{
	[self.view removeFromSuperview];
}

#pragma mark - Public Methods

- (BOOL)isAnimating
{
    CAAnimation *spinAnimation = [self.activeImage.layer animationForKey:@"spinAnimation"];
    return (animating || spinAnimation);
}

- (void)startAnimating
{
    animating = YES;
    [self spin];
}

- (void)stopAnimating
{
    animating = NO;
}

- (void)spin
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = self.animationDuration;
	spinAnimation.repeatCount = HUGE_VAL;
    spinAnimation.delegate = self;
    [self.activeImage.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

#pragma mark - Animation Delegates

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (animating)
    {
//        [self spin];
    }
}

#pragma mark - Property Methods

- (CGFloat)animationDuration
{
    if (!_animationDuration)
    {
        _animationDuration = 0.80f;
    }
    return _animationDuration;
}

@end
