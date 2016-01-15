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
#import "bhkCommon.h"

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
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS device_info (mac text PRIMARY KEY, type text,name text, lock integer, password integer, terminal_id integer, sub_device integer,key text);"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS rm_data (number integer PRIMARY KEY AUTOINCREMENT, mac text NOT NULL, data text);"];
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
        int number = [resultSet next];
        if (number) {
            [db executeUpdate:@"UPDATE device_info SET type = ?, name = ?, lock = ?, password = ?, terminal_id = ?, sub_device = ?, key = ? WHERE mac = ?;",info.type, info.name, [NSNumber numberWithLong:info.lock], [NSNumber numberWithLong:info.password], [NSNumber numberWithLong:info.terminal_id], [NSNumber numberWithLong:info.sub_device], info.key, info.mac];
        }else{
            [db executeUpdate:@"INSERT INTO device_info (mac, type , name, lock, password, terminal_id, sub_device, key) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",info.mac, info.type, info.name, [NSNumber numberWithLong:info.lock], [NSNumber numberWithLong:info.password], [NSNumber numberWithLong:info.terminal_id], [NSNumber numberWithLong:info.sub_device], info.key];
            if ([info.type isEqualToString:RM]) {
                [db executeUpdate:@"INSERT INTO rm_data (mac, data)VALUES(?, ?);",info.mac, @""];
            }
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
    [db close];
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
            int terminal_id = [resultSet intForColumn:@"terminal_id"];
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

//新增RMdata数据
- (void)RmdatainsertOrUpdateinfo:(NSString *)data mac:(NSString *)mac number:(int)number{
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM rm_data where mac = ?;",mac];
        int num = [resultSet next];
        if (num) {
            [db executeUpdate:@"UPDATE rm_data SET mac = ?, data = ? where number = ?;",mac, data, number];
        }else{
            [db executeUpdate:@"INSERT INTO rm_data (mac, data)VALUES(?, ?);",mac, data];
            [db close];
        }
    }
}

//查找dataid和data,是否存在数据
- (NSString *)Selectdataidtomac:(NSString *)mac number:(int)number{
    NSString *data = @"";
    if ([db open]) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM rm_data where mac = ? ;",mac];
        int num = [resultSet next];
            if (num) {
                data = [resultSet stringForColumn:@"data"];
            }
        }
    [db close];
    return data;
}
@end
