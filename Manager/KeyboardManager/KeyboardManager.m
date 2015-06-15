//
//  KeyboardManager.m
//  KeyboardManager
//
//  Created by mac on 6/2/15.
//  Copyright (c) 2015 VKan. All rights reserved.
//

#import "KeyboardManager.h"

static NSString *const KitName = @"KITNAME";
static NSString *const KitTransK = @"KITTRANSK";
static NSString *const KitMovType = @"KitMoveType";


NSString *const kKeyboardShowingNotification = @"kKeyboardShowingNotification";

@interface KeyboardManager()
{
    NSMutableArray *AllObserverKit;
    NSNotification *frontShowNoti;//上一次键盘显示的时候,键盘信息.键盘隐藏时,clear
}
@end

@implementation KeyboardManager
+ (KeyboardManager *)standInit{
    return [[self alloc] init];
}
#pragma mark cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self regisiterNotification];
        AllObserverKit = [NSMutableArray array];
    }
    return self;
}

#pragma mark public method
/**
 *  获取view中的tf和tv KitMoveTypeLess
 */
- (void)addObserverInKit:(UIView *)view{
    [self addObserverInKit:view moveType:KitMoveTypeLess];
}

- (void)addObserverInKit:(UIView *)view moveType:(KitMoveType)moveType{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
            [self addObserverKit:subView transfromKit:view moveType:moveType ];
        }
    }
}

- (void)addObserverKit:(UIView *)regView transfromKit:(UIView *)view{
    [self addObserverKit:regView
            transfromKit:view
                moveType:KitMoveTypeLess];
}

- (void)addObserverKit:(UIView *)regView transfromKit:(UIView *)view moveType:(KitMoveType)moveType{
    NSMutableDictionary *kitDict = [NSMutableDictionary dictionary];
    
    if (!regView || !view) {
        return;
    }
    
    [kitDict setObject:regView forKey:KitName];
    [kitDict setObject:view forKey:KitTransK];
    [kitDict setObject:[NSNumber numberWithInteger:moveType] forKey:KitMovType];

    if (![AllObserverKit containsObject:kitDict]) {
        [AllObserverKit addObject:kitDict];
    }

}


#pragma mark private method
- (void)regisiterNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFirstResponder:)
                                                 name:kKeyboardShowingNotification
                                               object:nil];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardShow:(NSNotification *)notic{
    NSLog(@"\nKeyboard Show:\n%@",notic);
    
    frontShowNoti = notic;
    
    if (!frontShowNoti) {
        return;
    }
    
    NSDictionary *kitDict = [self getBecomeFirstResponderInfo];
    if (kitDict) {
        KitMoveType moveType = [[kitDict objectForKey:KitMovType] integerValue];
        
        UIView *regView = [kitDict objectForKey:KitName];
        CGRect regViewWinRect =[regView convertRect:regView.bounds toView:nil];
        
        NSDictionary *noticDict = notic.userInfo;
        CGFloat time = [[noticDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect keyboardRect = [[noticDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat regViewMaxY = CGRectGetMinY(keyboardRect);
        CGFloat curRegViewMaxY = CGRectGetMaxY(regViewWinRect);
        __block UIView *transView = [kitDict objectForKey:KitTransK];

        switch (moveType) {
            case KitMoveTypeLess:
            {
                if (regViewMaxY < curRegViewMaxY) {
                    
                    
                    [UIView animateWithDuration:time
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         transView.transform = CGAffineTransformMakeTranslation(0,
                                                                                                transView.transform.ty-(curRegViewMaxY - regViewMaxY));
                                     } completion:nil];
                }
            }
                break;
            case KitMoveTypeAll:
            {
                                    
                    [UIView animateWithDuration:time
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         transView.transform = CGAffineTransformMakeTranslation(0,
                                                                                                transView.transform.ty-(curRegViewMaxY - regViewMaxY));
                                     } completion:nil];
            }
                break;
        }
        
        
    }

}

- (void)keyboardHidden:(NSNotification *)notic{
    NSLog(@"\nKeyboard Hidden:\n%@",notic);
    
    frontShowNoti = nil;
    NSDictionary *kitDict = [self getBecomeFirstResponderInfo];
    if (kitDict) {
        
        NSDictionary *noticDict = notic.userInfo;
        CGFloat time = [[noticDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        __block UIView *transView = [kitDict objectForKey:KitTransK];
        [UIView animateWithDuration:time
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             transView.transform = CGAffineTransformMakeTranslation(0,0);
                         } completion:nil];
        
    }
}

//变更第一响应者,通知
- (void)changeFirstResponder:(NSNotification *)noti{
    UIView *changeFistV = noti.object;

    if ([self isInAllObserverKit:changeFistV]) {
        [self keyboardShow:frontShowNoti];
    }
}

- (NSDictionary *)getBecomeFirstResponderInfo{
    
    for (NSDictionary *kitDict in AllObserverKit) {
        UIView *regView = [kitDict objectForKey:KitName];
        
        if (regView.isFirstResponder) {
            return kitDict;
        }
    }
    return nil;
}

- (BOOL)isInAllObserverKit:(UIView *)view{
    for (NSDictionary *kitDict in AllObserverKit) {
        UIView *regView = [kitDict objectForKey:KitName];
        
        if ([regView isEqual:view]) {
            return YES;
        }
    }
    return NO;

}
@end
