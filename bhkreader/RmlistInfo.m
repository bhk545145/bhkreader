//
//  RmlistInfo.m
//  bhkreader
//
//  Created by bai on 16/1/13.
//  Copyright © 2016年 bai. All rights reserved.
//

#import "RmlistInfo.h"

@implementation RmlistInfo
- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _data = dict[@"data"];
        _dataid = [dict[@"dataid"]intValue];
    }
    return self;
}

+ (id)DeviceinfoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
