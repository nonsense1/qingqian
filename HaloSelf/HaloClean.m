//
//  HaloClean.m
//  AppOfViva
//
//  Created by qianfeng on 16/3/5.
//  Copyright © 2016年 YWX. All rights reserved.
//

#import "HaloClean.h"

@implementation HaloClean

//单个文件
+ (float)fileSizeAtPath:(NSString *)path {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        
        long long size = [manager attributesOfFileSystemForPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

// 目录
+ (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    float folderSize;
    if ([manager fileExistsAtPath:path]) {
        // 获取所有的子文件
        NSArray *arrForChildFile = [manager subpathsAtPath:path];
        for (NSString *fileName in arrForChildFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        // SDWebImage框架自身缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;

    }
    return 0;
}

// 清除缓存
+ (void)clearCahce:(NSString *)path WithError:(NSError *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *childFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in childFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutePath error:&error];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    
}

@end






































