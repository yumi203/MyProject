//
//  TextView.m
//  LottoDemo2
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "TextView.h"

@implementation TextView

//- (void)drawRect:(CGRect)rect{
//    //设置字体样式
//    UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f];
//    /* Load the color */
//    UIColor *magentaColor =[UIColor colorWithRed:0.5f
//                                           green:0.0f blue:0.5f
//                                           alpha:1.0f];
//    /* Set the color in the graphical context */
//    [magentaColor set];
//    //文字内容
//    NSString *myString = @"I Learn Really Fast";
//    //在屏 幕上 x 轴的 25 及 y 轴 190 处以 30 点的字体画出一个简单的字符串
//    //    [myString drawAtPoint:CGPointMake(25, 190) withFont:helveticaBold];
//    [myString drawInRect:CGRectMake(100,/* x */
//                                    120, /* y */
//                                    100, /* width */
//                                    200) /* height */
//                withFont:helveticaBold];
//    //获得一个颜色用于Quartz 2D绘图。只读
//    CGColorRef colorRef = [magentaColor CGColor];
//    //返回颜色组件
//    const CGFloat *components = CGColorGetComponents(colorRef);
//    //返回颜色组件的个数
//    NSUInteger componentsCount = CGColorGetNumberOfComponents(colorRef);
//    NSUInteger counter = 0;
//    for (counter = 0;counter <componentsCount; counter++){//循环输出
//        NSLog(@"Component %lu = %.02f",(unsigned long)counter,components[counter]);
//    }
//    
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    /*NO.1画一条线
     
     */
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextMoveToPoint(context, 20, 20);
//    CGContextAddLineToPoint(context, 200,20);
//    CGContextStrokePath(context);
    
    
    
    /*NO.2写文字
     
     */
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
//    UIFont  *font = [UIFont boldSystemFontOfSize:18.0];
//    [@"公司：北京中软科技股份有限公司\n部门：ERP事业部\n姓名：McLiang" drawInRect:CGRectMake(20, 40, 280, 300) withFont:font];
    
    
    /*NO.3画一个正方形图形 没有边框
     */
    
//    CGContextSetRGBFillColor(context, 0, 0.25, 0, 0.5);
//    CGContextFillRect(context, CGRectMake(2, 2, 270, 270));
//    CGContextStrokePath(context);
    
    
    /*NO.4画正方形边框
     
     */
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextSetLineWidth(context, 2.0);
//    CGContextAddRect(context, CGRectMake(2, 2, 270, 270));
//    CGContextStrokePath(context);
    
    
    /*NO.5画方形背景颜色
     
     */
//    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//    UIGraphicsPushContext(context);
//    CGContextSetLineWidth(context,320);
//    CGContextSetRGBStrokeColor(context, 250.0/255, 250.0/255, 210.0/255, 1.0);
//    CGContextStrokeRect(context, CGRectMake(0, 0, 320, 460));
//    UIGraphicsPopContext();
    
    /*NO.6椭圆
     
     */
//    CGRect aRect= CGRectMake(80, 80, 160, 100);
//    CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
//    CGContextSetLineWidth(context, 3.0);
//    CGContextAddEllipseInRect(context, aRect); //椭圆
//    CGContextDrawPath(context, kCGPathStroke);
    
    /*NO.7
     */
//    CGContextBeginPath(context);
//    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
//    CGContextMoveToPoint(context, 100, 100);
//    CGContextAddArcToPoint(context, 50, 100, 50, 150, 50);
//    CGContextStrokePath(context);
    
    /*NO.8渐变
     */
//    CGContextClip(context);
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
//        29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
//        0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(rgb);
//    CGContextDrawLinearGradient(context, gradient,CGPointMake
//                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
//                                kCGGradientDrawsBeforeStartLocation);
    
    
    /* NO.9四条线画一个正方形
     //画线
     */
//    UIColor *aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0];
//    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextSetLineWidth(context, 4.0);
//    CGPoint aPoints[5];
//    aPoints[0] =CGPointMake(60, 60);
//    aPoints[1] =CGPointMake(260, 60);
//    aPoints[2] =CGPointMake(260, 300);
//    aPoints[3] =CGPointMake(60, 300);
//    aPoints[4] =CGPointMake(60, 60);
//    CGContextAddLines(context, aPoints, 5);
//    CGContextDrawPath(context, kCGPathStroke); //开始画线
    
    
    
    /*  NO.10
     */
//    UIColor *aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0];
//    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    //椭圆
//    CGRect aRect= CGRectMake(80, 80, 160, 100);
//    CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
//    CGContextSetLineWidth(context, 3.0);
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextAddRect(context, rect); //矩形
//    CGContextAddEllipseInRect(context, aRect); //椭圆
//    CGContextDrawPath(context, kCGPathStroke);
    
    
    
    /*  NO.11
     画一个实心的圆
     
     */
