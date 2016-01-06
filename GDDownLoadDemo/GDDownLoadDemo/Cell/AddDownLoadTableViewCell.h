//
//  AddDownLoadTableViewCell.h
//  GDDownLoadDemo
//
//  Created by 冠东 陈 on 15/12/23.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownLoadFileModel;
@protocol AddDownLoadTableViewCellDelegate <NSObject>

- (void)onDownloadButtonClick:(DownLoadFileModel*)downLoadModel;

@end

@interface AddDownLoadTableViewCell : UITableViewCell

@property(nonatomic,weak)id<AddDownLoadTableViewCellDelegate>delegate;

@property(nonatomic,strong)DownLoadFileModel *model;

@end
