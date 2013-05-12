//
//  DownLoadBaseController.m
//  Cartoon
//
//  Created by yueshenyuan on 13-5-11.
//  Copyright (c) 2013年 fanzhi. All rights reserved.
//

#import "DownLoadBaseController.h"

@implementation DownLoadBaseController

#pragma mark 获取商品下载进度
- (float)getProductDownProgress:(int) pid
{
    float progress = 0.0;
    NSMutableArray *downList = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
    }
    for (NSDictionary *dict in downList) {
        int savePid = [[dict objectForKey:@"pid"] intValue];
        if (savePid == pid) {
            progress = [[dict objectForKey:@"progress"] floatValue];
        }
    }
    
    return progress;
}
#pragma mark 获取商品已下载大小
- (float)getProductDownAlready:(int) pid
{
    float already = 0.0;
    NSMutableArray *downList = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
    }
    for (NSDictionary *dict in downList) {
        int savePid = [[dict objectForKey:@"pid"] intValue];
        if (savePid == pid) {
            already = [[dict objectForKey:@"already"] floatValue];
        }
    }
    
    return already;
}
#pragma mark 获取商品下载总大小
- (float)getProductDownTotalSize:(int) pid
{
    float totalSize = -1.0;
    NSMutableArray *downList = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
    }
    for (NSDictionary *dict in downList) {
        int savePid = [[dict objectForKey:@"pid"] intValue];
        if (savePid == pid) {
            totalSize = [[dict objectForKey:@"totalSize"] floatValue];
        }
    }
    return totalSize;
}
#pragma mark 存储下载进度，已下载大小，总大小
- (void)saveDownLoadProgress:(int)pid setProgress:(NSNumber *)progress setAlready:(NSNumber *)already setTotalSize:(NSNumber *)totalSize;
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:pid],@"pid",progress,@"progress",
                                  already,@"already",
                                  totalSize,@"totalSize", nil];
//    GlobalData *global = [GlobalData getGlobalData];
//    [global saveDownLoadProgress:saveDownSize productId:pid];
    NSMutableArray *downList;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
        BOOL isExist = NO;
        for (int i=0;i<downList.count;i++) {
            NSDictionary *saveDict = [downList objectAtIndex:i];
            int savePid = [[saveDict objectForKey:@"pid"] intValue];
            if (pid == savePid) {
                isExist = YES;
                [downList replaceObjectAtIndex:i withObject:dict];
            }
        }
        if (!isExist) {
            [downList addObject:dict];
        }
    }else{
        downList = [NSMutableArray arrayWithObjects:dict, nil];
    }
    [downList writeToFile:path atomically:YES];
}
@end
