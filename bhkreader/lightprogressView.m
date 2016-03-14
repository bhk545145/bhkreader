//
//  lightprogressView.m
//  bhkreader
//
//  Created by baihk on 16/3/15.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "lightprogressView.h"
#import "ASProgressPopUpView.h"

@interface lightprogressView ()<ASProgressPopUpViewDataSource>{
    ASProgressPopUpView *_lightprogressView;
    NSString *_light;
}

@end
@implementation lightprogressView

- (void)drawRect:(CGRect)rect{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
        _lightprogressView = [[ASProgressPopUpView alloc]init];
        _lightprogressView.frame = CGRectMake(0, 0, 200, 60);
        [self addSubview:_lightprogressView];
        _lightprogressView.progress = 0.000;
        _lightprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _lightprogressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_lightprogressView showPopUpViewAnimated:YES];
        _lightprogressView.dataSource = self;
    }
    return self;
}

- (void)tolight:(NSString *)light{
    _light = light;
    [self progress];
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if(progress < [_light floatValue] / 100){
        s = [NSString stringWithFormat:@"%0.1f°",progress * 100];
    }else{
        s = [NSString stringWithFormat:@"%0.1f°",[_light floatValue]];
    }
    
    return s;
}

- (void)progress
{
    float progress = _lightprogressView.progress;
    if (progress < [_light floatValue] / 100) {
        progress += 0.005;
        _lightprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}

@end
