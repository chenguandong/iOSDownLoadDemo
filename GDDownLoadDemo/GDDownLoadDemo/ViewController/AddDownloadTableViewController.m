//
//  AddDownloadTableViewController.m
//  GDDownLoadDemo
//
//  Created by 冠东 陈 on 15/12/23.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import "AddDownloadTableViewController.h"
#import "AddDownLoadTableViewCell.h"
#import "DownLoadInfoDBModel.h"
#import "DownLoadFileModel.h"
@interface AddDownloadTableViewController ()<AddDownLoadTableViewCellDelegate>

@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation AddDownloadTableViewController


#pragma mark - VCLifeCycle

- (void)viewDidLoad {
    
    self.title = @"添加下载";
    
    [super viewDidLoad];
    
    _dataArr = @[].mutableCopy;
    
    [self initData];
    
    self.tableView.rowHeight = 70;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddDownLoadTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddDownLoadTableViewCell class])];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)initData{
    
    DownLoadFileModel *fileModel1 = [[DownLoadFileModel alloc]initWithDownloadFileName:@"Paul Hegarty talks about multiple MVCs .mp4" downLoadFileUrl:@"https://itunesu.assets.itunes.com/apple-assets-us-std-000001/CobaltPublic3/v4/1c/59/67/1c596734-e9aa-1c59-51ec-04c3c55b0d0b/305-6482510343294669078-07_CS193_1_28_15_WIP01_720p1500cc.mp4" downloadFileImageUrl:@""];
    
     DownLoadFileModel *fileModel2 = [[DownLoadFileModel alloc]initWithDownloadFileName:@"Lecture 10 Slides.pdf" downLoadFileUrl:@"https://itunesu.assets.itunes.com/apple-assets-us-std-000001/CobaltPublic3/v4/55/34/8d/55348d6f-09fb-2431-7f0d-f2f405ef966f/323-7534577884185676097-CS193P_Lecture_10_ED.pdf" downloadFileImageUrl:@""];
    
    [_dataArr addObject:fileModel1];
    
    [_dataArr addObject:fileModel2];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddDownLoadTableViewCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.model =_dataArr[indexPath.row];
    
    return cell;
}


#pragma mark - downloadCell delegate


- (void)onDownloadButtonClick:(DownLoadFileModel*)downLoadModel{

    //判断是否已经下载过
    
    RLMResults *dbModelArr = [DownLoadInfoDBModel objectsWhere:@"videoUrl = %@",downLoadModel.downloadFileUrl];//and videoState ==200
    
    if (dbModelArr.count!=0) {
        
        [MBProgressHUD showHUDWithTextAutoHidden:@"已经下载,别再点了"];
        
        return ;
    }
    
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    DownLoadInfoDBModel *dbModel =[[DownLoadInfoDBModel alloc]init];
    dbModel.videoName =downLoadModel.downloadFileName;
    dbModel.videoUrl =downLoadModel.downloadFileUrl ;
    dbModel.videoState = -1;
    dbModel.videoImage =downLoadModel.downloadFileImageUrl;
    dbModel.localFileName = @"";
    
    [realm addObject:dbModel];
    
    [realm commitWriteTransaction];
    
    //[MBProgressHUD showHUDWithTextAutoHidden:@"已加入下载列表"];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifacation_DownloadAdd object:nil];
    
     [MBProgressHUD showHUDWithTextAutoHidden:@"添加下载成功"];
    

}


@end
