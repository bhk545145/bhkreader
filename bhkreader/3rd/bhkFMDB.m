//
//  bhkFMDB.m
//  bhkreader
//
//  Created by baihk on 15/12/8.
//  Copyright (c) 2015年 bai. All rights reserved.
//

#import "bhkFMDB.h"
#import "FMDB.h"
#import "BLDeviceInfo.h"

@interface bhkFMDB ()
{
    FMDatabase *db;
}

@end

@implementation bhkFMDB

-(id)init{
    self = [super init];
    if (self) {
        //1.获得数据库文件的路径
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"Deviceinfo.sqlite"];
        //2.获得数据库
        db = [FMDatabase databaseWithPath:fileName];
        //3.打开数据库
        if ([db open]) {
            //4.创表
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS to_configure (id integer PRIMARY KEY AUTOINCREMENT, wifi text NOT NULL, password text NOT NULL);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS device_info (mac text, type text,name varchar(64), lock integer, password text, terminal_id integer, sub_device integer,key text);"];
            [db close];
        }
    }
    return self;
}


- (NSString *)getwifi:(NSString *)wifi{
    NSString *password = @"";
    if ([db open]) {
        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM to_configure where wifi = ?;",wifi];
        // 2.遍历结果
        while ([resultSet next]) {
            wifi = [resultSet stringForColumn:@"wifi"];
            password = [resultSet stringForColumn:@"password"];
        }
        [db close];
    }
    return password;
}
//新增wifi,password
- (void)insertOrUpdatewifi:(NSString *)wifi password:(NSString *)password{
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM to_configure where wifi = ?;",wifi];
        if ([resultSet next] == 0) {
            [db executeUpdate:@"INSERT INTO to_configure (wifi, password) VALUES (?, ?);", wifi, password];
        }else{
            [db executeUpdate:@"UPDATE to_configure SET password = ? WHERE wifi = ?;",password,wifi];
        }
        
        [db close];
    }
}
//新增设备信息
- (void)insertOrUpdateinfo:(BLDeviceInfo *)info{
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM device_info where mac = ?;",info.mac];
        NSLog(@"SELECT%d",[resultSet next]);
        if ([resultSet next]) {
            BOOL result = [db executeUpdate:@"UPDATE device_info SET type = ?, name = ?, lock = ?, password = ?, terminal_id = ?, sub_device = ?, key = ? WHERE mac = ?;",info.type, info.name, [NSNumber numberWithLong:info.lock], [NSNumber numberWithLong:info.password], [NSNumber numberWithLong:info.terminal_id], [NSNumber numberWithLong:info.sub_device], info.key, info.mac];
            NSLog(@"UPDATE%d",result);
        }else{
            BOOL result = [db executeUpdate:@"INSERT INTO device_info (mac, type , name, lock, password, terminal_id, sub_device, key) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",info.mac, info.type, info.name, [NSNumber numberWithLong:info.lock], [NSNumber numberWithLong:info.password], [NSNumber numberWithLong:info.terminal_id], [NSNumber numberWithLong:info.sub_device], info.key];
            NSLog(@"INSERT%d",result);
        }

        [db close];
    }
}
//删除设备
- (void)deleteWithinfo:(BLDeviceInfo *)info{
    if ([db open]) {
        BOOL result = [db executeUpdate:@"DELETE FROM device_info WHERE mac = ?;",info.mac];
        NSLog(@"DELETE%d",result);
    }
}
//获取数据库设备信息
- (NSArray *)getInfoWhithMac{
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM device_info;"];
        while([resultSet next]){
            NSString *mac = [resultSet stringForColumn:@"mac"];
            NSString *type = [resultSet stringForColumn:@"type"];
            NSString *name = [resultSet stringForColumn:@"name"];
            int lock = [resultSet intForColumn:@"lock"];
            uint32_t password = [resultSet intForColumn:@"password"];
            uint32_t terminal_id = [resultSet intForColumn:@"terminal_id"];
            int sub_device = [resultSet intForColumn:@"sub_device"];
            NSString *key = [resultSet stringForColumn:@"key"];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:mac forKey:@"mac"];
            [dict setObject:type forKey:@"type"];
            [dict setObject:name forKey:@"name"];
            [dict setObject:[NSNumber numberWithInt:lock] forKey:@"lock"];
            [dict setObject:[NSNumber numberWithInt:password] forKey:@"password"];
            [dict setObject:[NSNumber numberWithInt:terminal_id] forKey:@"terminal_id"];
            [dict setObject:[NSNumber numberWithInt:sub_device] forKey:@"sub_device"];
            [dict setObject:key forKey:@"key"];
            [infoArray addObject:dict];
        }
    }
    [db close];
    return infoArray;
}
@end
