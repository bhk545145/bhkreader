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

- (NSString *)studysetmac:(NSString *)mac{
    NSString *data;
        BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:132 command:@"rm2_study" mac:mac];
            if (sdktool.code == 0) {
                [MBProgressHUD showMessage:@"按键学习"];
                 data = [self codesetmac:mac];
            }
    return data;
}

- (NSString *)codesetmac:(NSString *)mac{
    NSString *data;
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:133 command:@"rm2_code" mac:mac];
    if (sdktool.code == 0) {
        data = sdktool.data;
        [MBProgressHUD hideHUD];
    }else{
        NSLog(@"check data filed");
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
