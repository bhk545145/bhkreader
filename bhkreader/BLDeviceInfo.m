//
//  BLDeviceInfo.m
//  BroadLinkSDKDemo
//
//  Created by yang on 3/31/14.
//  Copyright (c) 2014 BroadLink. All rights reserved.
//

#import "BLDeviceInfo.h"

@implementation BLDeviceInfo

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _mac = dict[@"mac"];
        _type = dict[@"type"];
        _name = dict[@"name"];
        _lock = [dict[@"lock"]intValue];
        _password = [dict[@"password"]unsignedIntValue];
        if ([dict[@"id"]unsignedIntValue] == 0) {
            _terminal_id = [dict[@"terminal_id"]intValue];
        }else{
            _terminal_id = [dict[@"id"]intValue];
        }
        
        _sub_device = [dict[@"subdevice"]intValue];
        _key = dict[@"key"];

    }
    return self;
}

+(id)DeviceinfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
