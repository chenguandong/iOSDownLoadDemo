//
//  DownloadCell.m
//  lxDownloadDemo
//
//  Created by 冠东 陈 on 15/12/7.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadInfoModel.h"
@interface DownloadCell ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UILabel *downLable;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation DownloadCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setDownloadModel:(DownloadInfoModel *)downloadModel{

    if (downloadModel) {
        _downloadModel = downloadModel;
        _progressView.progress = downloadModel.downloadProgress;
        _downLable.text = [NSString stringWithFormat:@"%.0lf%%",downloadModel.downloadProgress*100];
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
