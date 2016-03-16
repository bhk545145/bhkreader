//
//  Rm2data.h
//  bhkreader
//
//  Created by baihk on 16/2/19.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rm2data : NSObject

- (void)studysetmac:(NSString *)mac;
- (NSString *)codesetmac:(NSString *)mac;
- (void)sendsetmac:(NSString *)mac data:(NSString *)data;
- (void)rmplussIRstudysetmac:(NSString *)mac;
- (void)rmplussRFstudysetmac:(NSString *)mac;


@end
