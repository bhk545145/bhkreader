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

- (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac{
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:apiid] forKey:@"api_id"];
        [dic setObject:command forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        if (responseData.bytes != 0) {
            _code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
            _msg = [[responseData objectFromJSONData] objectForKey:@"msg"];
            _status = [[[responseData objectFromJSONData] objectForKey:@"status"] intValue];
            _name = [[responseData objectFromJSONData] objectForKey:@"name"];
            _lock = [[[responseData objectFromJSONData] objectForKey:@"lock"] intValue];
            _state =  [[responseData objectFromJSONData] objectForKey:@"status"];
            _locaIP = [[responseData objectFromJSONData] objectForKey:@"lan_ip"];
            _rmtemperature = [[[responseData objectFromJSONData] objectForKey:@"temperature"] floatValue];
            _a1temperature = [[[responseData objectFromJSONData] objectForKey:@"temperature"] floatValue];
            _humidity = [[[responseData objectFromJSONData] objectForKey:@"humidity"] floatValue];
            _light = [[[responseData objectFromJSONData] objectForKey:@"light"] intValue];
            _air = [[[responseData objectFromJSONData] objectForKey:@"air"] intValue];
            _noisy = [[[responseData objectFromJSONData] objectForKey:@"noisy"] intValue];
            _data = [[responseData objectFromJSONData] objectForKey:@"data"];
            _blsdkdata = [responseData objectFromJSONData];
        }
        
    }
    return  self;
}

- (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac status:(int)status{
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:apiid] forKey:@"api_id"];
        [dic setObject:command forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        [dic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
//        [dic setObject:[NSNumber numberWithInt:0] forKey:@"mask"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        _code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        _msg = [[responseData objectFromJSONData] objectForKey:@"msg"];
        _blsdkdata = [responseData objectFromJSONData];
    }
    return  self;
}

- (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac data:(NSString *)data{
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:apiid] forKey:@"api_id"];
        [dic setObject:command forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        [dic setObject:data forKey:@"data"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        _code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        _msg = [[responseData objectFromJSONData] objectForKey:@"msg"];
        _blsdkdata = [responseData objectFromJSONData];
    }
    return  self;
}

- (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac sdkparameter:(NSString *)sdkparameter parametertext:(NSString *)parametertext{
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:apiid] forKey:@"api_id"];
        [dic setObject:command forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        if([parametertext isEqual:@"ipaddr"]){
            [dic setObject:sdkparameter forKey:@"ipaddr"];
        }else if([parametertext isEqual:@"name"]){
            [dic setObject:sdkparameter forKey:@"name"];
        }else if([parametertext isEqual:@"lock"]){
            [dic setObject:sdkparameter forKey:@"lock"];
        }else{
        }
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        _code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        _msg = [[responseData objectFromJSONData] objectForKey:@"msg"];
        _blsdkdata = [responseData objectFromJSONData];
    }
    return self;
}

- (id)sptaskapid:(int)apiid command:(NSString *)command mac:(NSString *)mac{
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *timer_task = [[NSMutableDictionary alloc] init];
        NSMutableArray *timer_taskarray = [[NSMutableArray alloc] init];
        NSMutableDictionary *periodic_task = [[NSMutableDictionary alloc] init];
        NSMutableArray *periodic_taskarray = [[NSMutableArray alloc] init];
        [dic setObject:[NSNumber numberWithInt:apiid] forKey:@"api_id"];
        [dic setObject:command forKey:@"command"];
        [dic setObject:mac forKey:@"mac"];
        [dic setObject:@"智能插座" forKey:@"name"];
        [dic setObject:@0 forKey:@"lock"];
        
        [dic setObject:periodic_taskarray forKey:@"periodic_task"];
        [periodic_taskarray addObject:periodic_task];
        [periodic_task setObject:@1 forKey:@"enable"];
        [periodic_task setObject:@"14:58:03" forKey:@"on_time"];
        [periodic_task setObject:@"14:58:03" forKey:@"off_time"];
        [periodic_task setObject:@0 forKey:@"repeat"];
        [periodic_task setObject:@0 forKey:@"on_done"];
        [periodic_task setObject:@0 forKey:@"off_done"];
        [periodic_task setObject:@0xfffe forKey:@"mask"];
        
        [dic setObject:timer_taskarray forKey:@"timer_task"];
        [timer_taskarray addObject:timer_task];
        [timer_task setObject:@1 forKey:@"on_enable"];
        [timer_task setObject:@"2016-07-16 16:58:03" forKey:@"on_time"];
        [timer_task setObject:@1 forKey:@"off_enable"];
        [timer_task setObject:@"2016-07-16 16:58:03" forKey:@"off_time"];
        [timer_task setObject:@0 forKey:@"off_done"];
        
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [self.network requestDispatch:requestData];
        _code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        _msg = [[responseData objectFromJSONData] objectForKey:@"msg"];
        _blsdkdata = [responseData objectFromJSONData];
    }
    return self;

}

+ (id)sptaskapid:(int)apiid command:(NSString *)command mac:(NSString *)mac{
    return [[self alloc] sptaskapid:apiid command:command mac:mac];
}

+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac{
    return [[self alloc] responseDatatoapiid:apiid command:command mac:mac];
}

+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac status:(int)status{
    return [[self alloc] responseDatatoapiid:apiid command:command mac:mac status:status];
}

+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac data:(NSString *)data{
    return [[self alloc] responseDatatoapiid:apiid command:command mac:mac data:data];
}

+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac sdkparameter:(NSString *)sdkparameter parametertext:(NSString *)parametertext{
    return [[self alloc] responseDatatoapiid:apiid command:command mac:mac sdkparameter:sdkparameter parametertext:parametertext];
}
@end
