//
//  TestModel.m
//  FMDB_Demo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == nil) {
        [super setValue:@"" forKey:key];
    }
    else if ([value isKindOfClass:[NSNull class]]){
        [super setValue:@"" forKey:key];
    }
    
    else{
        [super setValue:value forKey:key];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
