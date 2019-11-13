//
//  AnimationController.m
//  KDemo
//
//  Created by W on 2019/8/30.
//  Copyright © 2019 wangting. All rights reserved.
//

#import "AnimationController.h"

@interface AnimationController ()<CAAnimationDelegate>

@property (nonatomic, strong)UIView *animView;

@end

@implementation AnimationController

//动画三步骤
//1.初始化动画对象
//2.修改动画属性值
//3.将动画添加到layer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.animView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 100.0, 100.0)];
    self.animView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint point = [[touches anyObject]locationInView:self.animView];
    if (self.animView.layer.presentationLayer == [self.animView.layer hitTest:point]) {
        NSLog(@"111111");
    }

    [self caBasicAnimation];
}

//基础动画
-(void)caBasicAnimation{

    CABasicAnimation *caBasicAnima = [CABasicAnimation animation];
    caBasicAnima.keyPath = @"position.y";
    caBasicAnima.toValue = @400;
    caBasicAnima.duration = 1.0;
    caBasicAnima.removedOnCompletion = NO;//在完成的时候是否要移除动画
    caBasicAnima.fillMode = kCAFillModeForwards;//保持最新状态
    caBasicAnima.delegate = self;
    [self.animView.layer addAnimation:caBasicAnima forKey:nil];
}

#pragma mark - CAAnimationDelegate

-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"%@",NSStringFromCGRect(self.animView.frame));
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%@",NSStringFromCGRect(self.animView.frame));
}

@end
