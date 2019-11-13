//
//  ColorViewAdapter.m
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import "ColorViewAdapter.h"


@implementation ColorViewAdapter

- (instancetype)initWithModel:(id)model{

    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

-(UIColor *)smallViewColor{
    return nil;
}

-(NSString *)userName{
    return nil;
}

-(NSString *)phone{
    return nil;
}

@end
