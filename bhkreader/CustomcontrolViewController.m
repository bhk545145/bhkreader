//
//  CustomcontrolViewController.m
//  bhkreader
//
//  Created by bai on 15/12/3.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "CustomcontrolViewController.h"
#import "BLNetwork.h"
#import "BLSDKTool.h"

@interface CustomcontrolViewController ()<UITextFieldDelegate>{
    dispatch_queue_t networkQueue;
}

@property(nonatomic,retain)UITextField *apiid;
@property(nonatomic,retain)UITextField *command;
@property(nonatomic,retain)UITextField *mac;
@property(nonatomic,retain)UIButton *input;
@property(nonatomic,retain)UITextView *blsdkdata;
@property(nonatomic,retain)UITextField *status;
@property(nonatomic,retain)UITextField *sdkparameter;
@property (nonatomic,strong) BLNetwork *network;

@end

@implementation CustomcontrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    _network = [[BLNetwork alloc]init];
    [self drawRect];
    
}

- (void)drawRect{
    _apiid = [[UITextField alloc]init];
    _apiid.frame = CGRectMake(30, 80, 200, 30);
    _apiid.backgroundColor = [UIColor grayColor];
    
    _command = [[UITextField alloc]init];
    _command.frame = CGRectMake(30, 120, 200, 30);
    _command.backgroundColor = [UIColor grayColor];
    
    _mac = [[UITextField alloc]init];
    _mac.frame = CGRectMake(30, 160, 200, 30);
    _mac.backgroundColor = [UIColor grayColor];
    
    _input = [[UIButton alloc]init];
    _input.titleLabel.font = [UIFont systemFontOfSize: 20];
    _input.frame = CGRectMake(180, 190, 50, 50);
    [_input setTitle:@"input" forState:UIControlStateNormal];
    [_input addTarget:self action:@selector(inputbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_input setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _blsdkdata = [[UITextView alloc]init];
    _blsdkdata.frame = CGRectMake(30, 240, 200, 300);
    _blsdkdata.backgroundColor = [UIColor grayColor];
    _blsdkdata.editable = NO;
    
    _status = [[UITextField alloc]init];
    _status.frame = CGRectMake(100, 200, 80, 30);
    _status.backgroundColor = [UIColor grayColor];
    
    _sdkparameter = [[UITextField alloc]init];
    _sdkparameter.frame = CGRectMake(30, 200, 65, 30);
    _sdkparameter.backgroundColor = [UIColor grayColor];
    
    _apiid.text = @"71";
    _command.text = @"sp2_refresh";
    _mac.text = @"b4:43:0d:95:be:ad";
    _apiid.delegate = self;
    _command.delegate = self;
    _mac.delegate = self;
    _status.delegate = self;
    
    [self.view addSubview:_apiid];
    [self.view addSubview:_command];
    [self.view addSubview:_mac];
    [self.view addSubview:_input];
    [self.view addSubview:_blsdkdata];
    [self.view addSubview:_status];
    [self.view addSubview:_sdkparameter];
}

-(void)inputbtn:(UIButton *)sender{
    int apiid = [_apiid.text intValue];
    NSString *command = _command.text;
    NSString *mac = _mac.text;
    int status = [_status.text intValue];
    NSString *parameter = _status.text;
    BLSDKTool *blsdktool = [[BLSDKTool alloc]init];
    if ([_sdkparameter.text isEqual:@""]) {
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac];
    }else if ([_sdkparameter.text isEqual:@"status"]){
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac status:status];
    }else if([_sdkparameter.text isEqual:@"data"]){
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac data:parameter];
    }else {
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac sdkparameter:parameter parametertext:_sdkparameter.text];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:blsdktool.blsdkdata options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str =[[ NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    _blsdkdata.text = str;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.apiid resignFirstResponder];
    [self.command resignFirstResponder];
    [self.mac resignFirstResponder];
    [self.status resignFirstResponder];
    return YES;
}
@end
