//
//  Builder.h
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//构建者
@protocol Builder <NSObject>

//构建部分
-(NSString *)buildPart;

@end

NS_ASSUME_NONNULL_END
