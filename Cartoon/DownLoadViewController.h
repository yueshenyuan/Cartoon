//
//  DownLoadViewController.h
//  Cartoon
//
//  Created by yueshenyuan on 12-12-22.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asiHTTP/ASINetworkQueue.h"
#import "ProgressIndicator.h"


@interface DownLoadViewController : UIViewController<ASIProgressDelegate>
{
    NSMutableArray *_imgArr;
    NSString *_downPath;
    NSArray *_comic_chapters;
    
    NSMutableArray *_downComicList;
    NSDictionary *_dict;
}
@property(nonatomic,assign) int currentDownId;
@property(nonatomic,assign) Boolean exitStatus;
@property(nonatomic,retain) NSMutableArray *imgArr;
@property(nonatomic,retain) ASINetworkQueue *netWorkQueue;
@property(nonatomic,assign) float alreadyDown;//已经下载的总数据
@property(nonatomic,copy) NSString *downPath;
@property(nonatomic,retain) NSArray *comic_chapters;
@property(nonatomic,retain) NSString *downLoadStatus;//下载状态

@property(nonatomic,retain) NSUserDefaults *userDefs;
@end
