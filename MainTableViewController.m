//
//  MainTableViewController.m
//  bhkreader
//
//  Created by bai on 15/11/3.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "MainTableViewController.h"
#import "SWRevealViewController.h"
#import "BLNetwork.h"
#import "BLDeviceInfo.h"
#import "A1listInfo.h"
#import "JSONKit.h"
#import "DeviceCell.h"
#import "getCurrentWiFiSSID.h"
#import "bhkFMDB.h"
#import "Spbtn.h"
#import "MJRefresh.h"


@interface MainTableViewController (){
    dispatch_queue_t networkQueue;
    dispatch_queue_t queue;
    int cellhight;
    bhkFMDB *bhkfmdb;
    Spbtn *_Spbtn;
}

@property (nonatomic, strong) NSMutableArray *deviceArray;
@property (nonatomic,strong) BLNetwork *network;
@property (nonatomic,strong) NSTimer *timer;



@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Init network queue.*/
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /*Init network library*/
    _network = [[BLNetwork alloc] init];
    _deviceArray = [[NSMutableArray alloc] init];
    bhkfmdb = [[bhkFMDB alloc]init];
    _Spbtn = [[Spbtn alloc]init];
    dispatch_async(queue, ^{
        //定时刷新
        [self startTimer];
    });
    
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf listRefresh];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    _siderbarBtn.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}



- (void)startTimer{
    //每1秒刷新一次
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshDeviceList) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop]run];
}
//页面滚动的时候销毁定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dispatch_async(queue, ^{
        [self.timer invalidate];
        self.timer = nil;
    });
}
//页面停止滚动时创建定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    dispatch_async(queue, ^{
        [self startTimer];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    //网络初始化
    [self networkInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deviceArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLDeviceInfo *info = _deviceArray[indexPath.row];
    NSString *SimleTableIdentifier = @"";
    if ([info.type isEqualToString:@"10016"] || [info.type isEqualToString:@"10001"]){
        SimleTableIdentifier = [NSString stringWithFormat:@"CellSP"];
    }else if([info.type isEqualToString:@"10024"]){
        SimleTableIdentifier = [NSString stringWithFormat:@"CellSP30"];
    }else if([info.type isEqualToString:@"10002"]){
        SimleTableIdentifier = [NSString stringWithFormat:@"CellRM"];
    }else if([info.type isEqualToString:@"10004"]){
        SimleTableIdentifier = [NSString stringWithFormat:@"CellA1"];
    }else if ([info.type isEqualToString:@"10018"]){
        SimleTableIdentifier = [NSString stringWithFormat:@"CellS1"];
    }else if([info.type isEqualToString:@"10015"]){
        SimleTableIdentifier = [NSString stringWithFormat:@"CellMS1"];
    }else{
        SimleTableIdentifier = [NSString stringWithFormat:@"Cell"];
    }
               
    
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:SimleTableIdentifier];
    if(cell == nil){
        cell = [[DeviceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimleTableIdentifier];
    }
    //status设备状态
    info.status = [self statetomac:info.mac];
    //ip地址
    info.ip = [self iptomac:info.mac];
    //spstate开关状态
    if ([info.type isEqualToString:@"10016"] || [info.type isEqualToString:@"10001"] || [info.type isEqualToString:@"10024"]){
        info.spstate = [_Spbtn Sprefresh:info.mac];
    }
    //rmtemperature RM温度
    if ([info.type isEqualToString:@"10002"] ) {
        info.rmtemperature = [self Rm2refresh:info.mac];
    }
    //a1temperature A1温度
    if ([info.type isEqualToString:@"10004"] ) {
        info.a1listInfo = [A1listInfo DeviceinfoWithDict:[self A1refresh:info.mac]];
    }
    cell.BLDeviceinfo = info;
    cellhight = cell.cellHeight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellhight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BLDeviceInfo *info = [_deviceArray objectAtIndex:indexPath.row];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSNumber numberWithInt:14] forKey:@"api_id"];
            [dic setObject:@"device_delete" forKey:@"command"];
            [dic setObject:info.mac forKey:@"mac"];
            NSError *error;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        dispatch_async(networkQueue, ^{
            NSData *responseData = [_network requestDispatch:requestData];
            //NSLog(@"%@", [responseData objectFromJSONData]);
            if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_deviceArray removeObjectAtIndex:indexPath.row];
                    [bhkfmdb deleteWithinfo:info];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                });
            }
        });
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    }
}



