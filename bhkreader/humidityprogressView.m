//
//  humidityprogressView.m
//  bhkreader
//
//  Created by baihk on 16/3/15.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "humidityprogressView.h"
#import "ASProgressPopUpView.h"

@interface humidityprogressView ()<ASProgressPopUpViewDataSource>{
    ASProgressPopUpView *_humidityprogressView;
    NSString *_humidity;
}

@end
@implementation humidityprogressView

- (void)drawRect:(CGRect)rect{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
        _humidityprogressView = [[ASProgressPopUpView alloc]init];
        _humidityprogressView.frame = CGRectMake(0, 0, 200, 60);
        [self addSubview:_humidityprogressView];
        _humidityprogressView.progress = 0.000;
        _humidityprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _humidityprogressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_humidityprogressView showPopUpViewAnimated:YES];
        _humidityprogressView.dataSource = self;
    }
    return self;
}

- (void)tohumidity:(NSString *)humidity{
    _humidity = humidity;
    [self progress];
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if(progress < [_humidity floatValue] / 100){
        s = [NSString stringWithFormat:@"%0.1f°",progress * 100];
    }else{
        s = [NSString stringWithFormat:@"%0.1f°",[_humidity floatValue]];
    }
    
    return s;
}

- (void)progress
{
    float progress = _humidityprogressView.progress;
    if (progress < [_humidity floatValue] / 100) {
        progress += 0.005;
        _humidityprogressView.progress = progress;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progress) userInfo:nil repeats:NO];
    }
}

@end
