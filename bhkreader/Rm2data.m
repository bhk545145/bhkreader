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

- (void)rmplussIRstudysetmac:(NSString *)mac{
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:137 command:@"rmpro_freq_scan_study" mac:mac];
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

- (void)rmplussRFstudysetmac:(NSString *)mac{
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:135 command:@"rmpro_freq_scan" mac:mac];
    if (sdktool.code == 0) {
        [self rmplussRFstatussetmac:mac];
    }
}

- (void)rmplussRFstatussetmac:(NSString *)mac{
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:136 command:@"rmpro_freq_scan_status" mac:mac];
    int time = 300;
    while (sdktool.code == 0) {
        sdktool = [BLSDKTool responseDatatoapiid:136 command:@"rmpro_freq_scan_status" mac:mac];
        time = time - 1;
        if (time < 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"扫频失败"];
            });
            [self rmplusscancelstudysetmac:mac];
            break;
        }
        if (sdktool.code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"确认频点后学习"];
            });
            [self rmplussIRstudysetmac:mac];
        }else if (sdktool.code == 4){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"扫频失败"];
            });
            [self rmplusscancelstudysetmac:mac];
        }
    }
    
}

- (void)rmplusscancelstudysetmac:(NSString *)mac{
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:138 command:@"rmpro_cancel_study" mac:mac];
    if (sdktool.code == 0) {
        
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
    BLSDKTool *sdktool = [BLSDKTool responseDatatoapiid:134 command:@"rm2_send" mac:mac data:@"2600cc0096901126112711271027110b1127110b11270f0d1127100c10271127110b110b110b1127110b110b110b110b110b1127110b1125130b100c100c110b110b1126110b110c0f28110b1028110b110b110b102810281027102811271126110b1127110b100003e996901126102810281027110b1127100c1028110b1028100c10271127110b100c110b1127110b110b110b110b110b1127110b1127100c100c100c110b110b1127100c100c1126110b1127110b110b110b112711271126112711271126110b1127110b11000d05000000000000000000000000"];
        if (sdktool.code == 0) {
            //NSLog(@"send data success");
        }
}
@end
