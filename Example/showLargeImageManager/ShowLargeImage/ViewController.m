//
//  ViewController.m
//  ShowLargeImage
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 xfshare. All rights reserved.
//

#import "ViewController.h"
#import "ShowLargeImgView.h"
#import <SDImageCache.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showAction:(UIButton *)sender {
    

    
    __unused ShowLargeImgView *showLarge =[[ShowLargeImgView alloc]initWithUrl:@"http://www.osxtoy.com/wp-content/uploads/2014/02/C53064CD-2F82-4716-A704-1233B44B8062.jpg"];
    [self.view addSubview:showLarge];
    
}

@end
