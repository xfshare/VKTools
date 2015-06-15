//
//  ShowLargeImgView.h
//  AGATE_Max
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowLargeImgView : UIView
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url imgW:(CGFloat)width imgH:(CGFloat)height;
@end
