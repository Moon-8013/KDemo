//
//  ColorView.h
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorView : UIView

-(void)setModel:(id<TargetProtocol>)model;

@end

NS_ASSUME_NONNULL_END
