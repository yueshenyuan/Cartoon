//
//  NetAPI.m
//  Cartoon
//
//  Created by yueshenyuan on 13-6-16.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "NetAPI.h"

@implementation NetAPI
@synthesize request;

- (void)baseInfoRequest
{
    if (self.request!=nil) {
        [self.request clearDelegatesAndCancel];
        self.request=nil;
    }
    self.request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",API_URL]]];
    [self.request setPostValue:@"0" forKey:@"layout_id"];
    [self.request setPostValue:@"1" forKey:@"language"];
    [self.request setPostValue:@"1" forKey:@"app_id"];
    [self.request setPostValue:@"json" forKey:@"format"];
}
- (void)sendRequest:(NSMutableDictionary *)cmtData
{
    
    [self baseInfoRequest];
    
    NSArray *dictKeys = cmtData.allKeys;
    for (NSString *key in dictKeys) {
        [self.request setPostValue:[cmtData objectForKey:key] forKey:key];
    }
    self.request.delegate = self;
    [self.request startAsynchronous];
    self.request.didFinishSelector = @selector(requestFinished:);
    self.request.didFailSelector = @selector(requestFailed:);
    LOADINGSHOW_MESSAGE(nil, MODELODING);
}

- (void)requestFinished:(ASIFormDataRequest *)request1
{
    LOADINGDISMISS;
    NSString *respStr =[self.request responseString];
    NSDictionary *dict = [respStr objectFromJSONString];
    NSDictionary *exception = [dict objectForKey:@"exception"];
//    if (exception) {
//        int code = [exception objectForKey:@"code"];
//        NSString *sub_msg = [exception objectForKey:@"sub_msg"];
//        SHOWALERT(sub_msg);
//    }else{
//        [self.delegate requestDidFinished:dict];
//    }
    [self.delegate requestDidFinished:dict];
}
- (void)requestFailed:(ASIFormDataRequest *)request
{
    LOADINGDISMISS
    SHOWALERT(@"获取数据失败");
}
@end
