//
//  Rm2btn.m
//  bhkreader
//
//  Created by bai on 16/1/6.
//  Copyright © 2016年 bai. All rights reserved.
//

#import "Rm2btn.h"
#import "BLNetwork.h"
#import "BLSDKTool.h"
#import "JSONKit.h"
#import "MBProgressHUD+MJ.h"

@interface Rm2btn ()
{
    dispatch_queue_t networkQueue;
}
@property (nonatomic,strong) BLNetwork *network;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *data;


@end

@implementation Rm2btn

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _network = [[BLNetwork alloc] init];
        networkQueue = dispatch_queue_create("BroadLinkDetailNetworkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setBackgroundImage:(NSString *)image forState:(UIControlState)state mac:(NSString *)mac{
    _mac = mac;
    _image = image;
    [super setBackgroundImage:[UIImage imageNamed:image] forState:state];
    if ([image isEqualToString:@"rm2btn"]) {
        [self setBackgroundImage:[UIImage imageNamed:@"rm2btn"] forState:state];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"1024"] forState:state];
    }
    [self addTarget:self action:@selector(rm2ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rm2ButtonClicked:(UIButton *)button{
    if ([_image  isEqual:@"rm2btn"]) {
        [self studysetmac:_mac];
    }else{
        [self sendsetmac:_mac data:_data];
    }
}

- (void)studysetmac:(NSString *)mac{
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:132 command:@"rm2_study" mac:mac];
        if (sdktool.code == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"按键学习"];
            });
            dispatch_async(networkQueue, ^{
                NSString *data = @"";
                _data = data;
                while ([_data  isEqual: @""]) {
                    _data = [self codesetmac:mac];
                    NSLog(@"%@",_data);
                }
            });
        }
}

- (NSString *)codesetmac:(NSString *)mac{
    NSString *data;
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:133 command:@"rm2_code" mac:mac];
    if (sdktool.code == 0) {
        data = sdktool.data;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }else{
        //NSLog(@"check data filed");
        data = @"";
    }
    return data;
}

- (void)sendsetmac:(NSString *)mac data:(NSString *)data{
    dispatch_async(networkQueue, ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:134] forKey:@"api_id"];
        [dic setObject:@"rm2_send" forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        [dic setObject:data forKey:@"data"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [_network requestDispatch:requestData];
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0) {
            NSLog(@"send data success");
        }
    });
}
@end
