//
//  KtimeView.m
//  KDemo
//
//  Created by W on 2018/3/29.
//  Copyright © 2018年 wangting. All rights reserved.
//

#import "KtimeView.h"

@implementation KtimeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.clearsContextBeforeDrawing = YES;

        NSString *path = [[NSBundle mainBundle] pathForResource:@"kData" ofType:@"plist"];
        NSArray *kDataArr = [NSArray arrayWithContentsOfFile:path];

        NSMutableArray *tempArr = [NSMutableArray array];
        __weak typeof(self) weakSelf = self;
        [kDataArr enumerateObjectsUsingBlock:^(NSString *dataStr, NSUInteger idx, BOOL * _Nonnull stop) {
            //@"时间戳,收盘价,开盘价,最高价,最低价,成交量",
            NSArray *arr = [dataStr componentsSeparatedByString:@","];
            [tempArr addObject:arr];
        }];

        [self DataConvertXy:tempArr];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

    CGContextRef context = UIGraphicsGetCurrentContext();
    // 绘制背景框
    [self drawBackGround:context];
    [self drawTimeLine:context];
}


//转换坐标
-(void)DataConvertXy:(NSArray *)array{

    //获取最高价最低价
    float low = 100000000.0;  // 最底点
    float high = 0.0; // 最高点
    float l = 0.0;
    float h = 0;
    int volume = 0; // 交易量

    float max_volume = 0;

    for (int i = 0; i < [array count]; i++) {
        l = [array[i][4] floatValue];
        h = [array[i][3] floatValue];
        volume = [array[i][5] floatValue];

        if (low>l) {
            low = l;
        }
        if (high<h) {
            high = h;
        }

        if (volume>max_volume) {
            max_volume = volume;
        }
    }

    //计算坐标
    float min_y = 0.0;
    float min_h = high - low;
    if (high-low == 0) {
        min_y = 0;//停牌
    }else{
        min_y = self.frame.size.height/min_h;
    }

    float x = 0;
    float y = 0;
    float min_w = self.frame.size.width/array.count;

    NSMutableDictionary *localItem = nil;
    self.drawTimeListArray = [[NSMutableArray alloc]init];
    if (min_y == 0) {
        for (int k = 0; k <  [array count]; k ++) {
            localItem = [NSMutableDictionary dictionary];
            if (k == 0) {
                x = 0;
            }else{
                x = k*min_w;
            }
            [localItem setObject:@"0" forKey:@"average"];
            [localItem setObject:[NSString stringWithFormat:@"%f",x] forKey:@"x"];
            [localItem setObject:[NSString stringWithFormat:@"%f",self.frame.size.height/2] forKey:@"y"];
            [self.drawTimeListArray addObject:localItem];

        }
    }else{
        float close = 0;
        float close_h = 0;

        //        int volume = 0;
        //        double totalValue = 0;
        //        double totalTrade = 0;
        //        double timeAverage = 0;
        //        float timeAverage_h = 0;
        //        float timeAverage_y  = 0;

        for (int k = 0; k < [array count]; k ++){

            close = [array[k][1] floatValue];
            close_h = close - l;

            y = self.frame.size.height - min_y*close_h;

            if (k == 0) {
                x = 0;
            }else{
                x = min_w*k;
            }

            localItem = [NSMutableDictionary dictionary];
            [localItem setObject:[NSString stringWithFormat:@"%f",x] forKey:@"x"];
            [localItem setObject:[NSString stringWithFormat:@"%f",y] forKey:@"y"];
            [self.drawTimeListArray addObject:localItem];

            //            // 计算分时均价
            //            //某一时点的均价＝开盘时到这个时点的所有的 成交价格×相应的成交股数/开盘时到这个时点总成交量
            //            //把所有时点的均价连成线就是股票分时图的均线
            //            volume = [array[k][5] intValue];
            //            if (volume != 0) {
            //                totalValue = totalValue + close * volume;//总成交价格
            //                totalTrade = totalTrade + volume;//总成交量
            //
            //                timeAverage = totalValue / totalTrade;//分时成交均价
            //
            //                timeAverage_h = timeAverage - l;   // close 点 相对高度 ＝ close点高度 － 最低点的高度
            //                timeAverage_y = self.view.frame.size.height - min_y*timeAverage_h;    // y 最大坐标 － 换算后的高度 ＝ y轴新的坐标
            //
            //                localItem = [NSMutableDictionary dictionary];
            //                [localItem setObject:[NSString stringWithFormat:@"%f",timeAverage] forKey:Average];
            //                [localItem setObject:[NSString stringWithFormat:@"%f",x] forKey:@"x"];
            //                [localItem setObject:[NSString stringWithFormat:@"%f",timeAverage_y] forKey:@"y"];
            //                [self.drawTimeAverageListArray addObject:localItem];
            //            }
        }
    }

    [self setNeedsDisplay];
}


