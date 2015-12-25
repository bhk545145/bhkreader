//
//  Spbtn.h
//  bhkreader
//
//  Created by bai on 15/11/27.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Spbtn : UIButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state mac:(NSString *)mac;
- (NSDictionary *)Sprefresh:(NSString *)mac;
@end
