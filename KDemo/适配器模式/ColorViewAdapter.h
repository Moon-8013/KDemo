//
//  ColorViewAdapter.h
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TargetProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorViewAdapter : NSObject<TargetProtocol>

@property (nonatomic, strong)id model;

-(instancetype)initWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