//绘制分时图背景框
-(void)drawBackGround :(CGContextRef)context{

    // 四周得矩形框
    CGFloat bg_ling_width = 1.0f;

    // 绘制前，先清楚所有绘图区域
    CGContextClearRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));

    // 设置线的颜色，红色
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);

    // 设置线的宽度
    CGContextSetLineWidth(context, bg_ling_width);

    // [S]整个矩形框范围
    CGContextAddRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)); // 分时背景框
    CGContextStrokePath(context);

    // 分时背景虚线
    // 虚线设置
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.2);

    CGFloat dashPhase = 2.0;
    CGFloat dashPattern[2] = {4.0, 4.0};
    size_t dashCount = 2;
    CGContextSetLineDash(context, dashPhase, dashPattern, dashCount);

    // 竖线
    CGContextMoveToPoint(context, self.frame.size.width/4, 1);
    CGContextAddLineToPoint(context, self.frame.size.width/4, self.frame.size.height - 2);

    CGContextMoveToPoint(context, self.frame.size.width/2, 1);
    CGContextAddLineToPoint(context, self.frame.size.width/2, self.frame.size.height - 2);

    CGContextMoveToPoint(context, self.frame.size.width/4*3, 1);
    CGContextAddLineToPoint(context, self.frame.size.width/4*3, self.frame.size.height - 2);


    // 横线
    CGContextMoveToPoint(context, 1, self.frame.size.height/4);
    CGContextAddLineToPoint(context, self.frame.size.width - 2, self.frame.size.height/4);

    CGContextMoveToPoint(context, 1, self.frame.size.height/2);
    CGContextAddLineToPoint(context, self.frame.size.width - 2, self.frame.size.height/2);

    CGContextMoveToPoint(context, 1, self.frame.size.height/4*3);
    CGContextAddLineToPoint(context, self.frame.size.width - 2, self.frame.size.height/4*3);
    CGContextStrokePath(context);

    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, 0, 0); //取消虚线
}

- (void) drawTimeLine:(CGContextRef)context{

    // [S]分时数据
    if (self.drawTimeListArray== nil) {
        return;
    }

    // 分钟点
    CGFloat bg_ling_width = 1.0;
    CGContextSetLineWidth(context, bg_ling_width);
    UIColor *mycolor = [UIColor grayColor];
    CGContextSetStrokeColorWithColor(context, [mycolor CGColor]);

    float x;
    float y;
    NSDictionary *localItem = nil;
    for(int k = 0; k < [self.drawTimeListArray count]; k++){
        localItem = [self.drawTimeListArray objectAtIndex:k];

        x = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"x"]] floatValue];
        y = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"y"]] floatValue];

        if(k == 0){
            CGContextMoveToPoint(context, x, y); // 移动到起点坐标
        } else {
            // 增加新的坐标点
            CGContextAddLineToPoint(context, x, y);
        }
    }

    CGContextStrokePath(context);
}



@end
