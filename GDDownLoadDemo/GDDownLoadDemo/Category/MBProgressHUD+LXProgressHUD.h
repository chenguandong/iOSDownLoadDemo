//
//  MBProgressHUD+LXProgressHUD.h
//  BossBuy
//
//  Created by chenguandong on 15/7/1.
//  Copyright (c) 2015年 郑州立信科技. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LXProgressHUD)
+ (MBProgressHUD *)createHUD;

+ (void)showHUDWithTextAutoHidden:(NSString*)text;

+(void)showHUDWithText_loding_AutoHidden;
@end

