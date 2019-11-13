
//
//  KZhutaiView.m
//  KDemo
//
//  Created by W on 2018/3/29.
//  Copyright © 2018年 wangting. All rights reserved.
//

#import "KZhutaiView.h"

@implementation KZhutaiView


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
//    // 绘制背景框
    [self drawBackGround:context];
    [self drawZhuTai:context];
}

-(void)DataConvertXy:(NSArray *)array{

    self.drawKLineZTListArray = [NSMutableArray array];


    // [S] 计算最底点 和 最 高点
    float min_low = 0;  // 最底点
    float max_high = 0; // 最高点
    float l;
    float h = 0;
    NSDictionary *itemDict = nil;

    int start_index = 22;

    if ([array count] < 22) {
        start_index = 0;
    }


    //获取最高最低价
    for (int i = 0; i < [array count]; i++) {
        l = [array[i][4] floatValue];
        h = [array[i][3] floatValue];

        if(i == 0){
            min_low = l;
            max_high = h;
        } else {
            if(min_low > l){
                min_low = l;
            }

            if(max_high < h){
                max_high = h;
            }
        }
    }

    if (max_high==min_low) {
    }

//
//    for (int k = 0 ;k < 0 + array.count; k ++) {
//
//        float ma5 = [self.drawMA5ListArray[k] floatValue];
//        float ma10 = [self.drawMA10ListArray[k] floatValue];
//        float ma20 = [self.drawMA20ListArray[k] floatValue];
//        if(ma5 >  max_high){
//            max_high = ma5;
//        }
//        if(ma10 >  max_high){
//            max_high = ma10;
//        }
//        if(ma20 >  max_high){
//            max_high = ma20;
//        }
//    }
//
//    last_KLineHigh = max_high;
//    last_KLineLow = min_low;
    // [E]

    // 烛台范围: 左上角坐标(0,0) -- 右下角(320,160)
    // k线
    float s_zt_sx = 0; //50
    float s_zt_ey = self.frame.size.height;
    float s_zt_w = self.frame.size.width;
    float s_zt_h = self.frame.size.height;

    // 计算 x 轴上 每段 长度
    float min_w = s_zt_w/array.count;
    // 计算 y 轴上 每段 长度
    float max_h_count = max_high - min_low;       // 计算y轴间隔数
    float min_h = s_zt_h/max_h_count;             // 计算最小间隔长度

    // 最后一次 最小高度 记录
//    last_KLineMinH = min_h;

    // [S] 绘图坐标计算
    NSMutableDictionary *localItem;

    // 烛台图矩形坐标绘制计算方法，取得最高点的坐标，根据最高点和最底点计算出要绘制的长度，宽度是固定的
    float open;
    float close;
    float high,low;
    float x = 0;    // 烛台起点x坐标
    float y = 0;    // 烛台起点y坐标
    float y_h = 0;  // 烛台高度
    NSString *stauts = nil;

    int t_count = (int)[array count];
    for (int i = 0; i < t_count; i++) {

        open = [array[i][2] floatValue];
        close = [array[i][1] floatValue];
        high = [array[i][3] floatValue];
        low = [array[i][4] floatValue];

        // [S]走高 走底 判断
        if (close >= open) {
            stauts = @"up"; //up/down
        } else {
            stauts = @"down"; //up/down
        }
        // [E]

        // x = 烛台x轴开始坐标 ＋ 条数*x轴最小宽度
        x = s_zt_sx + i*min_w;

        // y = 烛台y轴最大坐标 －（高点－最底高度）* y轴分段高度
        // y_h ＝ （高点－底点）* y轴分段高度
        if(open >= close){
            y = s_zt_ey - (open - min_low)*min_h;
            y_h = (open - close)*min_h;
        } else {
            y = s_zt_ey - (close - min_low)*min_h;
            y_h = (close - open)*min_h;
        }

        localItem = [NSMutableDictionary dictionary];
        [localItem setValue:stauts forKey:@"status"]; // up/down
        [localItem setValue:[NSString stringWithFormat:@"%f",x+1] forKey:@"x"];
        [localItem setValue:[NSString stringWithFormat:@"%f",y] forKey:@"y"];
        [localItem setValue:[NSString stringWithFormat:@"%f",min_w - 2] forKey:@"x_w"];
        [localItem setValue:[NSString stringWithFormat:@"%f",y_h] forKey:@"y_h"];

        //float open,close,high,low;
        // 计算是否需要绘制 最高点
        if (high > open && high > close) {
            [localItem setValue:@"yes" forKey:@"has_hight"];
            // 如果有，计算 烛台图举行上线到最高点的坐标
            float h_x1 = x + min_w/2;
            float h_y1 = y;
            float h_x2 = x + min_w/2;
            float h_y2 = s_zt_ey - (high - min_low)*min_h;
            [localItem setValue:[NSString stringWithFormat:@"%f",h_x1] forKey:@"h_x1"];
            [localItem setValue:[NSString stringWithFormat:@"%f",h_y1] forKey:@"h_y1"];
            [localItem setValue:[NSString stringWithFormat:@"%f",h_x2] forKey:@"h_x2"];
            [localItem setValue:[NSString stringWithFormat:@"%f",h_y2] forKey:@"h_y2"];
        } else {
            [localItem setValue:@"no" forKey:@"has_hight"];
        }
        // 计算是否需要绘制 最低点
        if (low < open && low < close) {
            [localItem setValue:@"yes" forKey:@"has_low"];
            // 如果有，计算 烛台图举行下线到最高点的坐标
            float l_x1 = x + min_w/2;
            float l_y1 = y + y_h;
            float l_x2 = x + min_w/2;
            float l_y2 = s_zt_ey - (low - min_low)*min_h;
            [localItem setValue:[NSString stringWithFormat:@"%f",l_x1] forKey:@"l_x1"];
            [localItem setValue:[NSString stringWithFormat:@"%f",l_y1] forKey:@"l_y1"];
            [localItem setValue:[NSString stringWithFormat:@"%f",l_x2] forKey:@"l_x2"];
            [localItem setValue:[NSString stringWithFormat:@"%f",l_y2] forKey:@"l_y2"];
        } else {
            [localItem setValue:@"no" forKey:@"has_low"];
        }

        // [S] 每条线对应的数据保存
        [localItem setValue:[itemDict objectForKey:array[i][2]] forKey:@"open"];
        [localItem setValue:[itemDict objectForKey:array[i][1]] forKey:@"close"];
        [localItem setValue:[itemDict objectForKey:array[i][3]] forKey:@"high"];
        [localItem setValue:[itemDict objectForKey:array[i][4]] forKey:@"low"];
//        [localItem setValue:[itemDict objectForKey:AF_K_MARKET_UPDATETIME] forKey:AF_K_MARKET_UPDATETIME];

        // [E]
        [self.drawKLineZTListArray addObject:localItem];
    }
    // [E] 绘图坐标计算
    [self.drawKLineZTListArray subarrayWithRange:NSMakeRange(0, 50)];


}

