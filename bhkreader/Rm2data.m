//
//  Rm2data.m
//  bhkreader
//
//  Created by baihk on 16/2/19.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "Rm2data.h"
#import "JSONKit.h"
#import "BLNetwork.h"
#import "BLSDKTool.h"
#import "MBProgressHUD+MJ.h"

@interface Rm2data()
@property (nonatomic,strong) BLNetwork *network;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *image;


@end

@implementation Rm2data

- (BLNetwork *)network{
    if (_network == nil) {
        _network = [[BLNetwork alloc] init];
    }
    return _network;
}

- (void)studysetmac:(NSString *)mac{
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:132 command:@"rm2_study" mac:mac];
    if (sdktool.code == 0) {
            NSString *data = @"";
            while ([data  isEqual: @""]) {
                data = [self codesetmac:mac];
            }
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = [self codesetmac:mac];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:pboard.string];
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
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:134] forKey:@"api_id"];
        [dic setObject:@"rm2_send" forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        [dic setObject:data forKey:@"data"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0) {
            NSLog(@"send data success");
        }
}
@end
