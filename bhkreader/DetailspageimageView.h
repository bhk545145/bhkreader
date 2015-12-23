//
//  DetailspageimageView.h
//  bhkreader
//
//  Created by bai on 15/12/21.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLDeviceInfo;
@interface DetailspageimageView : UIImageView <UIGestureRecognizerDelegate>

@property (strong,nonatomic) BLDeviceInfo *BLDeviceinfo;
@end
