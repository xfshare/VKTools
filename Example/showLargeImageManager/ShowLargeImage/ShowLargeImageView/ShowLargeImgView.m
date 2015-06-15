//
//  ShowLargeImgView.m
//  AGATE_Max
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ShowLargeImgView.h"
#import "VKWebImageManager.h"

@interface ShowLargeImgView() <UIScrollViewDelegate>
{
    __block CGFloat imgW;
    __block CGFloat imgH;
    BOOL HorizontalScroll;
    UIImageView *imagev;
    CGPoint frontOffset;

}
@property (nonatomic,strong)NSString *urlStr;

@property (nonatomic,strong)UIScrollView *scrollV;
@end

@implementation ShowLargeImgView
@synthesize scrollV;



- (instancetype)initWithUrl:(NSString *)url{
    
    CGRect frame = CGRectMake(0,
                              0,
                              [UIScreen mainScreen].bounds.size.width,
                              [UIScreen mainScreen].bounds.size.height);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.urlStr = url;
        imgW = 30;
        imgH = 30;
        
        [self buildScrollView];
        [self buildImageVivew];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url imgW:(CGFloat)width imgH:(CGFloat)height{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.urlStr = url;
        imgW = width;
        imgH = height;
        
        [self buildScrollView];
        [self buildImageVivew];
        
    }
    return self;
}

- (void)buildScrollView{
    scrollV = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollV.center = self.center;
    scrollV.backgroundColor = [UIColor clearColor];
    scrollV.delegate = self;
    scrollV.bounces=YES;
    scrollV.bouncesZoom=YES;
    scrollV.minimumZoomScale=1;
    scrollV.contentSize = scrollV.frame.size;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.directionalLockEnabled = YES;
    [self addSubview:scrollV];

}

- (void)buildImageVivew{
    imagev = [[UIImageView alloc] init];
    imagev.frame = CGRectMake(0, 0, CGRectGetWidth(scrollV.frame), CGRectGetHeight(scrollV.frame));
    [imagev setUserInteractionEnabled:YES];
    [imagev setContentMode:UIViewContentModeScaleAspectFit];
    [scrollV addSubview:imagev];
    [VKWebImageManager setDownLoadProgressImageWithUrl:self.urlStr
                                           OnImageView:imagev
                                                finish:^(UIImage *image) {
                                                    if (image) {
                                                        imgW = image.size.width;
                                                        imgH = image.size.height;
                                                        [self imageViewFrameWithImageSize:CGSizeMake(imgW, imgH) superFarme:scrollV.frame];
                                                    }
        
    }];

    
    UITapGestureRecognizer *disVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disSelfView:)];
    disVTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:disVTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTpaGestureAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    [disVTap requireGestureRecognizerToFail:doubleTap];
    
}

- (void) doubleTpaGestureAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"double tap");
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if(scrollV.zoomScale == scrollV.maximumZoomScale){
                             scrollV.zoomScale = 1.0;
                         }else{
                             scrollV.zoomScale = scrollV.maximumZoomScale;
                         }

                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) imageViewFrameWithImageSize:(CGSize)size superFarme:(CGRect)suFrame
{
    //判断首先缩放的值
    float scaleX = suFrame.size.width/size.width;
    float scaleY = suFrame.size.height/size.height;
    
    //倍数小的，先到边缘
    
    if (scaleX > scaleY)
    {
        //Y方向先到边缘
        float imgViewWidth = size.width*scaleY;
        scrollV.maximumZoomScale = suFrame.size.width/imgViewWidth;
        
        imagev.frame = (CGRect){suFrame.size.width/2-imgViewWidth/2,0,imgViewWidth,suFrame.size.height};
    }
    else
    {
        //X先到边缘
        float imgViewHeight = size.height*scaleX;
        scrollV.maximumZoomScale = suFrame.size.height/imgViewHeight;
        
        imagev.frame = (CGRect){0,suFrame.size.height/2-imgViewHeight/2,suFrame.size.width,imgViewHeight};
    }
}

- (void)disSelfView:(UITapGestureRecognizer *)gesture{
    [self removeFromSuperview];
}

#pragma mark - ScrollView delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return imagev;
}


-(void)scrollViewDidZoom:(UIScrollView *)scrollView{

    //显示size
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = imagev.frame;
    CGSize contentSize = scrollView.contentSize;
    
    //内容中心点
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    

    // imageV frame 在改变
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    imagev.center = centerPoint;

}


@end
