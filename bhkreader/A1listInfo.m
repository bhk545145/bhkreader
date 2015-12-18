//
//  A1listInfo.m
//  bhkreader
//
//  Created by bai on 15/12/18.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "A1listInfo.h"

@implementation A1listInfo

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _temperature = dict[@"temperature"];
        _humidity = dict[@"humidity"];
        _light = [dict[@"light"]intValue];
        _air= [dict[@"air"]intValue];
        _noisy = [dict[@"noisy"]intValue];
    }
    return self;
}

+ (id)DeviceinfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
