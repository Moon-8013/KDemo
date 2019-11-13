//
//  Director.m
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import "Director.h"

@interface Director ()

@property( nonatomic, copy) id<Builder> builder;

@end

@implementation Director

//创建传入实现者
-(instancetype)initWithBuilder:(id<Builder>)builder{
    self = [super init];
    if (self) {
        _builder = builder;
    }
    return self;
}

//建造
-(NSString *)construst{
    //建造部件
    return [self.builder buildPart];
}

@end
