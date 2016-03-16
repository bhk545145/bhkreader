//
//  Rm2btn.m
//  bhkreader
//
//  Created by bai on 16/1/6.
//  Copyright © 2016年 bai. All rights reserved.
//

#import "Rm2btn.h"
#import "BLNetwork.h"
#import "BLSDKTool.h"
#import "JSONKit.h"
#import "MBProgressHUD+MJ.h"
#import "bhkFMDB.h"
#import "BLDeviceInfo.h"
#import "Rm2data.h"

@interface Rm2btn ()
{
    dispatch_queue_t networkQueue;
    bhkFMDB *bhkfmdb;
    Rm2data *rm2data;
}
@property (nonatomic,strong) BLNetwork *network;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *image;


@end

@implementation Rm2btn

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _network = [[BLNetwork alloc] init];
        bhkfmdb = [[bhkFMDB alloc]init];
        rm2data = [[Rm2data alloc]init];
        networkQueue = dispatch_queue_create("BroadLinkDetailNetworkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setBackgroundImage:(NSString *)image forState:(UIControlState)state mac:(NSString *)mac{
    _mac = mac;
    _image = image;
    [super setBackgroundImage:[UIImage imageNamed:image] forState:state];
    if ([image isEqualToString:@"rm2btn"]) {
        [self setBackgroundImage:[UIImage imageNamed:image] forState:state];
    }else if([image isEqualToString:@"rm2sendbtn"]){
        [self setBackgroundImage:[UIImage imageNamed:image] forState:state];
    }else if([image isEqualToString:@"rmplusIRbtn"]){
        [self setBackgroundImage:[UIImage imageNamed:image] forState:state];
    }else if([image isEqualToString:@"rmplusRFbtn"]){
        [self setBackgroundImage:[UIImage imageNamed:image] forState:state];
    }
    [self addTarget:self action:@selector(rm2ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rm2ButtonClicked:(UIButton *)button{
    if ([_image  isEqual:@"rm2btn"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"按键学习"];
        });
        dispatch_async(networkQueue, ^{
            [rm2data studysetmac:_mac];
        });
    }else if ([_image  isEqual:@"rm2sendbtn"]){
        dispatch_async(networkQueue, ^{
            NSString *data = [rm2data codesetmac:_mac];
            [rm2data sendsetmac:_mac data:data];
        });
    }else if ([_image  isEqual:@"rmplusIRbtn"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"按键学习"];
        });
        dispatch_async(networkQueue, ^{
            [rm2data rmplussIRstudysetmac:_mac];
        });
    }else if ([_image  isEqual:@"rmplusRFbtn"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"扫频学习"];
        });
        dispatch_async(networkQueue, ^{
            [rm2data rmplussRFstudysetmac: _mac];
        });
    }
}

@end
