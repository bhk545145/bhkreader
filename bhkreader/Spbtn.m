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

@interface Spbtn ()
{
    dispatch_queue_t networkQueue;
}

@property (nonatomic, strong) BLNetwork *network;
@property (nonatomic, strong) NSString *mac;

@end

@implementation Spbtn

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        networkQueue = dispatch_queue_create("BroadLinkSP2NetworkQueue", DISPATCH_QUEUE_SERIAL);
        _network = [[BLNetwork alloc] init];
    }
    return self;
}

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

- (void)setuptitle:(NSString *)title titleColor:(UIColor *)titleColor NormalImage:(NSString *)NormalImage HighlightedImage:(NSString *)HighlightedImage{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:NormalImage] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:HighlightedImage] forState:UIControlStateHighlighted];
}


- (void)stateButtonClicked:(UIButton *)button
{
    int status = !button.isSelected;
    if ([button.titleLabel.text isEqualToString:@"ON"]) {
        status = 0;
    }else{
        status = 1;
    }
    dispatch_async(networkQueue, ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:72] forKey:@"api_id"];
        [dic setObject:@"sp2_control" forKey:@"command"];
        [dic setObject:_mac forKey:@"mac"];
        [dic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [_network requestDispatch:requestData];
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status)
                    [self setuptitle:@"ON" titleColor:[UIColor brownColor] NormalImage:@"ON.png" HighlightedImage:@"ON1.png"];
                else{
                    [self setuptitle:@"OFF" titleColor:[UIColor redColor] NormalImage:@"OFF.png" HighlightedImage:@"OFF1.png"];
                }
            });
        }
        else if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == -106)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"逗比" message:@"你操作的太快了" delegate:nil cancelButtonTitle:@"对不起" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
        else
        {
            NSLog(@"Set status failed!%d",[[[responseData objectFromJSONData] objectForKey:@"code"] intValue]);
            //TODO;
        }
    });
}



@end
