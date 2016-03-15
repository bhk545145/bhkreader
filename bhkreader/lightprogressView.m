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
@property(nonatomic,strong) UILabel *lightlab;
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
        
        _lightlab = [[UILabel alloc]init];
        _lightlab.frame = CGRectMake(-30, -35, 50, 50);
        [_lightprogressView addSubview:_lightlab];
        _lightlab.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _lightlab.text = @"光照";
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
    if(progress < 0.33){
        s = [NSString stringWithFormat:@"暗"];
    }else if(progress > 0.33 && progress < 0.66){
        s = [NSString stringWithFormat:@"昏暗"];
    }else if(progress > 0.66 && progress < 1){
        s = [NSString stringWithFormat:@"正常"];
    }else if(progress == 1){
        s = [NSString stringWithFormat:@"亮"];
    }
    
    return s;
}

- (void)progress
{
    float progress = _lightprogressView.progress;
    if (progress < [_light floatValue] / 3) {
        progress += 0.005;
        _lightprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}

@end
