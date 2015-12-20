//
//  BLSDKTool.m
//  bhkreader
//
//  Created by baihk on 15/12/19.
//  Copyright (c) 2015年 bai. All rights reserved.
//

#import "BLSDKTool.h"
#import "BLNetwork.h"
#import "JSONKit.h"
@interface BLSDKTool (){
    dispatch_queue_t networkQueue;
}
@property (nonatomic,strong) BLNetwork *network;

@end
@implementation BLSDKTool

- (BLNetwork *)network{
    if (_network == nil) {
        _network = [[BLNetwork alloc] init];
    }
    return _network;
}


- (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac status:(int)status{
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:apiid] forKey:@"api_id"];
        [dic setObject:command forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        if (status == 2) {
            
        }else{
            [dic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
        }
        
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        _code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        if (status == 2){
            _status = [[[responseData objectFromJSONData] objectForKey:@"status"] intValue];
            _state =  [[responseData objectFromJSONData] objectForKey:@"status"];
            _locaIP = [[responseData objectFromJSONData] objectForKey:@"lan_ip"];
            _rmtemperature = [[[responseData objectFromJSONData] objectForKey:@"temperature"] floatValue];
            _a1temperature = [[[responseData objectFromJSONData] objectForKey:@"temperature"] floatValue];
            _humidity = [[[responseData objectFromJSONData] objectForKey:@"humidity"] floatValue];
            _light = [[[responseData objectFromJSONData] objectForKey:@"light"] intValue];
            _air = [[[responseData objectFromJSONData] objectForKey:@"air"] intValue];
            _noisy = [[[responseData objectFromJSONData] objectForKey:@"noisy"] intValue];
        }
        
        //NSLog(@"%@", [responseData objectFromJSONData]);
    }
    return  self;
}

+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac status:(int)status{
    return [[self alloc] responseDatatoapiid:apiid command:command mac:mac status:status];
}

+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac{
    return [[self alloc] responseDatatoapiid:apiid command:command mac:mac status:2];
}
@end