- (void)refreshDeviceList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self getCurrentWiFiSSID];
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)deviceAdd:(BLDeviceInfo *)info
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:12] forKey:@"api_id"];
    [dic setObject:@"device_add" forKey:@"command"];
    [dic setObject:info.mac forKey:@"mac"];
    [dic setObject:info.type forKey:@"type"];
    [dic setObject:info.name forKey:@"name"];
    [dic setObject:[NSNumber numberWithInt:info.lock] forKey:@"lock"];
    [dic setObject:[NSNumber numberWithUnsignedInt:info.password] forKey:@"password"];
    [dic setObject:[NSNumber numberWithUnsignedInt:info.terminal_id] forKey:@"id"];
    [dic setObject:[NSNumber numberWithInt:info.sub_device] forKey:@"subdevice"];
    [dic setObject:info.key forKey:@"key"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    dispatch_async(networkQueue, ^{
        NSData *responseData = [_network requestDispatch:requestData];
        
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
        {
            //NSLog(@"Add %@ success!", info.mac);
            
        }
        else
        {
            NSLog(@"Add %@ failed!%d", info.mac,[[[responseData objectFromJSONData] objectForKey:@"code"] intValue]);
            //TODO:
        }
    });
    
}

- (void)listRefresh
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:11] forKey:@"api_id"];
    [dic setObject:@"probe_list" forKey:@"command"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    dispatch_async(networkQueue, ^{
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_deviceArray];
        NSData *responseData = [_network requestDispatch:requestData];
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
        {
            int i;
            //NSLog(@"%@",[[responseData objectFromJSONData] objectForKey:@"list"]);
            NSArray *list = [[responseData objectFromJSONData] objectForKey:@"list"];
            for (NSMutableDictionary *dict in list)
            {
                BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
                info = [info initWithDict:dict];
                for (i=0; i<array.count; i++)
                {
                    BLDeviceInfo *tmp = [array objectAtIndex:i];
                    if ([tmp.mac isEqualToString:info.mac])
                    {
                        [array replaceObjectAtIndex:i withObject:info];
                        break;
                    }
                }
                
                if (i >= array.count && ![info.type isEqualToString:@"Unknown"])
                {
                    [array addObject:info];
                }
                [self deviceAdd:info];
                if (![info.type isEqualToString:@"10015"]) {
                    [bhkfmdb insertOrUpdateinfo:info];
                }
            }
            [_deviceArray removeAllObjects];
            [_deviceArray addObjectsFromArray:array];
            [self refreshDeviceList];

        }
    });
}


