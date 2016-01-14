//
//  MBProgressHUD+LXProgressHUD.m
//  BossBuy
//
//  Created by chenguandong on 15/7/1.
//  Copyright (c) 2015年 郑州立信科技. All rights reserved.
//

#import "MBProgressHUD+LXProgressHUD.h"

@implementation MBProgressHUD (LXProgressHUD)

+ (MBProgressHUD *)createHUD
{
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];

    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    
    [window addSubview:HUD];
    
    [HUD show:YES];
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}

+(void)hide:(MBProgressHUD*)hud{

    [hud hide:YES];
}

+ (void)showHUDWithTextAutoHidden:(NSString*)text{

    
    MBProgressHUD *HUD = [self createHUD];
    
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;

    [HUD hide:YES afterDelay:2];

}

+(void)showHUDWithText_loding_AutoHidden{
    
    [self showHUDWithTextAutoHidden:@"加载中..."];
    
}


+(void)HUDError{
    
    MBProgressHUD *HUD = [self createHUD];
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD_Error"]];
    HUD.labelText = @"网络异常，发送失败";
    [HUD hide:YES afterDelay:1.0];
}

@end
