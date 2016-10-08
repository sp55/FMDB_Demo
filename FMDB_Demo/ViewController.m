//
//  ViewController.m
//  FMDB_Demo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "FMDBManager.h"
#import "TestModel.h"
@interface ViewController ()
@property (nonatomic,strong)FMDBManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [FMDBManager shareManager];
    [self.manager createFMDBTable];
}

#pragma mark - 增
- (IBAction)addAction:(UIButton *)sender {
    TestModel *model = [[TestModel alloc] init];
//    model.Ticket_No = @"100";
//    [self.manager insertDataByModel:model Ticket_No:@"100"];

    for (NSInteger i=100;i<=2000;i++) {
        model.Ticket_No = [NSString stringWithFormat:@"%zd",i];
        [self.manager insertDataByModel:model Ticket_No:[NSString stringWithFormat:@"%zd",i]];
    }
    
}
#pragma mark - 删

- (IBAction)deleteAction:(id)sender {
    TestModel *model = [[TestModel alloc] init];
    [self.manager deleteDataByModel:model Ticket_No:@"100"];
}
#pragma mark - 改
- (IBAction)replaceAction:(UIButton *)sender {
}
#pragma mark - 查
- (IBAction)quaryAction:(UIButton *)sender {
}
#pragma mark - 获取搜索元素
- (IBAction)getAllData:(UIButton *)sender {
    
    
    NSArray *dataArr=[self.manager getAllData];
    
    for (TestModel *model in dataArr) {
        NSLog(@"===获取搜索元素===%@",model.Ticket_No);
    }
    
//    NSLog(@"===获取搜索元素===%@",[self.manager getAllData]);
}
#pragma mark - 获取所有元素个数
- (IBAction)getAllDataCount:(UIButton *)sender {
    NSLog(@"===获取所有元素个数===%ld",[self.manager getAllDataCount]);
}
#pragma mark - 删除表内容
- (IBAction)deleteFMDBTable:(UIButton *)sender {
    [self.manager deleteFMDBTable];
}

@end
