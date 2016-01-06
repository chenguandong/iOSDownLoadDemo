//
//  DownloadInfoModel.h
//  lxDownloadDemo
//
//  Created by 冠东 陈 on 15/12/7.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadInfoModel : NSObject

@property (nonatomic, copy) NSString *fileTitle;

@property (nonatomic, copy) NSString *downloadSource;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSData *taskResumeData;

@property (nonatomic,assign) double downloadProgress;

@property (nonatomic,assign) BOOL isDownloading;

@property (nonatomic,assign) BOOL downloadComplete;

@property (nonatomic,assign) unsigned long taskIdentifier;

//其他

@property(nonatomic,copy)NSString *imageUrl;


-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source;

@end
