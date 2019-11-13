//
//  Director.h
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bulider.h"
NS_ASSUME_NONNULL_BEGIN

@interface Director : NSObject

//创建传入实现者
-(instancetype)initWithBuilder:(id<Builder>)builder;

//建造
-(NSString *)construst;

@end

NS_ASSUME_NONNULL_END
