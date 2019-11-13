//
//  TargetProtocol.h
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TargetProtocol <NSObject>

- (UIColor *)smallViewColor;

- (NSString *)userName;

- (NSString *)phone;

@end

NS_ASSUME_NONNULL_END
