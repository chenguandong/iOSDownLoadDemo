//
//  DownLoadFileModel.h
//  GDDownLoadDemo
//
//  Created by 冠东 陈 on 15/12/23.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadFileModel : NSObject

@property(nonatomic,copy)NSString *downloadFileUrl;

@property(nonatomic,copy)NSString *downloadFileName;

@property(nonatomic,copy)NSString *downloadFileImageUrl;

- (instancetype)initWithDownloadFileName:(NSString*)downLoadFileName
                         downLoadFileUrl:(NSString*)downLoadFileUrl
                    downloadFileImageUrl:(NSString*)downloadFileImageUrl;
@end
