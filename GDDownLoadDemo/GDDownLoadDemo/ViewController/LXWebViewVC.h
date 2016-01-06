//
//  LXWebViewVC.h
//  GoodLuck
//
//  Created by 冠东 陈 on 15/8/20.
//  Copyright (c) 2015年 郑州立信科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXWebViewVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong)NSURL *url;
@end
