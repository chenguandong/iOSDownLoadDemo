//
//  DownloadCell.m
//  lxDownloadDemo
//
//  Created by 冠东 陈 on 15/12/7.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "LXDownloadCell.h"
#import "DownloadInfoModel.h"

@interface LXDownloadCell ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *downLable;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@property (weak, nonatomic) IBOutlet UIImageView *downLoadImageView;

@property (weak, nonatomic) IBOutlet UILabel *dwonLoadFileName;

@property (weak, nonatomic) IBOutlet UILabel *stateLable;

@end

@implementation LXDownloadCell

- (void)awakeFromNib {
    // Initialization code
    _progressView.hidden = YES;
}


- (void)setDownloaded:(BOOL)downloaded{

    _downloaded = downloaded;
    _startButton.hidden   = downloaded;
    
    _downLable.hidden  = downloaded;
    

}

- (void)setDownloadModel:(DownloadInfoModel *)downloadModel{

    if (downloadModel) {
        _downloadModel = downloadModel;
        _progressView.progress = downloadModel.downloadProgress;
        _downLable.text = [NSString stringWithFormat:@"%.0lf%%",downloadModel.downloadProgress*100];
        
        [_downLoadImageView sd_setImageWithURL:[NSURL URLWithString:downloadModel.imageUrl] placeholderImage:[UIImage imageNamed:@"logo180"]];
        _dwonLoadFileName.text = downloadModel.fileTitle;
        
        if (downloadModel.isDownloading) {
            [_startButton setBackgroundImage:[UIImage imageNamed:@"d_zanting"] forState:UIControlStateNormal];
            _stateLable.text = @"下载中";
        }else{
            [_startButton setBackgroundImage:[UIImage imageNamed:@"d_xiazai"] forState:UIControlStateNormal];
            _stateLable.text = @"暂停";
        }
        
        if (downloadModel.downloadComplete) {
            _stateLable.text = @"下载完毕";
        }
    }
}


- (IBAction)buttonAction:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 11:
        {
            [_delegate startButtonClick:_downloadModel];
        }
            break;
            
        case 22:
        {
            [_delegate stopButtonClick:_downloadModel];
        }
            break;
            
        default:
            break;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
