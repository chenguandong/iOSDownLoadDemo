//
//  DownLoadFileModel.m
//  GDDownLoadDemo
//
//  Created by 冠东 陈 on 15/12/23.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "DownLoadFileModel.h"

@implementation DownLoadFileModel

- (instancetype)initWithDownloadFileName:(NSString*)downLoadFileName
                         downLoadFileUrl:(NSString*)downLoadFileUrl
                    downloadFileImageUrl:(NSString*)downloadFileImageUrl
{
    self = [super init];
    if (self) {
        _downloadFileName  = downLoadFileName;
        
        _downloadFileUrl =downLoadFileUrl;
        
        _downloadFileImageUrl = downloadFileImageUrl;
    }
    return self;
}

@end
