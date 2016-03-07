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
    _status.frame = CGRectMake(30, 200, 100, 30);
    _status.backgroundColor = [UIColor grayColor];
    
    _apiid.text = @"72";
    _command.text = @"sp2_control";
    _mac.text = @"b4:43:0d:11:c1:d0";
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
}

-(void)inputbtn:(UIButton *)sender{
    int apiid = [_apiid.text intValue];
    NSString *command = _command.text;
    NSString *mac = _mac.text;
    int status = [_status.text intValue];
    NSString *data = _status.text;
    BLSDKTool *blsdktool = [[BLSDKTool alloc]init];
    if ([_status.text isEqual:@""]) {
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac];
    }else if ([_status.text isEqual:@"0"] || [_status.text isEqual:@"1"]){
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac status:status];
    }else{
        //blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac data:data];
        blsdktool = [BLSDKTool responseDatatoapiid:apiid command:command mac:mac];
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
