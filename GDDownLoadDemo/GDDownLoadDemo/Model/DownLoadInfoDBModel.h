//
//  DownLoadInfoDBModel.h
//  RedLiving
//
//  Created by chenguandong on 15/12/10.
//  Copyright © 2015年 冠东陈. All rights reserved.
//

#import <Realm/Realm.h>

@interface DownLoadInfoDBModel : RLMObject
//显示名字
@property(nonatomic,copy)NSString * videoName;
//下载地址
@property(nonatomic,copy)NSString * videoUrl;
//下载状态
@property(nonatomic,assign)int videoState;
//图片路径
@property(nonatomic,copy)NSString  *videoImage;
//本地文件名称
@property(nonatomic,copy)NSString *localFileName;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<DownLoadInfoDBModel>
RLM_ARRAY_TYPE(DownLoadInfoDBModel)
