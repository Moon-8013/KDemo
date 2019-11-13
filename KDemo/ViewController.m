//
//  ViewController.m
//  KDemo
//
//  Created by W on 2018/3/21.
//  Copyright © 2018年 wangting. All rights reserved.
//

#import "ViewController.h"
#import "KtimeView.h"
#import "KZhutaiView.h"
#import "AnimationController.h"

//建造者模式
#import "Director.h"
#import "ConcreteBuild.h"

//适配器模式
#import "ColorView.h"
#import "Model.h"
#import "ModelViewAdapter.h"


#import <ReactiveObjC/ReactiveObjC.h>


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    KZhutaiView *ktimeView = [[KZhutaiView alloc]initWithFrame:CGRectMake(0, 100, 414, 414)];
//    [self.view addSubview:ktimeView];

//    self.array = @[@"核心动画"];
//
//    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.tableview.dataSource = self;
//    self.tableview.delegate = self;
//    [self.view addSubview:self.tableview];

//    //建造者模式
//    ConcreteBuild *build = [[ConcreteBuild alloc]init];
//    Director *director= [[Director alloc]initWithBuilder:build];
//    NSString *str = [director construst];
//    NSLog(@"%@",str);
//
//    //适配器模式
//    ColorView *colorView = [[ColorView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:colorView];
//
//    Model *model = [[Model alloc]init];
//    model.smallViewColor = [UIColor redColor];
//    model.userName = @"俊杰";
//    model.phone = @"021-0923-2321";
//
//    ModelViewAdapter *adapter = [[ModelViewAdapter alloc]initWithModel:model];
//    [colorView setModel:adapter];

    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return nil;
    }];

    [signal subscribeNext:^(id  _Nullable x) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview datasource & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str = @"cell";

    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:str];

    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }

    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        AnimationController *animationView = [[AnimationController alloc]init];
        [self.navigationController pushViewController:animationView animated:YES];
    }
}

@end
