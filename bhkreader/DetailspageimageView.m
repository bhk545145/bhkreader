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

@interface DetailspageimageView()<UITextFieldDelegate>{
    UIView *backgroundView;
    UIView *topview;
    UITextField *namelab;
    UISwitch *lockswitch;
    Detailbtn *updatebtn;
    CGRect topviewframe;
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
        namelab = [[UITextField alloc]init];
        namelab.frame = CGRectMake(30, 10, 150, 30);
        namelab.font = [UIFont fontWithName:@"Arial" size:22.0f];
        namelab.borderStyle = UITextBorderStyleRoundedRect;
        namelab.delegate = self;
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
    [namelab resignFirstResponder];
}

- (void)SinleTap:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.3 animations:^{
        topview.frame = CGRectMake(topview.bounds.origin.x+topview.frame.size.width*0.6,topview.bounds.origin.y+topview.frame.size.height*0.6, 0, 0);
        [namelab removeFromSuperview];
        [updatebtn removeFromSuperview];
        [lockswitch removeFromSuperview];
    } completion:^(BOOL finished) {
        [topview removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}
//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [namelab resignFirstResponder];
    return YES;
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.frame = CGRectMake(0, -283, self.frame.size.width, self.frame.size.height);
        topview.frame = CGRectMake(50, 20, self.frame.size.width - 100, self.frame.size.height - 300);
    } completion:^(BOOL finished) {}];

}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        topview.frame = CGRectMake(50, 150, self.frame.size.width - 100, self.frame.size.height - 300);
    } completion:^(BOOL finished) {}];
}
@end
