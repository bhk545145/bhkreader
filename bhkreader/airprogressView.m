//
//  airprogressView.m
//  bhkreader
//
//  Created by baihk on 16/3/15.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "airprogressView.h"
#import "ASProgressPopUpView.h"

@interface airprogressView ()<ASProgressPopUpViewDataSource>{
    ASProgressPopUpView *_airprogressView;
    NSString *_air;
}
@property(nonatomic,strong) UILabel *airlab;
@end
@implementation airprogressView

- (void)drawRect:(CGRect)rect{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
        _airprogressView = [[ASProgressPopUpView alloc]init];
        _airprogressView.frame = CGRectMake(0, 0, 200, 60);
        [self addSubview:_airprogressView];
        _airprogressView.progress = 0.000;
        _airprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _airprogressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_airprogressView showPopUpViewAnimated:YES];
        _airprogressView.dataSource = self;
        
        _airlab = [[UILabel alloc]init];
        _airlab.frame = CGRectMake(-30, -35, 50, 50);
        [_airprogressView addSubview:_airlab];
        _airlab.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _airlab.text = @"空气";
    }
    return self;
}

- (void)toair:(NSString *)air{
    _air = air;
    [self progress];
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if(progress < 0.33){
        s = [NSString stringWithFormat:@"差"];
    }else if(progress > 0.33 && progress < 0.66){
        s = [NSString stringWithFormat:@"正常"];
    }else if(progress > 0.66 && progress < 1){
        s = [NSString stringWithFormat:@"良"];
    }else if(progress == 1){
        s = [NSString stringWithFormat:@"优"];
    }
    return s;
}

- (void)progress
{
    float progress = _airprogressView.progress;
    if (progress < 1 - [_air floatValue] / 3) {
        progress += 0.005;
        _airprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}

@end
