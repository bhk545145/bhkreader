//
//  SplistInfo.h
//  bhkreader
//
//  Created by bai on 15/12/25.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SplistInfo : NSObject

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int lock;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)DeviceinfoWithDict:(NSDictionary *)dict;
@end
