//
//  ViewController.m
//  lxDownloadDemo
//
//  Created by 冠东 陈 on 15/12/7.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "LXDownloadViewController.h"
#import "DownloadInfoModel.h"
#import "LXDownloadCell.h"
#import "DownLoadInfoDBModel.h"
#import "Constant.h"
#import "LXWebViewVC.h"
#define kDownloadPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

@interface LXDownloadViewController ()<UITableViewDataSource,UITableViewDelegate, NSURLSessionDelegate,DownloadCellDelegate>

@property (nonatomic, strong) NSURLSession *session;


//存放download task
@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

//获取下载路径
@property (nonatomic, strong) NSURL *docDirectoryURL;

@end

@implementation LXDownloadViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //当然一定要慎用，记着退出程序时把自动休眠功能开启
    
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self.tableView reloadData];
    
    //禁止自动休眠可以通过这一句话搞定：
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        //初始化数据
        [self initializeFileDownloadDataArray];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewDownload) name:kNotifacation_DownloadAdd object:nil];
        
        
        NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        self.docDirectoryURL = [URLs objectAtIndex:0];
        
        [self initDownLoadSession];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"缓存";
   

    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LXDownloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LXDownloadCell class])];
    
    self.tableView.rowHeight = 80;
    

    self.tableView.tableFooterView = [UIView new];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addNewDownload{
    
    RLMResults *resultModels = [DownLoadInfoDBModel objectsWhere:@"videoState=-1"];
    
    for (DownLoadInfoDBModel *dbModel in resultModels) {
        DownloadInfoModel *downLoadInfoModel = [[DownloadInfoModel alloc] initWithFileTitle:dbModel.videoName andDownloadSource:dbModel.videoUrl];
        
        downLoadInfoModel.taskIdentifier = -1;
        downLoadInfoModel.imageUrl = dbModel.videoImage;
        
        [self.arrFileDownloadData addObject:downLoadInfoModel];
        
        downLoadInfoModel.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:downLoadInfoModel.downloadSource]];
        
        // Keep the new taskIdentifier.
        downLoadInfoModel.taskIdentifier = downLoadInfoModel.downloadTask.taskIdentifier;
        
        // Start the download.
        [downLoadInfoModel.downloadTask resume];
        
        // Indicate for each file that is being downloaded.
        downLoadInfoModel.isDownloading = YES;
        
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        dbModel.videoState = 1; //下载中
        
        [realm commitWriteTransaction];
        
        
        
    }
    
    //状态更改不能是-1 了  防止下次查询出问题
   
    
    
}

- (void)initDownLoadSession{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.gcd.download"];
    
    //是否允许移动网络下载
    sessionConfiguration.allowsCellularAccess = YES;
    //最大下载条数
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 3;
    
    //allowsCellularAccess 属性指定是否允许使用蜂窝连接， discretionary属性为YES时表示当程序在后台运作时由系统自己选择最佳的网络连接配置，该属性可以节省通过蜂窝连接的带宽。在使用后台传输数据的时候，建议使用discretionary属性，而不是allowsCellularAccess属性，因为它会把WiFi和电源可用性考虑在内。补充：这个标志允许系统为分配任务进行性能优化。这意味着只有当设备有足够电量时，设备才通过Wifi进行数据传输。如果电量低，或者只仅有一个蜂窝连接，传输任务是不会运行的。后台传输总是在discretionary模式下运行。
    sessionConfiguration.discretionary = YES;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
}



#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrFileDownloadData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LXDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LXDownloadCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Get the respective FileDownloadInfo object from the arrFileDownloadData array.
    DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:indexPath.row];
    
   
    cell.downloadModel = fdi;
    
    if (fdi.downloadComplete) {
        
        cell.downloaded = YES;
    }else{
        cell.downloaded = NO;
    }
    
    cell.delegate = self;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DownloadInfoModel *infoModel =  _arrFileDownloadData[indexPath.row];
    
    
    NSString *localFileName = [[infoModel.downloadSource  componentsSeparatedByString:@"/"] lastObject];
    
    //下载完毕
    if (infoModel.downloadComplete) {
        
        NSString *result = @"";
        result = [result stringByAppendingString:kDownloadPath];
        result = [result stringByAppendingString:@"/"];
        result = [result stringByAppendingString:localFileName];
        
        LXWebViewVC *webVC = [[LXWebViewVC alloc]init];
        
        webVC.url = [NSURL fileURLWithPath:result];
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else{
    
         [MBProgressHUD showHUDWithTextAutoHidden:@"别点了 还没下载完呢"];
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        DownloadInfoModel *infoModel = _arrFileDownloadData[indexPath.row];
        
        RLMResults *resultModel =[DownLoadInfoDBModel objectsWhere:@" videoUrl = %@",infoModel.downloadSource];
        
        
        for (DownLoadInfoDBModel *dbModel in resultModel) {
            
            //删除本地文件
            
            if (dbModel.videoState==200) {

                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:[[infoModel.downloadSource componentsSeparatedByString:@"/"] lastObject]];
                
                if ([fileManager fileExistsAtPath:[destinationURL path]]) {
                    [fileManager removeItemAtURL:destinationURL error:nil];
                }
                
               
            }else{
                
                if (infoModel.downloadTask) {
                    [infoModel.downloadTask cancel];
                }
            }
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm beginWriteTransaction];
            
            //删除数据库
            [realm deleteObject:dbModel];

            [realm commitWriteTransaction];
        }
        
        
        [_arrFileDownloadData removeObjectAtIndex:indexPath.row];
        
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




#pragma mark - DownloadCell delegate