//    CGContextFillEllipseInRect(context, CGRectMake(95, 95, 100.0, 100));
    
    
    
    /*NO.12
     画一个菱形
     */
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextMoveToPoint(context, 100, 100);
//    CGContextAddLineToPoint(context, 150, 150);
//    CGContextAddLineToPoint(context, 100, 200);
//    CGContextAddLineToPoint(context, 50, 150);
//    CGContextAddLineToPoint(context, 100, 100);
//    CGContextStrokePath(context);
    
    /*NO.13 画矩形
     */
//    CGContextSetLineWidth(context, 2.0);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    
//    CGRect rectangle = CGRectMake(60,170,200,80);
//    
//    CGContextAddRect(context, rectangle);
//    
//    CGContextStrokePath(context);
    
    
    /*椭圆
     */
//    CGContextSetLineWidth(context, 2.0);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    
//    CGRect rectangle = CGRectMake(60,170,200,80);
//    
//    CGContextAddEllipseInRect(context, rectangle);
//    
//    CGContextStrokePath(context);
    
    /*用红色填充了一段路径:
     
     */
//    CGContextMoveToPoint(context, 100, 100);
//    CGContextAddLineToPoint(context, 150, 150);
//    CGContextAddLineToPoint(context, 100, 200);
//    CGContextAddLineToPoint(context, 50, 150);
//    CGContextAddLineToPoint(context, 100, 100);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextFillPath(context);
    
    /*填充一个蓝色边的红色矩形
     CGContextSetLineWidth(context, 2.0);
     CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     CGRect rectangle = CGRectMake(60,170,200,80);
     CGContextAddRect(context, rectangle);
     CGContextStrokePath(context);
     CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
     CGContextFillRect(context, rectangle);
     */
    
    /*画弧
     //弧线的是通过指定两个切点，还有角度，调用CGContextAddArcToPoint()绘制
     CGContextSetLineWidth(context, 2.0);
     CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     CGContextMoveToPoint(context, 100, 100);
     CGContextAddArcToPoint(context, 100,200, 300,200, 100);
     CGContextStrokePath(context);
     */
    
    
    /*
     绘制贝兹曲线
     //贝兹曲线是通过移动一个起始点，然后通过两个控制点,还有一个中止点，调用CGContextAddCurveToPoint() 函数绘制
     CGContextSetLineWidth(context, 2.0);
     
     CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     
     CGContextMoveToPoint(context, 10, 10);
     
     CGContextAddCurveToPoint(context, 0, 50, 300, 250, 300, 400);
     
     CGContextStrokePath(context);
     */
    
    /*绘制二次贝兹曲线
     
     CGContextSetLineWidth(context, 2.0);
     
     CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     
     CGContextMoveToPoint(context, 10, 200);
     
     CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
     
     CGContextStrokePath(context);
     */
    
    /*绘制虚线
     CGContextSetLineWidth(context, 5.0);
     
     CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     
     CGFloat dashArray[] = {2,6,4,2};
     
     CGContextSetLineDash(context, 3, dashArray, 4);//跳过3个再画虚线，所以刚开始有6-（3-2）=5个虚点
     
     CGContextMoveToPoint(context, 10, 200);
     
     CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
     
     CGContextStrokePath(context);
     */
    /*绘制图片
     */
//    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
//    UIImage* myImageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
//    //[myImageObj drawAtPoint:CGPointMake(0, 0)];
//    [myImageObj drawInRect:CGRectMake(0, 0, 320, 480)];
//    
//    NSString *s = @"我的小狗";
//    
//    [s drawAtPoint:CGPointMake(100, 0) withFont:[UIFont systemFontOfSize:34.0]];
    
    /*
     NSString *path = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
     UIImage *img = [UIImage imageWithContentsOfFile:path];
     CGImageRef image = img.CGImage;
     CGContextSaveGState(context);
     CGRect touchRect = CGRectMake(0, 0, img.size.width, img.size.height);
     CGContextDrawImage(context, touchRect, image);
     CGContextRestoreGState(context);
     */
    
    
    /*NSString *path = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
     UIImage *img = [UIImage imageWithContentsOfFile:path];
     CGImageRef image = img.CGImage;
     CGContextSaveGState(context);
     
     CGContextRotateCTM(context, M_PI);
     CGContextTranslateCTM(context, -img.size.width, -img.size.height);
     
     CGRect touchRect = CGRectMake(0, 0, img.size.width, img.size.height);
     CGContextDrawImage(context, touchRect, image);
     CGContextRestoreGState(context);*/
    
    /*
     NSString *path = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"png"];
     UIImage *img = [UIImage imageWithContentsOfFile:path];
     CGImageRef image = img.CGImage;
     
     CGContextSaveGState(context);
     
     CGAffineTransform myAffine = CGAffineTransformMakeRotation(M_PI);
     myAffine = CGAffineTransformTranslate(myAffine, -img.size.width, -img.size.height);
     CGContextConcatCTM(context, myAffine);
     
     CGContextRotateCTM(context, M_PI);
     CGContextTranslateCTM(context, -img.size.width, -img.size.height);
     
     CGRect touchRect = CGRectMake(0, 0, img.size.width, img.size.height);
     CGContextDrawImage(context, touchRect, image);
     CGContextRestoreGState(context);
     */
}


@end
