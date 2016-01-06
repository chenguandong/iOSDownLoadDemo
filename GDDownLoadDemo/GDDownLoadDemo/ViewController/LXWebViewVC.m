//
//  LXWebViewVC.m
//  GoodLuck
//
//  Created by 冠东 陈 on 15/8/20.
//  Copyright (c) 2015年 郑州立信科技. All rights reserved.
//

#import "LXWebViewVC.h"

@interface LXWebViewVC ()<UIWebViewDelegate>
//@property(nonatomic,strong)MBProgressHUD *hud;
@end

@implementation LXWebViewVC

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    _webView.delegate = self;
    
    _webView.scalesPageToFit = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //_hud = [MBProgressHUD createHUD];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    //[_hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
     //[_hud hide:YES];
    
    // [MBProgressHUD showHUDWithTextAutoHidden:@"加载失败"];

}
@end
