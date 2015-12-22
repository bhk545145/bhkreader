//
//  Spbtn.m
//  bhkreader
//
//  Created by bai on 15/11/27.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "Spbtn.h"
#import "BLNetwork.h"
#import "JSONKit.h"
#import "BLSDKTool.h"

@interface Spbtn ()
{
    dispatch_queue_t networkQueue;
}
@property (nonatomic, strong) NSString *mac;

@end

@implementation Spbtn

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        networkQueue = dispatch_queue_create("BroadLinkSP2NetworkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
//SP开关样式
- (void)setTitle:(NSString *)title forState:(UIControlState)state mac:(NSString *)mac
{
    _mac = mac;
    [super setTitle:title forState:state];
    if ([title  isEqual: @"ON"])
        [self setuptitle:@"ON" titleColor:[UIColor brownColor] NormalImage:@"ON.png" HighlightedImage:@"ON1.png"];
    else
        [self setuptitle:@"OFF" titleColor:[UIColor redColor] NormalImage:@"OFF.png" HighlightedImage:@"OFF1.png"];
    [self addTarget:self action:@selector(stateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
//SP开关样式
- (void)setuptitle:(NSString *)title titleColor:(UIColor *)titleColor NormalImage:(NSString *)NormalImage HighlightedImage:(NSString *)HighlightedImage{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:NormalImage] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:HighlightedImage] forState:UIControlStateHighlighted];
}

//操作SP开关
- (void)stateButtonClicked:(UIButton *)button
{
    int status = !button.isSelected;
    if ([button.titleLabel.text isEqualToString:@"ON"]) {
        status = 0;
    }else{
        status = 1;
    }
    dispatch_async(networkQueue, ^{
        BLSDKTool *blsdktool = [BLSDKTool responseDatatoapiid:72 command:@"sp2_control" mac:_mac status:status];
        //NSLog(@"%d",blsdktool.code);
        if (blsdktool.code == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status)
                    [self setuptitle:@"ON" titleColor:[UIColor brownColor] NormalImage:@"ON.png" HighlightedImage:@"ON1.png"];
                else{
                    [self setuptitle:@"OFF" titleColor:[UIColor redColor] NormalImage:@"OFF.png" HighlightedImage:@"OFF1.png"];
                }
            });
        }
        else if (blsdktool.code == -106)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"逗比" message:@"你操作的太快了" delegate:nil cancelButtonTitle:@"对不起" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
        else
        {
            NSLog(@"Set status failed!%d",blsdktool.code);
            //TODO;
        }
    });
}
//获取SP开关状态
- (int)Sprefresh:(NSString *)mac{
    int spstate;
    BLSDKTool *blsdktool = [BLSDKTool responseDatatoapiid:71 command:@"sp2_refresh" mac:mac];
    if (blsdktool.code == 0)
    {
        spstate = blsdktool.status;
    }
    return spstate;
}


@end
