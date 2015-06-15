//
//  UIImage+VKExtern.h
//  ImagePickerDemo
//
//  Created by mac on 6/15/15.
//  Copyright (c) 2015 VKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (VKExtend)

/**
 *  处理通过拍照,获取的图片,进行Orientation转化
 *
 */
- (UIImage *)vk_FixOrientation;
@end
