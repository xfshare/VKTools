//
//  VKFileManager.h
//  VKFileManager
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 VKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKFileManager : NSObject
//如果不存在,就创建一个文件夹
+ (void)createDirectoryWithPath:(NSString *)Path;

//获得某个路径下的文件夹
+ (NSArray *)getAllFlodersInPath:(NSString *)path;

//获得某个路径下所有的图片
+ (NSArray *)getAllImageFileNamePath:(NSString *)path;


@end
