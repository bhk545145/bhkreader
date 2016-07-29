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
#import "bhkCommon.h"
#import "UIImage+MJ.h"
#import "SplistInfo.h"
#import "UIImageView+WebCache.h"

#define kCellBorder 10
#define kimageW 40
#define kimageH 40
@interface DeviceCell()<SpbtnDelegate>{
    UIImageView *_backimage;
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
    UILabel *_rmtemperature;
    //A1的数据
    UILabel *_a1temperature;
    UILabel *_humidity;
    UILabel *_light;
    UILabel *_air;
    UILabel *_noisy;
}

@end

@implementation DeviceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] init];
        self.backgroundColor = [UIColor clearColor];
        _backimage = [[UIImageView alloc]init];
        [self.contentView addSubview:_backimage];
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
        _spbtn.delegate = self;
        [self.contentView addSubview:_spbtn];
        _rmtemperature = [[UILabel alloc]init];
        [self.contentView addSubview:_rmtemperature];
        _a1temperature = [[UILabel alloc]init];
        [self.contentView addSubview:_a1temperature];
        _humidity = [[UILabel alloc]init];
        [self.contentView addSubview:_humidity];
        _light = [[UILabel alloc]init];
        [self.contentView addSubview:_light];
        _air = [[UILabel alloc]init];
        [self.contentView addSubview:_air];
        _noisy = [[UILabel alloc]init];
        [self.contentView addSubview:_noisy];
    }
    return self;
}

