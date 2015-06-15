//
//  KeyboardManager.h
//  KeyboardManager
//
//  Created by mac on 6/2/15.
//  Copyright (c) 2015 VKan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kKeyboardShowingNotification;


typedef NS_ENUM(NSUInteger, KitMoveType) {
    KitMoveTypeLess,//只有当键盘覆盖,移动
    KitMoveTypeAll,//紧贴键盘
};

@interface KeyboardManager : NSObject;
+ (KeyboardManager *)standInit;
- (void)addObserverInKit:(UIView *)view;
- (void)addObserverInKit:(UIView *)view moveType:(KitMoveType)moveType;
- (void)addObserverKit:(UIView *)regView transfromKit:(UIView *)view;
- (void)addObserverKit:(UIView *)regView transfromKit:(UIView *)view moveType:(KitMoveType)moveType;
@end
