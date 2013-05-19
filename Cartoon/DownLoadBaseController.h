//
//  DownLoadBaseController.h
//  Cartoon
//
//  Created by yueshenyuan on 13-5-11.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalData.h"
#import "asiHTTP/ASINetworkQueue.h"
#import "asiHTTP/ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "DownLoadViewController.h"
#import "ZipArchive/ZipArchive.h"
#import "ShowDetailViewController.h"
#import "DownComicInfo.h"
@interface DownLoadBaseController : NSObject

- (float)getProductDownProgress:(int) pid;
- (float)getProductDownAlready:(int) pid;
- (float)getProductDownTotalSize:(int) pid;
- (void)removeProductDownProgress:(int) pid;
- (void)saveDownLoadProgress:(int)pid setProgress:(NSNumber *)progress setAlready:(NSNumber *)already setTotalSize:(NSNumber *)totalSize;
@end
