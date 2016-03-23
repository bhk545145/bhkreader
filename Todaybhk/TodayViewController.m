//
//  TodayViewController.m
//  Todaybhk
//
//  Created by baihk on 16/3/23.
//  Copyright (c) 2016年 bai. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface TodayViewController () <NCWidgetProviding>{
    UILabel *_Wifi;
}

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(0, 200);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    _Wifi = [[UILabel alloc]init];
    [self.view addSubview:_Wifi];
    _Wifi.frame = CGRectMake(0, 0, 80, 80);
    _Wifi.text = [NSString stringWithFormat:@"当前连接的WiFi：%@",[self getCurrentWiFiSSID]];

    completionHandler(NCUpdateResultNewData);
}

- (NSString *)getCurrentWiFiSSID
{
    CFArrayRef ifs = CNCopySupportedInterfaces();       //得到支持的网络接口 eg. "en0", "en1"
    
    if (ifs == NULL)
        return nil;
    
    CFDictionaryRef info = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(ifs, 0));
    
    CFRelease(ifs);
    
    if (info == NULL)
        return nil;
    
    NSDictionary *dic = (__bridge_transfer NSDictionary *)info;
    
    // If ssid is not exist.
    if ([dic isEqual:nil])
        return nil;
    
    NSString *ssid = [dic objectForKey:@"SSID"];
    
    return ssid;
}
@end
