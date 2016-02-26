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
            int time = 300;
            while ([data  isEqual: @""]) {
                time = time - 1;
                if (time < 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                    });
                    break;
                }
                data = [self codesetmac:mac];
            }
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = [self codesetmac:mac];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"datalab" object:nil];
            //[MBProgressHUD showSuccess:pboard.string];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
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
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:134 command:@"rm2_send" mac:mac data:data];
        if (sdktool.code == 0) {
            //NSLog(@"send data success");
        }
}
@end
