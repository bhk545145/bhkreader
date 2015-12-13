//
//  bhkFMDB.h
//  bhkreader
//
//  Created by baihk on 15/12/8.
//  Copyright (c) 2015年 bai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDeviceInfo.h"

@interface bhkFMDB : NSObject

- (NSString *)getwifi:(NSString *)wifi;
- (void)insertOrUpdatewifi:(NSString *)wifi password:(NSString *)password;
- (void)insertOrUpdateinfo:(BLDeviceInfo *)info;
- (void)deleteWithinfo:(BLDeviceInfo *)info;
- (NSArray *)getInfoWhithMac;

@end
