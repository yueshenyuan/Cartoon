//
//  NetAPI.h
//  Cartoon
//
//  Created by yueshenyuan on 13-6-16.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
@protocol requestDelete <NSObject>

@required
-(void)requestDidFinished:(NSDictionary *)dict;

@end
@interface NetAPI : NSObject
@property(nonatomic,assign) id<requestDelete> delegate;
@property(nonatomic,retain) ASIFormDataRequest *request;
- (void)sendRequest:(NSMutableDictionary *)cmtData;

-(void)grabURLInBackground:(NSString *)dict;
@end
