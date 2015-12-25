//
//  Detailbtn.m
//  bhkreader
//
//  Created by bai on 15/12/25.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "Detailbtn.h"
#import "BLNetwork.h"
#import "BLSDKTool.h"
#import "JSONKit.h"
#import "MBProgressHUD+MJ.h"
@interface Detailbtn ()
{
    dispatch_queue_t networkQueue;
}
@property (nonatomic,strong) BLNetwork *network;

@end
@implementation Detailbtn

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _network = [[BLNetwork alloc] init];
        networkQueue = dispatch_queue_create("BroadLinkDetailNetworkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setmac:(NSString *)mac name:(NSString *)name lock:(int)lock{
    dispatch_async(networkQueue, ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:13] forKey:@"api_id"];
        [dic setObject:@"device_update" forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        [dic setObject:name forKey:@"name"];
        [dic setObject:[NSNumber numberWithInt:lock] forKey:@"lock"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [_network requestDispatch:requestData];
        dispatch_async(dispatch_get_main_queue(), ^{
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0) {
            [MBProgressHUD showSuccess:@"保存成功"];
        }
        });
    });
}

@end
