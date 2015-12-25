//
//  DetailspageimageView.m
//  bhkreader
//
//  Created by bai on 15/12/21.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "DetailspageimageView.h"
#import "bhkCommon.h"
#import "BLDeviceInfo.h"
#import "Detailbtn.h"

@interface DetailspageimageView(){
    UIView *backgroundView;
    UIView *topview;
    UILabel *namelab;
    UISwitch *lockswitch;
    Detailbtn *updatebtn;
}

@end
@implementation DetailspageimageView

- (void)drawRect:(CGRect)rect{

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        //半透明背景
        backgroundView = [[UIView alloc]initWithFrame:frame];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [window addSubview:backgroundView];
        //点击事件
        UITapGestureRecognizer *singleRecongnizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SinleTap:)];
        [backgroundView addGestureRecognizer:singleRecongnizer];
        //白色底View
        topview = [[UIView alloc]init];
        topview.frame = CGRectMake(frame.origin.x + 50, frame.origin.y + 150, frame.size.width - 100, frame.size.height - 300);
        topview.backgroundColor = IWColor(255, 255, 255);
        [window addSubview:topview];
        //name的UILabel框
        namelab = [[UILabel alloc]init];
        namelab.frame = CGRectMake(30, 10, 250, 30);
        namelab.font = [UIFont fontWithName:@"Arial" size:22.0f];
        
        [topview addSubview:namelab];
        //lock的uiswitch选择按钮
        lockswitch = [[UISwitch alloc]init];
        lockswitch.frame = CGRectMake(30, 50, 10, 10);
        
        [topview addSubview:lockswitch];
        //update按钮
        updatebtn = [Detailbtn buttonWithType:UIButtonTypeRoundedRect];
        updatebtn.frame = CGRectMake(200, 30, 60, 60);
        
        [topview addSubview:updatebtn];
    }
    return self;
}

- (void)setBLDeviceinfo:(BLDeviceInfo *)BLDeviceinfo{
    _BLDeviceinfo = BLDeviceinfo;
    
    //设置数据
    namelab.text = _BLDeviceinfo.name;
    [lockswitch setOn:(_BLDeviceinfo.lock) ? YES : NO animated:YES];
    
    [updatebtn setTitle:@"更新" forState:UIControlStateNormal];
    [updatebtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [updatebtn addTarget:self action:@selector(stateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)stateButtonClicked:(UIButton *)button{
    [updatebtn setmac:_BLDeviceinfo.mac name:namelab.text lock:lockswitch.on];
}


- (void)SinleTap:(UITapGestureRecognizer *)recognizer{
    [backgroundView removeFromSuperview];
    [topview removeFromSuperview];
}


@end
