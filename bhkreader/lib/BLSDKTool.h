//
//  BLSDKTool.h
//  bhkreader
//
//  Created by baihk on 15/12/19.
//  Copyright (c) 2015年 bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLSDKTool : NSObject
@property (nonatomic, assign) int code;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *locaIP;
@property (nonatomic, assign) float rmtemperature;
@property (nonatomic, assign) float a1temperature;
@property (nonatomic, assign) float humidity;
@property (nonatomic, assign) int light;
@property (nonatomic, assign) int air;
@property (nonatomic, assign) int noisy;




- (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac status:(int)status;
+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac status:(int)status;
+ (id)responseDatatoapiid:(int)apiid command:(NSString *)command mac:(NSString *)mac;
@end