//
//  noisyprogressView.m
//  bhkreader
//
//  Created by baihk on 16/3/15.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "noisyprogressView.h"
#import "ASProgressPopUpView.h"

@interface noisyprogressView ()<ASProgressPopUpViewDataSource>{
    ASProgressPopUpView *_noisyprogressView;
    NSString *_noisy;
}
@property(nonatomic,strong) UILabel *noisylab;
@end
@implementation noisyprogressView

- (void)drawRect:(CGRect)rect{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
        _noisyprogressView = [[ASProgressPopUpView alloc]init];
        _noisyprogressView.frame = CGRectMake(0, 0, 200, 60);
        [self addSubview:_noisyprogressView];
        _noisyprogressView.progress = 0.000;
        _noisyprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _noisyprogressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_noisyprogressView showPopUpViewAnimated:YES];
        _noisyprogressView.dataSource = self;
        
        _noisylab= [[UILabel alloc]init];
        _noisylab.frame = CGRectMake(-30, -35, 50, 50);
        [_noisyprogressView addSubview:_noisylab];
        _noisylab.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _noisylab.text = @"噪声";
    }
    return self;
}

- (void)tonoisy:(NSString *)noisy{
    _noisy = noisy;
    [self progress];
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if(progress < 0.5){
        s = [NSString stringWithFormat:@"寂静"];
    }else if(progress > 0.5 && progress < 1){
        s = [NSString stringWithFormat:@"正常"];
    }else if(progress == 1){
        s = [NSString stringWithFormat:@"吵闹"];
    }
    return s;
}

- (void)progress
{
    float progress = _noisyprogressView.progress;
    if (progress < [_noisy floatValue] / 2) {
        progress += 0.005;
        _noisyprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}

@end
