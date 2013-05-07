//
//  DetailClass.h
//  Cartoon
//
//  Created by yueshenyuan on 13-1-3.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailClass : NSObject
{
    int _id;
    int _vol;
    int _page_total;
    NSString *_title;
    NSString *_chapter_cover;
}
@property(nonatomic,assign) int id;
@property(nonatomic,assign) int vol;
@property(nonatomic,assign) int page_total;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *chapter_cover;
@end


