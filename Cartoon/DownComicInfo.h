//
//  downComicInfo.h
//  Cartoon
//
//  Created by yueshenyuan on 13-4-4.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownComicInfo : NSObject
@property(nonatomic,copy) NSString *pid;
@property(nonatomic,copy) NSString *name;//名称
@property(nonatomic,copy) NSString *icon;//icon
@property(nonatomic,copy) NSString *progress;//进度
@property(nonatomic,copy) NSString *size;//漫画大小
@property(nonatomic,copy) NSString *downStatus;//下载状态
@property(nonatomic,retain) NSArray *downList;//下载文件列表

@end
