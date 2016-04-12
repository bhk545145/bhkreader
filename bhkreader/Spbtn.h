//
//  Spbtn.h
//  bhkreader
//
//  Created by bai on 15/11/27.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SpbtnDelegate <NSObject>
-(void)DoSometing:(UIButton *)button;
@end

@interface Spbtn : UIButton
@property(assign,nonatomic) id<SpbtnDelegate> delegate;
- (void)setTitle:(NSString *)title forState:(UIControlState)state mac:(NSString *)mac;
- (NSDictionary *)Sprefresh:(NSString *)mac apiid:(int)apiid;
@end
