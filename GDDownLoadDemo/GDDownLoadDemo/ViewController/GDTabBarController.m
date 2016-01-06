//
//  GDTabBarController.m
//  GDDownLoadDemo
//
//  Created by 冠东 陈 on 15/12/23.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "GDTabBarController.h"
#import "AddDownloadTableViewController.h"
#import "LXDownloadViewController.h"
@interface GDTabBarController ()

@property(nonatomic,strong)AddDownloadTableViewController *addDownloadVC;

@property(nonatomic,strong)LXDownloadViewController *downloadVC;

@end

@implementation GDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    _downloadVC = [[LXDownloadViewController alloc]init];
    
    _addDownloadVC = [[AddDownloadTableViewController alloc]init];
    
    
    //直播
    UINavigationController *addNavVc = [[UINavigationController alloc]initWithRootViewController:_addDownloadVC];
    
    UITabBarItem *addTabBarItem = [[UITabBarItem alloc]initWithTitle:@"添加" image:[UIImage imageNamed:@"live.png"] tag:1];
    
    addNavVc.tabBarItem = addTabBarItem;
    
    //专栏
    UINavigationController *downloadNavVc = [[UINavigationController alloc]initWithRootViewController:_downloadVC];
    
    UITabBarItem *downloadTabBarItem = [[UITabBarItem alloc]initWithTitle:@"专栏" image:[UIImage imageNamed:@"spe.png"] tag:2];
    
    downloadNavVc.tabBarItem = downloadTabBarItem;
    
    [self setViewControllers:@[addNavVc,downloadNavVc] animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
