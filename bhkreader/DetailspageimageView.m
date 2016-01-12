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
#import "UIImage+MJ.h"
#import "Rm2btn.h"

@interface DetailspageimageView()<UITextFieldDelegate>{
    UIView *backgroundView;
    UIView *topview;
    UIImageView *imageview;
    UITextField *namelab;
    UISwitch *lockswitch;
    Detailbtn *updatebtn;
    CGRect topviewframe;
    Rm2btn *rm2btn;
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
        topview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [window addSubview:topview];
        //imageview
        imageview = [[UIImageView alloc]init];
        imageview.frame = CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height);
        imageview.image = [UIImage imageNamed:@"timeline"];
        [topview addSubview:imageview];
        //name的UILabel框
        namelab = [[UITextField alloc]init];
        namelab.frame = CGRectMake(30, 10, 210, 30);
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
        //rm2按钮
        rm2btn = [Rm2btn buttonWithType:UIButtonTypeRoundedRect];
        rm2btn.frame = CGRectMake(30, 100, 60, 60);
        [topview addSubview:rm2btn];
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
    [updatebtn addTarget:self action:@selector(upButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rm2btn setBackgroundImage:(_BLDeviceinfo.rmlistInfo.dataid)?@"1024" : @"rm2btn" forState:UIControlStateNormal mac:_BLDeviceinfo.mac];
}

- (void)upButtonClicked:(UIButton *)button{
    [updatebtn setmac:_BLDeviceinfo.mac name:namelab.text lock:lockswitch.on];
    [namelab resignFirstResponder];
}


- (void)SinleTap:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.3 animations:^{
        imageview.frame = CGRectMake(imageview.bounds.origin.x+imageview.frame.size.width*0.5,imageview.bounds.origin.y+imageview.frame.size.height*0.5, 0, 0);
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
