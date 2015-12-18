//
//  A1listInfo.h
//  bhkreader
//
//  Created by bai on 15/12/18.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A1listInfo : NSObject

@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, assign) int light;
@property (nonatomic, assign) int air;
@property (nonatomic, assign) int noisy;


- (id)initWithDict:(NSDictionary *)dict;
+ (id)DeviceinfoWithDict:(NSDictionary *)dict;
@end
