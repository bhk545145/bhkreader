//
//  ViewController.m
//  bhkreader
//
//  Created by bai on 15/11/3.
//  Copyright (c) 2015年 bai. All rights reserved.
//

#import "ViewController.h"
#import "BLNetwork.h"
#import "BLDeviceInfo.h"
#import "JSONKit.h"
#import "getCurrentWiFiSSID.h"
#import "bhkFMDB.h"

@interface ViewController (){
    dispatch_queue_t networkQueue;
    bhkFMDB *bhkfmdb;
}
@property (nonatomic,retain) UIButton *wifibtn;
@property (nonatomic,retain) UITextField *wififield;
@property (nonatomic,retain) UITextField *passwordfield;
@property (nonatomic,retain) UIButton *configurebtn;
@property (nonatomic,strong) BLNetwork *network;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    _network = [[BLNetwork alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawRect];
    bhkfmdb = [[bhkFMDB alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawRect {
    _wifibtn = [[UIButton alloc] init];
    _wifibtn.titleLabel.font = [UIFont systemFontOfSize: 20];
    _wifibtn.frame = CGRectMake(40, 200, 100, 60);
    [_wifibtn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [_wifibtn setTitle:@"获取WiFi" forState:UIControlStateNormal];
    [_wifibtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_wifibtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    _configurebtn = [[UIButton alloc] init];
    _configurebtn.titleLabel.font = [UIFont systemFontOfSize: 20];
    _configurebtn.frame = CGRectMake(140, 200, 100, 60);
    [_configurebtn addTarget:self action:@selector(startConfig:) forControlEvents:UIControlEventTouchUpInside];
    [_configurebtn setTitle:@"一键配置" forState:UIControlStateNormal];
    [_configurebtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_configurebtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    _wififield = [[UITextField alloc] init];
    _wififield.frame = CGRectMake(50, 100, 180, 30);
    _wififield.backgroundColor = [UIColor grayColor];
    _wififield.font = [UIFont systemFontOfSize:20];
    
    _passwordfield = [[UITextField alloc] init];
    _passwordfield.frame = CGRectMake(50, 150, 180, 30);
    _passwordfield.backgroundColor = [UIColor grayColor];
    _passwordfield.font = [UIFont systemFontOfSize:20];

    [self.view addSubview:_wifibtn];
    [self.view addSubview:_configurebtn];
    [self.view addSubview:_wififield];
    [self.view addSubview:_passwordfield];

}

- (void)btnClick1:(UIButton *)sender{
    getCurrentWiFiSSID *ssid = [[getCurrentWiFiSSID alloc]init];
    _wififield.text = [ssid getCurrentWiFiSSID];
    _passwordfield.text = [bhkfmdb getwifi:_wififield.text];
}

- (void)startConfig:(UIButton *)sender{
    NSString *wifi = _wififield.text;
    NSString *password = _passwordfield.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:10000] forKey:@"api_id"];
        [dic setObject:@"easyconfig" forKey:@"command"];
        [dic setObject:wifi forKey:@"ssid"];
        [dic setObject:password forKey:@"password"];
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        
        NSData *responseData = [_network requestDispatch:requestData];
        NSLog(@"%@", [responseData objectFromJSONData]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_configurebtn setSelected:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        });
    });
    [bhkfmdb insertOrUpdatewifi:wifi password:password];
}
@end
