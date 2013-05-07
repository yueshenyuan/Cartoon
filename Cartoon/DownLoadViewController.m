//
//  DownLoadViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-22.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//
#import "GlobalData.h"
#import <QuartzCore/QuartzCore.h>
#import "DownLoadViewController.h"
#import "ZipArchive/ZipArchive.h"
#import "ShowDetailViewController.h"
#import "asiHTTP/ASIHTTPRequest.h"
#import "DownComicInfo.h"
@interface DownLoadViewController ()
{
    
}
@end

@implementation DownLoadViewController
@synthesize currentDownId = _currentDownId;
@synthesize exitStatus;
@synthesize netWorkQueue = _netWorkQueue;
@synthesize alreadyDown = _alreadyDown;
@synthesize downPath = _downPath;
@synthesize imgArr = _imgArr;
@synthesize comic_chapters = _comic_chapters;
@synthesize downLoadStatus = _downLoadStatus;

@synthesize userDefs = _userDefs;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //创建广播监控
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downIndex:) name:@"button1" object:nil];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self sequeItemViewLayout];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title = @"下载管理";
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(exitDownComic:)];
    self.navigationItem.rightBarButtonItem = exitBtn;
    
    NSMutableArray *currentDownList = [GlobalData getSaveLocalDownList];
    int row = 0;
    for(int i=0;i<currentDownList.count;i++){
        if (i%4 == 0) {
            row = i/4;
        }
        NSDictionary *dict = [currentDownList objectAtIndex:i];
        int pid = [[dict objectForKey:@"pid"] intValue];
        NSString *downStatus = [dict objectForKey:@"downStatus"];
        NSString *imgFilePath = [dict objectForKey:@"cover"];
        
        UIView *itemView = [[[UIView alloc] init] autorelease];
        itemView.frame = CGRectMake((i%4)*190+10, row*250+10*row, 200, 250);
        itemView.tag = pid;
        UIImageView *itemImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 180, 220)] autorelease];
        itemImg.layer.borderWidth = 3;
        itemImg.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
        itemImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgFilePath]]];

        UIProgressView *itemProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(6, 198, 110, 20)];
        UILabel *itemSize = [[[UILabel alloc] initWithFrame:CGRectMake(10, 198, 160, 20)] autorelease];
        itemSize.textAlignment = UITextAlignmentCenter;
        UILabel *itemLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 220, 180, 30)] autorelease];
        itemLab.text = [dict objectForKey:@"title"];
        itemLab.textAlignment = UITextAlignmentCenter;
        [itemView addSubview:itemImg];
        
        UIButton *showComic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        showComic.tag = 2;
        showComic.frame = CGRectMake(120, 190, 50, 25);
        [itemView addSubview:showComic];
        //未下载完
        if ([downStatus isEqualToString:@"down"]) {
//            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//            NSString *saveId = [NSString stringWithFormat:@"%d",pid];
//            NSDictionary *saveDownSize = [userDef objectForKey:saveId];
            NSMutableArray *downList = nil;
            NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
            }
            NSDictionary *saveDownSize = [downList objectAtIndex:0];
            if (saveDownSize) {
                itemProgress.progress = [[saveDownSize objectForKey:@"progress"] floatValue];
            }
            
            
            [itemView addSubview:itemProgress];
            [showComic setTitle:@"下载" forState:UIControlStateNormal];
            [showComic addTarget:self action:@selector(downComicClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{//已下载
            [showComic setTitle:@"阅读" forState:UIControlStateNormal];
            [showComic addTarget:self action:@selector(showDetailComic:) forControlEvents:UIControlEventTouchUpInside];
        }
        [itemView addSubview:itemLab];
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleBtn.tag = 1;
        deleBtn.hidden = YES;
        deleBtn.frame = CGRectMake(120, 12, 50, 25);
        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleBtn addTarget:self action:@selector(deleteDownComic:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:deleBtn];
        if (self.currentDownId != pid) {
            [self.view addSubview:itemView];
        }
    }
} 

