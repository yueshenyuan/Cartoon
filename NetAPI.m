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
    NSString *dataStr = [NSString stringWithFormat:@"%@?",API_URL];
    NSArray *dictKeys = cmtData.allKeys;
    for (NSString *key in dictKeys) {
        [self.request setPostValue:[cmtData objectForKey:key] forKey:key];
       dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[cmtData objectForKey:key]]];
    }
    NSLog(@"请求地址 =======》 %@",dataStr);
    self.request.delegate = self;
    [self.request startAsynchronous];
    self.request.didFinishSelector = @selector(requestFinished1:);
    self.request.didFailSelector = @selector(requestFailed1:);
    LOADINGSHOW_MESSAGE(nil, MODELODING);
}

- (void)requestFinished1:(ASIFormDataRequest *)requests
{
    LOADINGDISMISS;
    NSString *respStr =[self.request responseString];
    NSLog(@"请求结果 ======》%@",respStr);
    NSDictionary *dict = [respStr objectFromJSONString];
    NSDictionary *exception = [dict objectForKey:@"exception"];
    if (exception) {
//        int code = [exception objectForKey:@"code"];
        NSString *sub_msg = [exception objectForKey:@"sub_msg"];
        SHOWALERT(sub_msg);
    }else{
        [self.delegate requestDidFinished:dict];
    }
}
- (void)requestFailed1:(ASIFormDataRequest *)request
{
    LOADINGDISMISS
    SHOWALERT(@"获取数据失败");
}



-(void)grabURLInBackground:(NSString *)data
{
    LOADINGSHOW_MESSAGE(nil, MODELODING);
    [self baseInfoRequest];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?product_id=%@&method=full.product.get&layout_id=0&language=1&app_id=1&format=json",API_URL,data]];
    ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:url];
    [request1 setDelegate:self];
    [request1 startAsynchronous];
}


-(void)requestFinished:(ASIHTTPRequest *)requests
{
    LOADINGDISMISS
    NSString *responseString = [requests responseString];
    NSDictionary *dict = [responseString objectFromJSONString];
    [self.delegate requestDidFinished:dict];
}

-(void)requestFailed:(ASIHTTPRequest *)requests
{
    LOADINGDISMISS
    SHOWALERT(@"获取数据失败");
//    NSError *error = [requests error];
}
@end