// 绘制背景框
-(void) drawBackGround :(CGContextRef)context{

    // 绘制前，先清楚所有绘图区域
    CGContextClearRect(context, CGRectMake(0, 0, self.frame.size.width,self.frame.size.height));


    // 设置线宽
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)); // 分时背景框
    CGContextStrokePath(context);


    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    // 分时背景虚线
    // 虚线设置
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
    CGContextMoveToPoint(context, 1,self.frame.size.height/4);
    CGContextAddLineToPoint(context,self.frame.size.width - 2, self.frame.size.height/4);

    CGContextMoveToPoint(context, 1,self.frame.size.height/2);
    CGContextAddLineToPoint(context,self.frame.size.width - 2,self.frame.size.height/2);

    CGContextMoveToPoint(context, 1,self.frame.size.height/4*3);
    CGContextAddLineToPoint(context,self.frame.size.width - 2,self.frame.size.height/4*3);
    CGContextStrokePath(context);

    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, 0, 0); //取消虚线
}

-(void) drawZhuTai:(CGContextRef)context{


    CGFloat bg_ling_width = 1.0;
    CGContextSetLineWidth(context, bg_ling_width);
    UIColor *mycolor = [UIColor grayColor];
    CGContextSetStrokeColorWithColor(context, [mycolor CGColor]);

    float x;
    float y;
    float x_w;
    float y_h;
    NSString *status = @"";
    NSString *has_hight = @""; // yes/no
    NSString *has_low = @""; // yes/no
    float h_x1,h_y1,h_x2,h_y2;
    float l_x1,l_y1,l_x2,l_y2;

    NSDictionary *localItem = nil;
    for(int k = 0; k < [self.drawKLineZTListArray count]; k++){
        localItem = [self.drawKLineZTListArray objectAtIndex:k];

        x = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"x"]] floatValue];
        y = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"y"]] floatValue];
        x_w = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"x_w"]] floatValue];
        y_h = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"y_h"]] floatValue];
        status = [localItem objectForKey:@"status"]; // up/down

        //NSLog(@"status = %@",status);

        if ([status isEqualToString:@"up"]) {
            if(y_h == 0){
                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                CGContextAddRect(context, CGRectMake(x, y, x_w, y_h));
                CGContextStrokePath(context);
            }else{
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                CGContextAddRect(context, CGRectMake(x, y, x_w, y_h));
                CGContextFillPath(context);

                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            }

        } else {
            if(y_h == 0){
                CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
                CGContextAddRect(context, CGRectMake(x, y, x_w, y_h));
                CGContextStrokePath(context);
            }else{
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
                CGContextAddRect(context, CGRectMake(x, y, x_w, y_h));
                CGContextFillPath(context);

                CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            }
        }

        // 计算是否需要绘制 最高点
        has_hight = [NSString stringWithFormat:@"%@",[localItem objectForKey:@"has_hight"]];
        //NSLog(@" has_hight = %@",has_hight);
        if ([has_hight isEqualToString:@"yes"]) {
            h_x1 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"h_x1"]] floatValue];
            h_y1 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"h_y1"]] floatValue];
            h_x2 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"h_x2"]] floatValue];
            h_y2 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"h_y2"]] floatValue];

            //NSLog(@" h_x1 = %f, h_y1 = %f, h_x2 = %f, h_y2 = %f",h_x1,h_y1,h_x2,h_y2);

            CGContextMoveToPoint(context, h_x1, h_y1); // 移动到起点坐标
            // 增加新的坐标点
            CGContextAddLineToPoint(context, h_x2, h_y2);
        }

        // 计算是否需要绘制 最低点
        has_low = [NSString stringWithFormat:@"%@",[localItem objectForKey:@"has_low"]];
        if ([has_low isEqualToString:@"yes"]) {
            l_x1 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"l_x1"]] floatValue];
            l_y1 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"l_y1"]] floatValue];
            l_x2 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"l_x2"]] floatValue];
            l_y2 = [[NSString stringWithFormat:@"%@",[localItem objectForKey:@"l_y2"]] floatValue];

            CGContextMoveToPoint(context, l_x1, l_y1); // 移动到起点坐标
            // 增加新的坐标点
            CGContextAddLineToPoint(context, l_x2, l_y2);
        }

        CGContextStrokePath(context);
    }
    // [E]
}

@end
