//
//  SplistInfo.m
//  bhkreader
//
//  Created by bai on 15/12/25.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "SplistInfo.h"

@implementation SplistInfo
- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _status = [dict[@"status"]intValue];
        _name = dict[@"name"];
        _lock = [dict[@"lock"]intValue];
    }
    return self;
}

+ (id)DeviceinfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
