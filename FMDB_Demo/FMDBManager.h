//
//  FMDBManager.h
//  FMDB_Demo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "TestModel.h"
#define kUserTel @"10086"
@interface FMDBManager : NSObject
@property (nonatomic, strong) FMDatabase *dataBase;

+ (FMDBManager *)shareManager;
-(void)createFMDBTable;
-(void)insertDataByModel:(id)model Ticket_No:(NSString *)Ticket_No;
-(void)deleteDataByModel:(id)model Ticket_No:(NSString *)Ticket_No;
-(void)quaryDataByModel:(id)model Ticket_No:(NSString *)Ticket_No;
-(NSArray *)getAllData;
-(NSInteger)getAllDataCount;
-(void)deleteFMDBTable;
































/**********************************分割线******************************/

//插入历史数据
- (BOOL)insertHistoryData:(TestModel *)model;
//获取历史数据
- (NSMutableArray *)getHistoryList;

//删除数据
- (BOOL)deleteHistoryList;
//建表
- (BOOL)createUserTable;

@end
