//
//  TestModel.h
//  FMDB_Demo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property(copy,nonatomic)NSString *Ticket_No;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