-(void)DoSometing:(UIButton *)button{
    if ([button.titleLabel.text isEqual: @"ON"]) {
        _type.textColor = [UIColor redColor];
    }else{
        _type.textColor = [UIColor blackColor];
    }
}
-(void)setBLDeviceinfo:(BLDeviceInfo *)BLDeviceinfo{
    _BLDeviceinfo = BLDeviceinfo;
//设置数据
    _backimage.userInteractionEnabled = YES;
    _backimage.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
    _backimage.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
    
    if ([BLDeviceinfo.type isEqualToString:SPmini]) {
        _deviceimage.image = [UIImage imageNamed:@"SPmin.jpg"];
        _type.text =@"SPmini";
        [_spbtn setTitle:(BLDeviceinfo.spstate) ? @"ON" : @"OFF" forState:UIControlStateNormal mac:BLDeviceinfo.mac];
    }else if([BLDeviceinfo.type isEqualToString:SPminiv2] || [BLDeviceinfo.type isEqualToString:SP3]){
        _deviceimage.image = [UIImage imageNamed:@"SPmin.jpg"];
        _type.text =@"SPminiv2";
        [_spbtn setTitle:(BLDeviceinfo.spstate) ? @"ON" : @"OFF" forState:UIControlStateNormal mac:BLDeviceinfo.mac];
    }else if([BLDeviceinfo.type isEqualToString:SP2]){
        _deviceimage.image = [UIImage imageNamed:@"SP2.jpg"];
        _type.text =@"SP2";
        [_spbtn setTitle:(BLDeviceinfo.spstate) ? @"ON" : @"OFF" forState:UIControlStateNormal mac:BLDeviceinfo.mac];
    }else if ([BLDeviceinfo.type isEqualToString:RM]){
        _deviceimage.image = [UIImage imageNamed:@"RMpro.jpg"];
        _type.text =@"RM";
        _rmtemperature.text =[NSString stringWithFormat:@"温度:%0.1f°",BLDeviceinfo.rmtemperature];
        _rmtemperature.textColor = [UIColor blackColor];
    }else if ([BLDeviceinfo.type isEqualToString:RMplus]){
        _deviceimage.image = [UIImage imageNamed:@"RMpro.jpg"];
        _type.text =@"RM+";
        _rmtemperature.text =[NSString stringWithFormat:@"温度:%0.1f°",BLDeviceinfo.rmtemperature];
        _rmtemperature.textColor = [UIColor blackColor];
    }else if ([BLDeviceinfo.type isEqualToString:RM3mini]){
        _deviceimage.image = [UIImage imageNamed:@"RMpro.jpg"];
        _type.text =@"RM3mini";
        _rmtemperature.textColor = [UIColor blackColor];
    }else if ([BLDeviceinfo.type isEqualToString:A1]){
        _deviceimage.image = [UIImage imageNamed:@"A1.jpg"];
        _type.text =@"A1";
        _a1temperature.text =[NSString stringWithFormat:@"温度:%@°",BLDeviceinfo.a1listInfo.temperature];
        _humidity.text =[NSString stringWithFormat:@"湿度:%@°",BLDeviceinfo.a1listInfo.humidity];
        int light = BLDeviceinfo.a1listInfo.light;
        int air = BLDeviceinfo.a1listInfo.air;
        int noisy = BLDeviceinfo.a1listInfo.noisy;
        _light.text =[NSString stringWithFormat:@"光照:%@",[self tolight:light]];
        _air.text =[NSString stringWithFormat:@"空气:%@",[self toair:air]];
        _noisy.text =[NSString stringWithFormat:@"噪声:%@",[self tonoisy:noisy]];
    }else if ([BLDeviceinfo.type isEqualToString:MS1]){
        _deviceimage.image = [UIImage imageNamed:@"MS1.png"];
        _type.text =@"MS1";
    }else if ([BLDeviceinfo.type isEqualToString:S1]){
        _deviceimage.image = [UIImage imageNamed:@"S1.jpg"];
        _type.text =@"S1";
    }else{
        _deviceimage.image = [UIImage imageNamed:@"1024.jpg"];
        _type.text = BLDeviceinfo.type;
        _type.textColor = [UIColor redColor];
    }
    
    _mac.text = BLDeviceinfo.mac;
    _name.text = BLDeviceinfo.name;
    _lock.on = BLDeviceinfo.lock;
    _status.text = BLDeviceinfo.status;
    _ip.text = BLDeviceinfo.ip;

//设置位置
    CGFloat deviceimageX = kCellBorder;
    CGFloat deviceimageY = kCellBorder;
    _deviceimage.frame = CGRectMake(deviceimageX, deviceimageY, kimageW ,kimageH);
    
    CGFloat nameX = deviceimageX + kimageW + 10;
    CGFloat nameY = deviceimageY;
    _name.frame = CGRectMake(nameX, nameY, 150, 21);
    
    CGFloat macX = nameX;
    CGFloat macY = nameY + 20;
    _mac.frame = CGRectMake(macX, macY, 150, 21);
    
    CGFloat typeX = macX;
    CGFloat typeY = macY + 20;
    _type.frame = CGRectMake(typeX, typeY, 150, 21);
    
    CGFloat lockX = typeX;
    CGFloat lockY = typeY + 20;
    _lock.frame = CGRectMake(lockX, lockY, 0, 0);
    
    CGFloat statusX = lockX;
    CGFloat statusY = lockY + 30;
    _status.frame = CGRectMake(statusX, statusY, 150, 21);
    
    CGFloat ipX = statusX;
    CGFloat ipY = statusY + 20;
    _ip.frame = CGRectMake(ipX, ipY, 150, 21);
    
    if ([BLDeviceinfo.type isEqual: SPmini] ||[BLDeviceinfo.type isEqual: SP2] ||[BLDeviceinfo.type isEqual: SPminiv2] ||[BLDeviceinfo.type isEqual: SP3]) {
        CGFloat spbtnX = lockX + 200;
        CGFloat spbtnY = lockY - 40;
        _spbtn.frame = CGRectMake(spbtnX, spbtnY, 100, 100);
    }
    
    if ([BLDeviceinfo.type isEqual:RM]) {
        CGFloat rmtemperatureX = lockX + 200;
        CGFloat rmtemperatureY = lockY;
        _rmtemperature.frame = CGRectMake(rmtemperatureX, rmtemperatureY, 150, 21);
    }
    
    if ([BLDeviceinfo.type isEqual:A1]) {
        CGFloat a1temperatureX = nameX + 200;
        CGFloat a1temperatureY = nameY + 10;
        _a1temperature.frame = CGRectMake(a1temperatureX, a1temperatureY, 150, 21);
        
        CGFloat humidityX = a1temperatureX;
        CGFloat humidityY = a1temperatureY + 20;
        _humidity.frame = CGRectMake(humidityX, humidityY, 150, 21);
        
        CGFloat lightX = humidityX;
        CGFloat lightY = humidityY + 20;
        _light.frame = CGRectMake(lightX, lightY, 150, 21);
        
        CGFloat airX = lightX;
        CGFloat airY = lightY + 20;
        _air.frame = CGRectMake(airX, airY, 150, 21);
        
        CGFloat noisyX = airX;
        CGFloat noisyY = airY + 20;
        _noisy.frame = CGRectMake(noisyX, noisyY, 150, 21);
    }
    
    _cellHeight = CGRectGetMaxY(_ip.frame) + 5;
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - 2 * IWStatusTableBorder;
    CGFloat backimageX = IWStatusTableBorder;
    CGFloat backimageY = IWStatusTableBorder;
    CGFloat backimageW = cellW;
    CGFloat backimageH = CGRectGetMaxY(_ip.frame);
    _backimage.frame = CGRectMake(backimageX, backimageY, backimageW, backimageH);
}

- (NSString *)tolight:(int)light{
    NSString *lightstr;
    if (light == 0) {
        lightstr = @"暗";
    }else if(light == 1){
        lightstr = @"昏暗";
    }else if(light == 2){
        lightstr = @"正常";
    }else if(light == 3){
        lightstr = @"亮";
    }else{
        lightstr = @" ";
    }
    return lightstr;
}

- (NSString *)toair:(int)air{
    NSString *airstr;
    if (air == 0) {
        airstr = @"优";
    }else if(air == 1){
        airstr = @"良";
    }else if(air == 2){
        airstr = @"正常";
    }else if(air == 3){
        airstr = @"差";
    }else{
        airstr = @" ";
    }
    return airstr;
}

- (NSString *)tonoisy:(int)noisy{
    NSString *noisystr;
    if (noisy == 0) {
        noisystr = @"寂静";
    }else if(noisy == 1){
        noisystr = @"正常";
    }else if(noisy == 2){
        noisystr = @"吵";
    }else{
        noisystr = @" ";
    }
    return noisystr;
}

@end