#pragma mark 由详情页直接跳转到下载页
- (void)downIndex:(NSNotification *) notification
{
    NSDictionary *downInfoDict = (NSDictionary *)[notification object];
    DownComicInfo *downInfo = [downInfoDict objectForKey:@"downInfo"];
    self.currentDownId = [downInfo.pid intValue];
    NSString *imgFilePath = downInfo.icon;
    
    UIView *itemView = [[[UIView alloc] init] autorelease];
    itemView.frame = CGRectMake(0, 0, 200, 150);
    UIImageView *itemImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 180, 220)] autorelease];
    itemImg.layer.borderWidth = 3;
    itemImg.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    itemImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgFilePath]]];
    
    itemView.tag = [downInfo.pid intValue];
    UIProgressView *itemProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 195, 100, 20)];
    UILabel *itemSize = [[[UILabel alloc] initWithFrame:CGRectMake(10, 198, 160, 20)] autorelease];
    itemSize.textAlignment = UITextAlignmentCenter;
    UILabel *itemLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 220, 180, 30)] autorelease];
    itemLab.text = downInfo.name;
    itemLab.textAlignment = UITextAlignmentCenter;
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleBtn.tag = 1;
    deleBtn.hidden = YES;
    deleBtn.frame = CGRectMake(120, 10, 60, 30);
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(deleteDownComic:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *stopDown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopDown.userInteractionEnabled = YES;
    [stopDown setTitle:@"暂停" forState:UIControlStateNormal];
    stopDown.tag = 2;
    [stopDown addTarget:self action:@selector(downComicClick:) forControlEvents:UIControlEventTouchUpInside];
    stopDown.frame = CGRectMake(120, 190, 50, 25);
    [itemView addSubview:itemImg];
    [itemView addSubview:itemProgress];
    [itemView addSubview:itemLab];
    [itemView addSubview:deleBtn];
    [itemView addSubview:stopDown];
    [self.view addSubview:itemView];
    
    if (!isDownLoadStatus) {
        isDownLoadStatus = YES;
        self.alreadyDown = 0.00;
        [self downLoadCartoon:itemView];
    }
    
    [self sequeItemViewLayout];
}
#pragma mark 点击下载项
- (void) downComicClick:(id) sender
{
    UIButton *downBtn = (UIButton *)sender;
    int pid = downBtn.superview.tag;
    DownComicInfo *downInfo = [[[DownComicInfo alloc] init] autorelease];
    NSMutableArray *arr = [GlobalData getSaveLocalDownList];
    for (NSDictionary *dict in arr) {
        if ([[dict objectForKey:@"pid"] intValue] == pid) {
            if (!self.currentDownId && [[dict objectForKey:@"downStatus"] isEqualToString:@"down"]) {
                downInfo.icon = [dict objectForKey:@"cover"];
                downInfo.pid = [dict objectForKey:@"pid"];
                downInfo.downList = [dict objectForKey:@"pages"];
                downInfo.name = [dict objectForKey:@"title"];
                [GlobalData setCurrentDownList:downInfo];
                [self downLoadCartoon:downBtn.superview];
                [downBtn setTitle:@"暂停" forState:UIControlStateNormal];
                [downBtn addTarget:self action:@selector(downComicClick:) forControlEvents:UIControlEventTouchUpInside];
            }else if(self.currentDownId == pid){
                self.currentDownId = nil;
                [downBtn setTitle:@"下载" forState:UIControlStateNormal];
                [downBtn addTarget:self action:@selector(downComicClick:) forControlEvents:UIControlEventTouchUpInside];
                
                for (ASIHTTPRequest *request in self.netWorkQueue.operations) {
                    [request clearDelegatesAndCancel];
                }
            }else{
                [self showDetailComic:downBtn];
            }
        }
    }
}
#pragma mark 重新布局所有下载项
- (void)sequeItemViewLayout
{
    int row = 0;
    NSArray *itemViews = self.view.subviews;
    for (int i=0; i<itemViews.count; i++) {
        if (i%4 == 0) {
            row = i/4;
        }
        UIView *itemView = [itemViews objectAtIndex:i];
        itemView.frame = CGRectMake((i%4)*190+10, row*250+row*10, 200, 250);
    }
}
- (void)openCartoon{//解压zip包并浏览漫画
    
    ZipArchive *zip = [[[ZipArchive alloc] init] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dcoumentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* l_zipfile = [dcoumentpath stringByAppendingString:@"/归档.zip"] ;
    NSString* unzipto = [dcoumentpath stringByAppendingString:@"/testImg"] ;
    if( [zip UnzipOpenFile:l_zipfile] ) {
        BOOL ret = [zip UnzipFileTo:unzipto overWrite:YES];
        if( NO==ret ) { }
        [zip UnzipCloseFile];
    }
}

#pragma mark 下载文件
- (void)downLoadCartoon:(id) sender
{
    isDownLoadStatus = YES;
    DownComicInfo *downInfo;
    UIView *downView = (UIView *)sender;
    int index = downView.tag;
    self.currentDownId = index;
    if (self.netWorkQueue == nil) {
        [self setNetWorkQue];
    }
    else{
        [self.netWorkQueue reset];
    }
    NSArray *downInfoList = [GlobalData getCurrentDownList];
    for (int i=0; i<downInfoList.count; i++) {
        DownComicInfo *di =[downInfoList objectAtIndex:i];
        if ([di.pid intValue] == index) {
            downInfo = di;
        }
    }
    NSArray *pages = downInfo.downList;
    int comicId = [downInfo.pid intValue];
    //如果漫画下载文件夹不存在则创建
    NSString *comicFolderPath = [self.downPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", comicId]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:comicFolderPath];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:comicFolderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    //获取以往下载进度
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    if ([userDef objectForKey:[NSString stringWithFormat:@"%d",comicId]]) {
//        NSDictionary *saveDownSize = [userDef objectForKey:[NSString stringWithFormat:@"%d",comicId]];
//        self.alreadyDown = [[saveDownSize objectForKey:@"already"] floatValue];
//    }else{
//        [userDef removeObjectForKey:[NSString stringWithFormat:@"%d",comicId]];
//    }
    NSMutableArray *downList = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
        NSDictionary *saveDownSize = [downList objectAtIndex:0];
        self.alreadyDown = [[saveDownSize objectForKey:@"already"] floatValue];
    }
    
    
    
    ASIHTTPRequest *request;
    for (int i=0; i<pages.count; i++) {
        NSString *img = [[pages objectAtIndex:i] objectForKey:@"img"];
        NSArray *imgSplit = [img componentsSeparatedByString:@"/"];
        NSString *imgFile = [imgSplit objectAtIndex:imgSplit.count-1];
        [_imgArr addObject:imgFile];
        NSURL *url = [NSURL URLWithString:img];
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.tag = comicId;
        request.delegate = self;
        NSString *savePath = [_downPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d/%@",comicId,imgFile]];
        NSString *tempPath = [_downPath stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/%@.temp",imgFile]];
        [request setDownloadDestinationPath:savePath];
        [request setTemporaryFileDownloadPath:tempPath];
        BOOL fileIsExists = [fileManager fileExistsAtPath:savePath];
        if (!fileIsExists) {
            [self.netWorkQueue addOperation:request];
        }
        [request setAllowResumeForFileDownloads:YES];
        
        [request release];
    }
    
    [self.netWorkQueue go];
    
}

#pragma mark 获取下载文件大小和进度
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    if (!self.userDefs) {
        self.userDefs = [NSUserDefaults standardUserDefaults];
    }
    NSString *saveId = [NSString stringWithFormat:@"%d",request.tag];
    self.alreadyDown += request.contentLength/1024.0/1024.0;
    //队列文件总大小
    float totalSize;
//    NSDictionary *dict = [self.userDefs objectForKey:saveId];
//    if (dict != nil) {
//        NSNumber *total = [dict objectForKey:@"totalSize"];
//        totalSize = [total floatValue];
//    }else{
//        totalSize = self.netWorkQueue.totalBytesToDownload/1024.0/1024.0;
//    }
    NSMutableArray *downList = nil;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:@"cur.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        downList = [[[NSMutableArray alloc] initWithContentsOfFile:path] autorelease];
        NSDictionary *saveDownSize = [downList objectAtIndex:0];
        totalSize = [[saveDownSize objectForKey:@"totalSize"] floatValue];
    }else{
        totalSize = self.netWorkQueue.totalBytesToDownload/1024.0/1024.0;
    }
    
    
    
    float progressSize = self.alreadyDown/totalSize;
    
    NSNumber *saveProgressSize = [NSNumber numberWithFloat:progressSize];
    NSNumber *alreadyDownSize = [NSNumber numberWithFloat:self.alreadyDown];
    NSNumber *totalDownSize = [NSNumber numberWithFloat:totalSize];
    NSDictionary *saveDownSize = [NSDictionary dictionaryWithObjectsAndKeys:saveProgressSize,@"progress",
                                  alreadyDownSize,@"already",
                                  totalDownSize,@"totalSize", nil];
    GlobalData *global = [GlobalData getGlobalData];
    [global saveDownLoadProgress:saveDownSize productId:saveId];
//    NSLog(@"进度:%fM  已下载：%fM  总大小：%fM",[saveProgressSize floatValue],[alreadyDownSize floatValue],[totalDownSize floatValue]);
//    [self.userDefs setObject:saveDownSize forKey:saveId];
    UIView *curDownView = [self.view viewWithTag:request.tag];
    for (UIView *view in curDownView.subviews) {
        if ([view isKindOfClass:[UIProgressView class]]) {
            UIProgressView *grv = (UIProgressView *)view;
            grv.progress = progressSize;
        }
    }
}

//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
//    NSLog(@"下载完成：%@",request.url);
}

- (void)failWithError:(NSError *)theError
{
    NSLog(@"%@",theError);
}
#pragma mark  浏览漫画
- (void) showDetailComic:(id)clickPid{
    
    int tapPid = 0;
    UIButton *btn = (UIButton *)clickPid;
    tapPid = btn.superview.tag;
    
    ShowDetailViewController *sdvc = [[[ShowDetailViewController alloc] init] autorelease];
    NSMutableArray *imgsArr = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *currentDownList = [GlobalData getSaveLocalDownList];
    for (int i=0; i<currentDownList.count; i++) {
        NSDictionary *browseComicDict = [currentDownList objectAtIndex:i];
        int pid = [[browseComicDict objectForKey:@"pid"] intValue];
        
        if (pid == tapPid) {
            NSArray *pages = [browseComicDict objectForKey:@"pages"];
            for (id page in pages) {
                NSString *img = [page objectForKey:@"img"];
                NSString *str_intercepted = [img substringFromIndex:46];
                NSString *str_character = @"/";
                NSRange range = [str_intercepted rangeOfString:str_character];
                NSString *str_complete = [str_intercepted substringToIndex:range.location];
                NSString *imgPath = [NSString stringWithFormat:@"%d/%@",pid,str_intercepted.lastPathComponent];
                [imgsArr addObject:imgPath];
            }
        }
    }
    sdvc.imgsArr = imgsArr;
    [self.navigationController pushViewController:sdvc animated:YES];
}


//设置下载队列
- (void) setNetWorkQue
{
    ASINetworkQueue   *que = [[[ASINetworkQueue alloc] init] autorelease];
    self.netWorkQueue = que;
    [self.netWorkQueue reset];
    [self.netWorkQueue setShowAccurateProgress:YES];
    [self.netWorkQueue setShouldCancelAllRequestsOnFailure:NO];
    [self.netWorkQueue setQueueDidFinishSelector:@selector(downAllSuccess)];
    self.netWorkQueue.delegate = self;
    self.downPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *folderPath = [self.downPath stringByAppendingPathComponent:@"temp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:folderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}
#pragma mark  队列下载完成
- (void) downAllSuccess
{
    NSLog(@"全部下载完成");
    isDownLoadStatus = NO;
    [self setNetWorkQue];
    //将刚刚下载的项目删除出下载队列
    for (DownComicInfo *dci in [GlobalData getCurrentDownList]) {
        if ([dci.pid intValue] == self.currentDownId) {
            [[GlobalData getCurrentDownList] removeLastObject];
            break;
        }
    }
    
    UIView *dView = nil;
    for (UIView *vw in self.view.subviews) {
        if (vw.tag == self.currentDownId) {
            dView = vw;
        }
    }
    //下载完成隐藏进度条
    for (int i=0; i<dView.subviews.count; i++) {
        if ([[dView.subviews objectAtIndex:i] isKindOfClass:[UIProgressView class]]) {
            UIProgressView *progress = (UIProgressView *)[dView.subviews objectAtIndex:i];
            progress.hidden = YES;

            UIButton *showComic = (UIButton *)[dView viewWithTag:2];
            [showComic setTitle:@"阅读" forState:UIControlStateNormal];
            NSMutableArray *userDefArr = [GlobalData getSaveLocalDownList];
            for (int i=0;i<userDefArr.count;i++) {
                NSMutableDictionary *muDict = (NSMutableDictionary *)userDefArr[i];
                if ([[muDict objectForKey:@"pid"] intValue] == dView.tag) {
                    [muDict removeObjectForKey:@"downStatus"];
                    [muDict setObject:@"success" forKey:@"downStatus"];
                    
                    userDefArr[i] = muDict;
                    [GlobalData setSaveLocalDownList:userDefArr];
                    
                }
            }
        }
    }
    self.currentDownId = nil;
    //如果下载队列中有等待下载项，则开始下载下一文件
    NSMutableArray *currentList = [GlobalData getCurrentDownList];
    if (currentList.count>0) {
        DownComicInfo *downInfo = [currentList objectAtIndex:currentList.count-1];
        for (UIView *view in self.view.subviews) {
            if (view.tag == [downInfo.pid intValue]) {
                [self downLoadCartoon:view];
            }
        }
    }
    
}
#pragma mark 编辑下载项
- (void)exitDownComic:(id)sender
{
    NSArray *viewArr = self.view.subviews;
    NSMutableArray *downListArr = [GlobalData getSaveLocalDownList];
    for (UIView *view in viewArr) {
        for (NSDictionary *dict in downListArr) {
            int tagId = view.tag;
            int pid = [[dict objectForKey:@"pid"] intValue];
            if (pid == tagId) {
                UIButton *deleBtn = (UIButton *)[view viewWithTag:1];
                if (!self.exitStatus) {
                    deleBtn.hidden = NO;
                }else{
                    deleBtn.hidden = YES;
                }
            }
        }
    }
    if (!self.exitStatus) {
        self.exitStatus = YES;
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else{
        self.exitStatus = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}
#pragma mark 删除下载项
- (void) deleteDownComic:(id)sender
{
    //删除页面View
    UIButton *deleBtn = (UIButton *)sender;
    int pid = deleBtn.superview.tag;
    NSLog(@"将要删除漫画：%d",pid);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该漫画？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = pid;
    [alert show];
}
#pragma mark 监控弹出框中按钮点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int pid = alertView.tag;
    if (buttonIndex == 0) {
    UIView *deleView = [self.view viewWithTag:pid];
    [deleView removeFromSuperview];
    [self sequeItemViewLayout];
    
    //删除本地存储的下载信息
    NSMutableArray *downListArr = [GlobalData getSaveLocalDownList];
    for (NSDictionary *dict in downListArr) {
        if ([[dict objectForKey:@"pid"] intValue] == pid) {
            [downListArr removeObject:dict];
            break;
        }
    }
    [GlobalData setSaveLocalDownList:downListArr];
    //删除本地已下载文件
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *comicPath = [NSString stringWithFormat:@"%d",pid];
    NSString *imageDir = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:comicPath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
    }
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef removeObjectForKey:[NSString stringWithFormat:@"%d",pid]];
    if (isDeleted) {
        NSLog(@"删除成功");
    }
    }
}
- (void) viewDidDisappear:(BOOL)animated
{
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
    {
    }else{
    }
    
	return YES;
}
@end
