//
//  ModelViewAdapter.m
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import "ModelViewAdapter.h"

#import "Model.h"

@implementation ModelViewAdapter

-(UIColor *)smallViewColor{
    Model *model = self.model;
    if ([model.smallViewColor isKindOfClass:[NSString class]]) {
        return [UIColor grayColor];
    }
    return model.smallViewColor;
}

-(NSString *)userName{
    Model *model = self.model;
    return model.userName;
}

-(NSString *)phone{
    Model *model = self.model;
    return model.phone;
}

@end