- (void)networkInit
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"api_id"];
    [dic setObject:@"network_init" forKey:@"command"];
    [dic setObject:@"7mvxZWDF7sck1YTPC9N8KajJu4Ut5ozUaImQgoOA6o/V1YVmYbc0hmXxsE8je7AjrSaRvCRzgJvWCDQEN/lI2hBDnHxLJlkCizwFUF7y+CFkGQ7nNo0=" forKey:@"license"];
    [dic setObject:@"gmAYRx925om219EQk0AQo4qooH3UgHYvkErGG+WPBki0Ic7s4LIEhPLn8dDcbYtJUSD+wi54ycsjciC1bOlFGi/WoY0VoOVSJlm4rAHnFzBwK+Xhbazbny1NM3+58+58" forKey:@"type_license"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    dispatch_async(networkQueue, ^{
    NSData *responseData = [_network requestDispatch:requestData];
    //NSLog(@"线程%d",[[[responseData objectFromJSONData] objectForKey:@"code"]intValue]);
    if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getFMDBDeviceinfo];
            [self listRefresh];
        });
    }
    else
    {
        NSLog(@"Init failed!");
    }
    });
}
//查询数据库的设备信息
- (void)getFMDBDeviceinfo{
    dispatch_async(networkQueue, ^{
        NSMutableArray *array = [[NSMutableArray alloc]init];
        if ([[bhkfmdb getInfoWhithMac]count] == 0) {
            NSLog(@"nil");
        }else{
            NSMutableArray *list = [[NSMutableArray alloc]initWithArray:[bhkfmdb getInfoWhithMac]];
            for (NSMutableDictionary *dict in list)
            {
                BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
                info = [info initWithDict:dict];
                [array addObject:info];
                [self deviceAdd:info];
            }
        }
        [_deviceArray addObjectsFromArray:array];
    });
}

- (IBAction)Refresh:(id)sender {

}

-(void)getCurrentWiFiSSID{
    getCurrentWiFiSSID *ssid = [[getCurrentWiFiSSID alloc]init];
    self.navigationItem.title = [ssid getCurrentWiFiSSID];
}

-(id)statetomac:(NSString *)mac{
    NSString *status = @"";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:16] forKey:@"api_id"];
    [dic setObject:@"device_state" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData = [_network requestDispatch:requestData];
        //NSLog(@"%@",[[responseData objectFromJSONData] objectForKey:@"status"]);
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
        {
            status = [[responseData objectFromJSONData] objectForKey:@"status"];
        }
    return status;
}

-(id)iptomac:(NSString *)mac{
    NSString *locaIP = @"";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:15] forKey:@"api_id"];
    [dic setObject:@"device_lan_ip" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSData *responseData  = [_network requestDispatch:requestData];
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
        {
            locaIP = [[responseData objectFromJSONData] objectForKey:@"lan_ip"];
        }
return locaIP;
}

- (float)Rm2refresh:(NSString *)mac{
    float rmtemperature = 0.0f;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:131] forKey:@"api_id"];
    [dic setObject:@"rm2_refresh" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    NSData *responseData = [_network requestDispatch:requestData];
    //NSLog(@"%@", [responseData objectFromJSONData]);
    if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
    {
        rmtemperature = [[[responseData objectFromJSONData] objectForKey:@"temperature"] floatValue];
    }
    return rmtemperature;
}

- (NSDictionary *)A1refresh:(NSString *)mac{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *a1list = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:161] forKey:@"api_id"];
    [dic setObject:@"a1_refresh" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    NSData *responseData = [_network requestDispatch:requestData];
    //NSLog(@"%@", [responseData objectFromJSONData]);
    if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
    {
        float a1temperature = [[[responseData objectFromJSONData] objectForKey:@"temperature"] floatValue];
        float humidity = [[[responseData objectFromJSONData] objectForKey:@"humidity"] floatValue];
        int light = [[[responseData objectFromJSONData] objectForKey:@"light"] intValue];
        int air = [[[responseData objectFromJSONData] objectForKey:@"air"] intValue];
        int noisy = [[[responseData objectFromJSONData] objectForKey:@"noisy"] intValue];
        [a1list setObject:[NSString stringWithFormat:@"%0.1f",a1temperature] forKey:@"temperature"];
        [a1list setObject:[NSString stringWithFormat:@"%0.1f",humidity] forKey:@"humidity"];
        [a1list setObject:[NSString stringWithFormat:@"%d",light] forKey:@"light"];
        [a1list setObject:[NSString stringWithFormat:@"%d",air] forKey:@"air"];
        [a1list setObject:[NSString stringWithFormat:@"%d",noisy] forKey:@"noisy"];
    }
    return a1list;
}

@end
