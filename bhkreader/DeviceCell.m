//
//  DeviceCell.m
//  bhkreader
//
//  Created by bai on 15/11/23.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "DeviceCell.h"
#import "BLDeviceInfo.h"
#import "Spbtn.h"

#define kCellBorder 10
#define kimageW 40
#define kimageH 40
@interface DeviceCell(){
    UIImageView *_deviceimage;
    UILabel *_mac;
    UILabel *_type;
    UILabel *_name;
    UISwitch *_lock;
    UILabel *_password;
    UILabel *_terminal_id;
    UILabel *_subdevice;
    UILabel *_key;
    UILabel *_ip;
    UILabel *_status;
    Spbtn *_spbtn;
}

@end

@implementation DeviceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _deviceimage = [[UIImageView alloc]init];
        [self.contentView addSubview:_deviceimage];
        _mac = [[UILabel alloc]init];
        [self.contentView addSubview:_mac];
        _type = [[UILabel alloc]init];
        [self.contentView addSubview:_type];
        _name = [[UILabel alloc]init];
        [self.contentView addSubview:_name];
        _lock = [[UISwitch alloc]init];
        _lock.enabled = NO;
        [self.contentView addSubview:_lock];
        _password = [[UILabel alloc]init];
        [self.contentView addSubview:_password];
        _ip = [[UILabel alloc]init];
        [self.contentView addSubview:_ip];
        _status = [[UILabel alloc]init];
        [self.contentView addSubview:_status];
        _spbtn = [[Spbtn alloc]init];
        [self.contentView addSubview:_spbtn];
    }
    return self;
}

-(void)setBLDeviceinfo:(BLDeviceInfo *)BLDeviceinfo{
    _BLDeviceinfo = BLDeviceinfo;
//设置数据
    if ([BLDeviceinfo.type isEqualToString:@"10016"]) {
        _deviceimage.image = [UIImage imageNamed:@"SPmin.jpg"];
        _type.text =@"SPmini";
    }else if([BLDeviceinfo.type isEqualToString:@"10024"]){
        _deviceimage.image = [UIImage imageNamed:@"SPmin.jpg"];
        _type.text = BLDeviceinfo.type;
        _type.textColor = [UIColor redColor];
    }else if([BLDeviceinfo.type isEqualToString:@"10001"]){
        _deviceimage.image = [UIImage imageNamed:@"SP2.jpg"];
        _type.text =@"SP2";
    }else if ([BLDeviceinfo.type isEqualToString:@"10002"]){
        _deviceimage.image = [UIImage imageNamed:@"RMpro.jpg"];
        _type.text =@"RM";
    }else if ([BLDeviceinfo.type isEqualToString:@"10004"]){
        _deviceimage.image = [UIImage imageNamed:@"A1.jpg"];
        _type.text =@"A1";
    }else if ([BLDeviceinfo.type isEqualToString:@"10015"]){
        _deviceimage.image = [UIImage imageNamed:@"MS1.png"];
        _type.text =@"MS1";
    }else if ([BLDeviceinfo.type isEqualToString:@"10018"]){
        _deviceimage.image = [UIImage imageNamed:@"S1.jpg"];
        _type.text =@"S1";
    }else{
        _deviceimage.image = [UIImage imageNamed:@"1024.jpg"];
        _type.text = BLDeviceinfo.type;
        _type.textColor = [UIColor redColor];
    }
    
    _mac.text = BLDeviceinfo.mac;
    //_type.text = BLDeviceinfo.type;
    _name.text = BLDeviceinfo.name;
    _lock.on = BLDeviceinfo.lock;
    _status.text = BLDeviceinfo.status;
    _ip.text = BLDeviceinfo.ip;
    [_spbtn setTitle:(BLDeviceinfo.spstate) ? @"ON" : @"OFF" forState:UIControlStateNormal mac:BLDeviceinfo.mac];
//设置位置
    CGFloat deviceimageX = kCellBorder;
    CGFloat deviceimageY = kCellBorder;
    _deviceimage.frame = CGRectMake(deviceimageX, deviceimageY, kimageW ,kimageH);
    
    CGFloat nameX = deviceimageX + kimageW + 10;
    CGFloat nameY = deviceimageY;
    CGSize nameSize = [BLDeviceinfo.name sizeWithFont:_name.font];
    _name.frame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    CGFloat macX = nameX;
    CGFloat macY = nameY + 20;
    CGSize macSize = [BLDeviceinfo.mac sizeWithFont:_mac.font];
    _mac.frame = CGRectMake(macX, macY, macSize.width, macSize.height);
    
    CGFloat typeX = macX;
    CGFloat typeY = macY + 20;
    CGSize  typeSize = [_type.text sizeWithFont:_type.font];
    _type.frame = CGRectMake(typeX, typeY, typeSize.width, typeSize.height);
    
    CGFloat lockX = typeX;
    CGFloat lockY = typeY + 20;
    _lock.frame = CGRectMake(lockX, lockY, 0, 0);
    
    CGFloat statusX = lockX;
    CGFloat statusY = lockY + 30;
    CGSize  statusSize = [BLDeviceinfo.status sizeWithFont:_status.font];
    _status.frame = CGRectMake(statusX, statusY, statusSize.width, statusSize.height);
    
    CGFloat ipX = statusX;
    CGFloat ipY = statusY + 20;
    CGSize  ipSize = [BLDeviceinfo.ip sizeWithFont:_ip.font];
    _ip.frame = CGRectMake(ipX, ipY, ipSize.width, ipSize.height);
    
    if ([BLDeviceinfo.type isEqual: @"10016"] ||[BLDeviceinfo.type isEqual: @"10001"] || [BLDeviceinfo.type isEqualToString:@"10024"]) {
        CGFloat spbtnX = lockX + 200;
        CGFloat spbtnY = lockY - 40;
        _spbtn.frame = CGRectMake(spbtnX, spbtnY, 100, 100);
    }
    _cellHeight = CGRectGetMaxY(_ip.frame) + 5;
}



@end
