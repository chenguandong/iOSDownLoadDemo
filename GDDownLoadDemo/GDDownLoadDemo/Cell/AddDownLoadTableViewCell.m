//
//  AddDownLoadTableViewCell.m
//  GDDownLoadDemo
//
//  Created by 冠东 陈 on 15/12/23.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "AddDownLoadTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DownLoadFileModel.h"
@interface AddDownLoadTableViewCell ()

//下载图片
@property (weak, nonatomic) IBOutlet UIImageView *downloadImageView;

//下载名称
@property (weak, nonatomic) IBOutlet UILabel *downLoadNameLable;


@end

@implementation AddDownLoadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - get set

- (void)setModel:(DownLoadFileModel *)model{

    if (model) {
        
        _model = model;
        
        [_downloadImageView sd_setImageWithURL:[NSURL URLWithString:model.downloadFileUrl] placeholderImage:[UIImage imageNamed:@"default"]];
        
        _downLoadNameLable.text = model.downloadFileName;
        
    }
}


#pragma mark - IBAction

//点击添加按钮事件
- (IBAction)downLoadButtonClickAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(onDownloadButtonClick:)]) {
        
        [_delegate onDownloadButtonClick:_model];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
