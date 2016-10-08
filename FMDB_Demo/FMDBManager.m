//
//  FMDBManager.m
//  FMDB_Demo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "FMDBManager.h"

@implementation FMDBManager

+(FMDBManager *)shareManager
{
    static dispatch_once_t once;
    static FMDBManager *manager = nil;
    
    dispatch_once(&once, ^{
        manager = [[FMDBManager alloc]init];
    });
    return manager;
    
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"%@",path);
        NSLog(@"%@",[NSString stringWithFormat:@"%@/userInfo.db",path]);
        self.dataBase = [[FMDatabase alloc]initWithPath:[NSString stringWithFormat:@"%@/userInfo.db",path]];
    }
    return self;
}
-(void)createFMDBTable
{
    if ([_dataBase open]) {
        NSString *tableSql = @"CREATE TABLE IF NOT EXISTS FMDBTable (Ticket_No)";
        BOOL isSuccess = [_dataBase executeUpdate:tableSql];
        if (!isSuccess) {
            NSLog(@"表创建失败:%@",[_dataBase lastErrorMessage]);
        }else{
            NSLog(@"表创建成功");
        }
    }else{
        NSLog(@"open database:%@",[_dataBase lastErrorMessage]);
    }

}
- (BOOL)isExistDataByTicket_No:(NSString *)Ticket_No{
    NSString *selectSql = @"select * from FMDBTable where Ticket_No=?";
    FMResultSet *rs = [_dataBase executeQuery:selectSql,Ticket_No];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }
}
-(void)insertDataByModel:(id)model Ticket_No:(NSString *)Ticket_No{
    TestModel *cacheModel=(TestModel *)model;
    if ([self isExistDataByTicket_No:cacheModel.Ticket_No]) {
        //已经插入过本地了 -- 所以要删除了
//        [self deleteDataByModel:model Ticket_No:Ticket_No];
    }else{//直接插入数据
        NSString *insertSql = [NSString stringWithFormat:@"insert into FMDBTable (Ticket_No) values('%@')",cacheModel.Ticket_No];
        if(![_dataBase executeUpdate:insertSql]){
            NSLog(@"插入数据失败:%@",[_dataBase lastErrorMessage]);
        }else{
            NSLog(@"插入数据成功");
        }
    }

}
-(void)deleteDataByModel:(id)model Ticket_No:(NSString *)Ticket_No{
    TestModel *cacheModel=(TestModel *)model;
    NSString *deleteSql = @"delete from FMDBTable where Ticket_No=?";
    BOOL isSuccess = [_dataBase executeUpdate:deleteSql,cacheModel.Ticket_No];
    if (!isSuccess) {
        NSLog(@"删除数据失败:%@",[_dataBase lastErrorMessage]);
    }else  {
        NSLog(@"删除数据成功");
    }
}
-(void)quaryDataByModel:(id)model Ticket_No:(NSString *)Ticket_No{

}
-(NSArray *)getAllData{
    NSString *getArrGoodssql = @"select * from FMDBTable";
    FMResultSet *rs = [_dataBase executeQuery:getArrGoodssql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next]) {
        TestModel *cacheModel=[[TestModel alloc] initWithDictionary:rs.resultDictionary];
        [arr addObject:cacheModel];
    }
    return arr;//返回找到的所有记录
}
-(NSInteger)getAllDataCount{
    return [[self getAllData] count];
}
-(void)deleteFMDBTable{
    NSString *deleteSql = @"delete from FMDBTable";
    BOOL isSuccess = [_dataBase executeUpdate:deleteSql];
    if (!isSuccess) {
        NSLog(@"删除表内容失败:%@",[_dataBase lastErrorMessage]);
    }else  {
        NSLog(@"删除表内容成功");
    }
}









































































































































/*************************************分割线******************************/
//建表
- (BOOL)createUserTable
{
    NSLog(@"建数据库表");
    if ([self.dataBase open]) {
        NSLog(@"打开数据表");
        
        NSString *sqls = [NSString stringWithFormat:@"create table if not exists history%@(serial integer  Primary Key Autoincrement,Ticket_No Varchar)",kUserTel];
        
        BOOL isSuccess = [self.dataBase executeUpdate:sqls];
        if (!isSuccess) {
            NSLog(@"creat Table failed:%@",self.dataBase.lastErrorMessage);
            return NO;
        }
        [self.dataBase close];
        return YES;
        
    }else {
        NSLog(@"creatTabel open database failed!%@",self.dataBase.lastErrorMessage);
        
        return NO;
        
    }
    
    return NO;
    
}


#pragma mark --------- 用来执行sql语句 更新或查询
//执行除查询外的sql语句

-(BOOL)runUpdateSql:(NSString *)sql
{
    @try {
        BOOL openFlag = [self.dataBase open];
        BOOL updateFlag = [self.dataBase executeUpdate:sql];
        if (openFlag) {
            [self.dataBase close];
            return openFlag&&updateFlag;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        
    } @finally {
        
    }
    return NO;
}



//执行查询的sql语句
- (FMResultSet *)runQuerySql:(NSString *)sql {
    
    @try {
        BOOL openFlag = [self.dataBase open];
        FMResultSet *result = [self.dataBase executeQuery:sql];
        return result;
        if (openFlag) {
            [self.dataBase close];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        
    }
    @finally {
        
    }
    return nil;
}
-(BOOL)insertHistoryData:(TestModel *)model
{
    NSString *selectSql = [NSString stringWithFormat:@"select  from history%@ where Ticket_No = '%@'",kUserTel,model.Ticket_No];
    
    FMResultSet *resultSet = [self runQuerySql:selectSql];
    BOOL flag = NO;
    while ([resultSet next]) {
        selectSql = [resultSet stringForColumn:@"Ticket_No"];
        flag = YES;
    }
    
    if (flag) {
        //有该历史订单； 不再插入数据库
        NSLog(@"------ 有该历史订单； 不再插入数据库");
    }else {
        [self searchHistoryCount];
        NSString *sql = [NSString stringWithFormat:@"insert into history%@(Ticket_No)values('%@')",kUserTel,model.Ticket_No];
        return [self runUpdateSql:sql];
    }
    return YES;
    
}

#pragma mark ------- > 查询有几条数据
- (void)searchHistoryCount
{
    
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from history%@",kUserTel];
    NSInteger count = [_dataBase intForQuery:selectSql];
    if (count >= 10) {
        NSString * sql = [NSString stringWithFormat:@"select min(serial) from history%@",kUserTel];
        NSUInteger tmpId = [self.dataBase intForQuery:sql];
        
        [self.dataBase close];
        NSString *delSql = [NSString stringWithFormat:@"delete from history%@ where serial = %@",kUserTel,[NSString stringWithFormat:@"%ld",tmpId]];
        
        [self runUpdateSql:delSql];
        
    }
    
}
- (NSMutableArray *)getHistoryList
{
    [self.dataBase open];
    NSString *sql = [NSString stringWithFormat:@"select * from history%@",kUserTel];
    FMResultSet *result = [self runQuerySql:sql];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    while ([result next]) {
        TestModel *historyModel= [[TestModel alloc]initWithDictionary:result.resultDictionary];
        [arr addObject:historyModel];
    }
    return arr;
}

-(BOOL)deleteHistoryList
{
    NSString *sql = [NSString stringWithFormat:@"delete from history%@",kUserTel];
    return  [self runUpdateSql:sql];
}


@end
