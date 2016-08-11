//
//  HaloClean.h
//  AppOfViva
//
//  Created by qianfeng on 16/3/5.
//  Copyright © 2016年 YWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface HaloClean : NSObject

// 计算单个文件大小
+ (float)fileSizeAtPath:(NSString *)path;
// 计算目录大小
+ (float)folderSizeAtPath:(NSString *)path;
// 清理缓存文件
+ (void)clearCahce:(NSString *)path WithError:(NSError *)error;

@end
