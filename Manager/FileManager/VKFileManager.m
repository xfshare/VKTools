//
//  VKFileManager.m
//  VKFileManager
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 VKan. All rights reserved.
//

#import "VKFileManager.h"

@implementation VKFileManager


//如果不存在,就创建一个文件夹
+ (void)createDirectoryWithPath:(NSString *)Path{
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSysDir = false;
    BOOL isSysDirEx = [fileManager fileExistsAtPath:Path isDirectory:&isSysDir];
    if (!isSysDirEx && !isSysDir) {
        [fileManager createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//获得某个路径下的文件夹
+ (NSArray *)getAllFlodersInPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [self createDirectoryWithPath:path];
    NSError *error = nil;
    NSMutableArray *fileList = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:path error:&error]];
    //过滤
    //.DS_Store 隐藏文件
    [fileList removeObject:@".DS_Store"];
    
    return fileList;
}

//获得某个路径下所有的图片
+ (NSArray *)getAllImageFileNamePath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [self createDirectoryWithPath:path];
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *name in fileList) {
        if ([name hasSuffix:@".png"] || [name hasSuffix:@".jpg"] || [name hasSuffix:@".jpeg"] || [name hasSuffix:@".gif"]) {
            [tmpArr addObject:name];
        }
    }
    
    return tmpArr;
}


@end
