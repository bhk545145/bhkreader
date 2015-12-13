//
//  BLNetwork.h
//  BLNetwork
//
//  Created by yzm157 on 15/1/6.
//  Copyright (c) 2015年 Broadlink Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLNetwork : NSObject

+ (BLNetwork *)sharedBLNetwork;

- (NSData *)requestDispatch:(NSData *)input;

- (NSString *)getServerTime:(int *)result;

@end
