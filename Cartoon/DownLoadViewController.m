//
//  DownLoadViewController.m
//  Cartoon
//
//  Created by yueshenyuan on 12-12-22.
//  Copyright (c) 2012年 fanzhi. All rights reserved.
//
#import "DownLoadViewController.h"
@interface DownLoadViewController ()
{
    
}
@end

@implementation DownLoadViewController
@synthesize downBase;
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
    self.navigationItem.title = @"下载管理";
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(exitDownComic:)];
    self.navigationItem.rightBarButtonItem = exitBtn;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.downBase = [[[DownLoadBaseController alloc] init] autorelease];
    
    NSMutableArray *currentDownList = [BaseViewController getSaveLocalDownList];
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
            float progressValue = [self.downBase getProductDownProgress:pid];
            itemProgress.progress = progressValue;
            
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
    if (currentDownList.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
} 

#pragma mark 由详情页直接跳转到下载页
- (void)downIndex:(NSNotification *) notification
{
    NSDictionary *downInfoDict = (NSDictionary *)[notification object];
    DownComicInfo *downInfo = [downInfoDict objectForKey:@"downInfo"];
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
    NSLog(@"--------------3----------------");
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
    NSMutableArray *arr = [BaseViewController getSaveLocalDownList];
    for (NSDictionary *dict in arr) {
        if ([[dict objectForKey:@"pid"] intValue] == pid) {
            if (!self.currentDownId && [[dict objectForKey:@"downStatus"] isEqualToString:@"down"]) {
                downInfo.icon = [dict objectForKey:@"cover"];
                downInfo.pid = [dict objectForKey:@"pid"];
                downInfo.downList = [dict objectForKey:@"pages"];
                downInfo.name = [dict objectForKey:@"title"];
                [BaseViewController setCurrentDownList:downInfo];
                [self downLoadCartoon:downBtn.superview];
                [downBtn setTitle:@"暂停" forState:UIControlStateNormal];
                [downBtn addTarget:self action:@selector(downComicClick:) forControlEvents:UIControlEventTouchUpInside];
            }else if(self.currentDownId == pid){
                self.currentDownId = nil;
                isDownLoadStatus = NO;
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

#pragma mark 下载文件
- (void)downLoadCartoon:(id) sender
{
    conlen = 0;
    isDownLoadStatus = YES;
    DownComicInfo *downInfo;
    UIView *downView = (UIView *)sender;
    int index = downView.tag;
    self.currentDownId = index;
    [self setNetWorkQue];
    NSArray *downInfoList = [BaseViewController getCurrentDownList];
    for (int i=0; i<downInfoList.count; i++) {
        DownComicInfo *di =[downInfoList objectAtIndex:i];
        if ([di.pid intValue] == index) {
            downInfo = di;
        }
    }
    NSArray *pages = downInfo.downList;
    int pid = [downInfo.pid intValue];
    //如果漫画下载文件夹不存在则创建
    NSString *comicFolderPath = [self.downPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", pid]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:comicFolderPath];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:comicFolderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    //获取以往下载进度
    float alreadyValue = [self.downBase getProductDownAlready:pid];
    self.alreadyDown = alreadyValue;
    
    ASIHTTPRequest *request;
    for (int i=0; i<pages.count; i++) {
        NSString *img = [[pages objectAtIndex:i] objectForKey:@"img"];
        NSArray *imgSplit = [img componentsSeparatedByString:@"/"];
        NSString *imgFile = [imgSplit objectAtIndex:imgSplit.count-1];
        [_imgArr addObject:imgFile];
        NSURL *url = [NSURL URLWithString:img];
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.tag = pid;
        request.delegate = self;
        NSString *savePath = [_downPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d/%@",pid,imgFile]];
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
static int conlen = 0;
#pragma mark 获取下载文件大小和进度
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    if (!self.userDefs) {
        self.userDefs = [NSUserDefaults standardUserDefaults];
    }
    int pid = request.tag;
    self.alreadyDown += request.contentLength/1024.0/1024.0;
    conlen += request.contentLength;
    //队列文件总大小
    float totalSize = [self.downBase getProductDownTotalSize:pid];
    if (totalSize < 0.0) {
        totalSize = self.netWorkQueue.totalBytesToDownload/1024.0/1024.0;
    }
    
    float progressSize = self.alreadyDown/totalSize;
    
    NSNumber *saveProgressSize = [NSNumber numberWithFloat:progressSize];
    NSNumber *alreadyDownSize = [NSNumber numberWithFloat:self.alreadyDown];
    NSNumber *totalDownSize = [NSNumber numberWithFloat:totalSize];
    [self.downBase saveDownLoadProgress:pid setProgress:saveProgressSize setAlready:alreadyDownSize setTotalSize:totalDownSize];
//    NSLog(@"进度:%fM  已下载：%fM  总大小：%fM",[saveProgressSize floatValue],[alreadyDownSize floatValue],[totalDownSize floatValue]);
    if ([saveProgressSize intValue] > 1) {
        [self downAllSuccess];
    }
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



//设置下载队列
- (void) setNetWorkQue
{
    ASINetworkQueue   *que = [[ASINetworkQueue alloc] init];
    self.netWorkQueue = que;
    [self.netWorkQueue reset];
    [self.netWorkQueue setShowAccurateProgress:YES];
    [self.netWorkQueue setShouldCancelAllRequestsOnFailure:YES];
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
    //将刚刚下载的项目删除出下载队列
    [BaseViewController removeCurrentDownList:self.currentDownId];
    
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
            NSMutableArray *userDefArr = [BaseViewController getSaveLocalDownList];
            for (int i=0;i<userDefArr.count;i++) {
                NSMutableDictionary *muDict = (NSMutableDictionary *)userDefArr[i];
                if ([[muDict objectForKey:@"pid"] intValue] == dView.tag) {
                    [muDict removeObjectForKey:@"downStatus"];
                    [muDict setObject:@"success" forKey:@"downStatus"];
                    
                    userDefArr[i] = muDict;
                    [BaseViewController setSaveLocalDownList:userDefArr];
                    
                }
            }
        }
    }
    self.currentDownId = nil;
    //如果下载队列中有等待下载项，则开始下载下一文件
    NSMutableArray *currentList = [BaseViewController getCurrentDownList];
    if (currentList.count>0) {
        DownComicInfo *downInfo = [currentList objectAtIndex:currentList.count-1];
        for (UIView *view in self.view.subviews) {
            if (view.tag == [downInfo.pid intValue]) {
                [self downLoadCartoon:view];
            }
        }
    }
    
    //如果右上角还没有设置编辑按钮 则进行设置
    if (self.navigationItem.rightBarButtonItem == nil) {
        UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(exitDownComic:)];
        self.navigationItem.rightBarButtonItem = exitBtn;
    }
}
#pragma mark 编辑下载项
- (void)exitDownComic:(id)sender
{
    NSArray *viewArr = self.view.subviews;
    NSMutableArray *downListArr = [BaseViewController getSaveLocalDownList];
    if (!downListArr || downListArr.count == 0) {
        SHOWALERT(@"没有可编辑的漫画");
    }else{
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
}
#pragma mark 删除下载项
- (void) deleteDownComic:(id)sender
{
    //删除页面View
    UIButton *deleBtn = (UIButton *)sender;
    int pid = deleBtn.superview.tag;
//    NSLog(@"将要删除漫画：%d",pid);
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
        
        //移除本地下载队列
        [BaseViewController removeCurrentDownList:pid];
        //删除本地存储的下载信息
        NSMutableArray *downListArr = [BaseViewController getSaveLocalDownList];
        for (NSDictionary *dict in downListArr) {
            if ([[dict objectForKey:@"pid"] intValue] == pid) {
                [downListArr removeObject:dict];
                break;
            }
        }
        [BaseViewController setSaveLocalDownList:downListArr];
        //删除本地存储的下载进度信息
        [self.downBase removeProductDownProgress:pid];
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
            downListArr = [BaseViewController getSaveLocalDownList];
            if (downListArr.count == 0) {
                self.exitStatus = NO;
                self.navigationItem.rightBarButtonItem.title = @"编辑";
            }
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
