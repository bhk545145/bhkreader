//
//  BLDeviceInfo.h
//  BroadLinkSDKDemo
//
//  Created by yang on 3/31/14.
//  Copyright (c) 2014 BroadLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A1listInfo.h"

@interface BLDeviceInfo : NSObject

@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int lock;
@property (nonatomic, assign) int password;
@property (nonatomic, assign) int terminal_id;
@property (nonatomic, assign) int sub_device;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, assign) int *spstate;
@property (nonatomic, assign) float rmtemperature;
@property (nonatomic, strong) A1listInfo *a1listInfo;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)DeviceinfoWithDict:(NSDictionary *)dict;
@end