//startOrPauseDownloadingSingleFile
- (void)startButtonClick:(DownloadInfoModel*)downloadModel{

    DownloadInfoModel *fdi = downloadModel;
    
    //没有下载 开始下载
    
    // The isDownloading property of the fdi object defines whether a downloading should be started
    // or be stopped.
    if (!fdi.isDownloading) {
        // This is the case where a download task should be started.
        
        // Create a new task, but check whether it should be created using a URL or resume data.
        if (fdi.taskIdentifier == -1) {
            // If the taskIdentifier property of the fdi object has value -1, then create a new task
            // providing the appropriate URL as the download source.
            fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
            
            // Keep the new task identifier.
            fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
            
            // Start the task.
            [fdi.downloadTask resume];
        }
        else{
            // Create a new download task, which will use the stored resume data.
            fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
            [fdi.downloadTask resume];
            
            // Keep the new download task identifier.
            fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
        }
    }
    else{  //已经下载过的 从文件恢复下载
        // Pause the task by canceling it and storing the resume data.
        [fdi.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            if (resumeData != nil) {
                fdi.taskResumeData = [[NSData alloc] initWithData:resumeData];
            }
        }];
    }
    
    // Change the isDownloading property value.
    fdi.isDownloading = !fdi.isDownloading;
    
    // Reload the table view.
    //[self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];

}

//取消下载
- (void)stopButtonClick:(DownloadInfoModel*)downloadModel{

    DownloadInfoModel *fdi = downloadModel;
    
    // Cancel the task.
    [fdi.downloadTask cancel];
    
    // Change all related properties.
    fdi.isDownloading = NO;
    fdi.taskIdentifier = -1;
    fdi.downloadProgress = 0.0;
    
    // Reload the table view.
    //[self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];

}



//开始全部下载
- (void)startAllDownloads:(id)sender {
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is already being downloaded or not.
        if (!fdi.downloadComplete) {
            if (!fdi.isDownloading) {
                // Check if should create a new download task using a URL, or using resume data.
                if (fdi.taskIdentifier == -1) {
                    fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
                }
                else{
                    fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
                }
                
                // Keep the new taskIdentifier.
                fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                
                // Start the download.
                [fdi.downloadTask resume];
                
                // Indicate for each file that is being downloaded.
                fdi.isDownloading = YES;
            }
        }
    }
    
    // Reload the table view.
    [self.tableView reloadData];
}


//取消全部下载

- (IBAction)stopAllDownloads:(id)sender {
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is being currently downloading.
        if (fdi.isDownloading) {
            // Cancel the task.
            [fdi.downloadTask cancel];
            
            // Change all related properties.
            fdi.isDownloading = NO;
            fdi.taskIdentifier = -1;
            fdi.downloadProgress = 0.0;
            fdi.downloadTask = nil;
        }
    }
    
    // Reload the table view.
    [self.tableView reloadData];
}

//重新开始全部任务 清空本地多有已经下载的文件
- (IBAction)initializeAll:(id)sender {
    // Access all FileDownloadInfo objects using a loop and give all properties their initial values.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
         DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        if (fdi.isDownloading) {
            [fdi.downloadTask cancel];
        }
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = NO;
        fdi.taskIdentifier = -1;
        fdi.downloadProgress = 0.0;
        fdi.downloadTask = nil;
    }
    
    // Reload the table view.
    [self.tableView reloadData];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get all files in documents directory.
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:self.docDirectoryURL
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (int i=0; i<[allFiles count]; i++) {
        [fileManager removeItemAtURL:[allFiles objectAtIndex:i] error:nil];
    }
}



#pragma mark - Private method implementation

-(void)initializeFileDownloadDataArray{
   
   

    self.arrFileDownloadData = @[].mutableCopy;
    
    
    RLMResults *downloadInfoArr = [DownLoadInfoDBModel allObjects];
    
    for (DownLoadInfoDBModel *dbModel in downloadInfoArr) {
        
        DownloadInfoModel *downLoadInfoModel = [[DownloadInfoModel alloc] initWithFileTitle:dbModel.videoName andDownloadSource:dbModel.videoUrl];
        
        if (dbModel.videoState==200) {
            downLoadInfoModel.downloadComplete = YES;
            
            downLoadInfoModel.downloadProgress = 1.0;
            
        }
        
        downLoadInfoModel.imageUrl = dbModel.videoImage;
        
        downLoadInfoModel.taskIdentifier = -1;
        
        [self.arrFileDownloadData addObject:downLoadInfoModel];
        
        NSLog(@"%@",dbModel.videoUrl);
        
        
    }
    
    [self startAllDownloads:nil];
   
}


-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = 0;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}


#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    
    if (success) {
        // Change the flag values of the respective FileDownloadInfo object.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        fdi.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        fdi.taskResumeData = nil;
        
        
        //更改数据库里下载状态
        
        RLMResults *relsultModels = [DownLoadInfoDBModel objectsWhere:@"videoUrl = %@",fdi.downloadSource];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        for (DownLoadInfoDBModel *dbModel in relsultModels) {
            //状态==200下载完成
            dbModel.videoState = 200;
            dbModel.localFileName = destinationFilename;
        }
        
        [realm commitWriteTransaction];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Reload the respective table view row using the main thread.
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
        
        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
    
    [downloadTask cancel];

}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
        
      
    }
    else{
        NSLog(@"Download finished successfully.");
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        DownloadInfoModel *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Calculate the progress.
            fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            
            // Get the progress view of the appropriate cell and update its progress.
            LXDownloadCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            cell.downloadModel = fdi;
            
        }];
    }
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
