//
//  DeviceCell.h
//  bhkreader
//
//  Created by bai on 15/11/23.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLDeviceInfo;
@interface DeviceCell : UITableViewCell

@property (strong,nonatomic) BLDeviceInfo *BLDeviceinfo;
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end
