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
    if(progress < [_air floatValue] / 100){
        s = [NSString stringWithFormat:@"%0.1f°",progress * 100];
    }else{
        s = [NSString stringWithFormat:@"%0.1f°",[_air floatValue]];
    }
    
    return s;
}

- (void)progress
{
    float progress = _airprogressView.progress;
    if (progress < [_air floatValue] / 100) {
        progress += 0.005;
        _airprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}

@end
