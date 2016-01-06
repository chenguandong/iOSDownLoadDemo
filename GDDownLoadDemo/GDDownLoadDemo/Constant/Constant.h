//
//  Constant.h
//  RedLiving
//
//  Created by 冠东 陈 on 10/26/15.
//  Copyright © 2015 冠东陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
//获取 AppDelegate 实例
#define SharedApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


//有新的下载任务
UIKIT_EXTERN NSString *const kNotifacation_DownloadAdd;
