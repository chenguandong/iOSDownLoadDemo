//
//  DownloadCell.h
//  lxDownloadDemo
//
//  Created by 冠东 陈 on 15/12/7.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownloadInfoModel;
@protocol DownloadCellDelegate <NSObject>

- (void)startButtonClick:(DownloadInfoModel*)downloadModel;

- (void)stopButtonClick:(DownloadInfoModel*)downloadModel;

@end

@interface LXDownloadCell : UITableViewCell

@property(nonatomic,weak)id<DownloadCellDelegate>delegate;

@property(nonatomic,strong)DownloadInfoModel *downloadModel;

@property(nonatomic,assign)BOOL downloaded;

@end
