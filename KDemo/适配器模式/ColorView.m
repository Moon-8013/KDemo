//
//  ColorView.m
//  KDemo
//
//  Created by W on 2019/11/11.
//  Copyright © 2019 wangting. All rights reserved.
//

#import "ColorView.h"

@interface ColorView ()

@property (nonatomic, strong)UIView *smallView;

@property (nonatomic, strong)UILabel *userL;

@property (nonatomic, strong)UILabel *phoneL;

@end

@implementation ColorView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];

    if (self) {
        [self setupUI];
    }

    return self;
}

-(void)setupUI{

    self.backgroundColor = [UIColor lightGrayColor];

    CGFloat width = self.bounds.size.width;
    self.smallView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, width, 200)];
    [self addSubview:self.smallView];

    self.userL = [[UILabel alloc]initWithFrame:CGRectMake(130.0, 100.0, 150.0, 25.0)];
    [self addSubview:self.userL];

    self.phoneL = [[UILabel alloc]initWithFrame:CGRectMake(130.0, 130.0, 150.0, 25.0)];
    [self addSubview:self.phoneL];
}

-(void)setModel:(id<TargetProtocol>)model{
    self.smallView.backgroundColor = model.smallViewColor;
    self.userL.text = model.userName;
    self.phoneL.text = model.phone;
}

@end
