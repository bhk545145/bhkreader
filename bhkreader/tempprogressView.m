//
//  tempprogressView.m
//  bhkreader
//
//  Created by baihk on 16/3/14.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "tempprogressView.h"
#import "ASProgressPopUpView.h"

@interface tempprogressView ()<ASProgressPopUpViewDataSource>{
    ASProgressPopUpView *_tempprogressView;
    NSString *_temperature;
}

@end

@implementation tempprogressView

- (void)drawRect:(CGRect)rect{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
        _tempprogressView = [[ASProgressPopUpView alloc]init];
        _tempprogressView.frame = CGRectMake(0, 0, 200, 60);
        [self addSubview:_tempprogressView];
        _tempprogressView.progress = 0.000;
        _tempprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _tempprogressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_tempprogressView showPopUpViewAnimated:YES];
        _tempprogressView.dataSource = self;
    }
    return self;
}

- (void)totemperature:(NSString *)temperature{
    _temperature = temperature;
    [self progress];
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if(progress < [_temperature floatValue] / 40){
        s = [NSString stringWithFormat:@"%0.1f°",progress * 40];
    }else{
        s = [NSString stringWithFormat:@"%0.1f°",[_temperature floatValue]];
    }
    
    return s;
}

- (void)progress
{
    float progress = _tempprogressView.progress;
    if (progress < [_temperature floatValue] / 40) {
        progress += 0.005;
        _tempprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}
@end
