//
//  SelectBallView.m
//  SelectButtonViewDemo
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "SelectBallView.h"

@interface SelectBallView ()
{
    CGFloat itemWidth;
}
//内容数组
@property (nonatomic, strong) NSArray *numberArray;
//把数字对应的Rect存到数组中
@property (nonatomic, strong) NSMutableArray *numberRectArray;
//记载点击了哪些数
@property (nonatomic, strong) NSMutableSet *selectNumberSet;

@end

@implementation SelectBallView

- (instancetype)initWithFrame:(CGRect)frame numberArray:(NSArray *)numberArray ballWidth:(CGFloat)width column:(NSInteger)column {
    if (self = [super initWithFrame:frame]) {
        self.numberArray = numberArray;
        self.column = column;
        self.ballWidth = width;
        self.canClick = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //获取上下文方法
    CGContextRef context = UIGraphicsGetCurrentContext();
    //填充背景颜色
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
    //绘制背景圆的方法
    CGContextStrokePath(context);
    for (NSInteger i = 0; i < self.numberArray.count; i++) {
        CGRect roundRect = CGRectFromString(self.numberRectArray[i]);
        if (![self.selectNumberSet containsObject:@(i)]) {
            [[UIColor grayColor] set];
            //绘制空心圆
            CGContextStrokeEllipseInRect(context, roundRect);
        }else {
            [[UIColor redColor] set];
            //绘制实心圆
            CGContextFillEllipseInRect(context, roundRect);
        }
    }
    NSInteger lineNumber = -1;
    //绘制数字
    for (NSInteger i = 0; i < self.numberArray.count ; i++) {
        NSInteger columnNumber = i % self.column;
        //判断是几行
        if (columnNumber == 0) lineNumber++;
        
        //通过自身控件的宽和高以及列数计算每一个块内容的位置
        CGFloat columnX = columnNumber * itemWidth + ((itemWidth - self.ballWidth) / 2);
        CGFloat lineY = lineNumber * itemWidth + ((itemWidth - self.ballWidth) / 2);
        NSString *numStr = [NSString stringWithFormat:@"%ld",i + 1];
        
        CGRect numRect = [numStr boundingRectWithSize:CGSizeMake(self.ballWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil];
        if (![self.selectNumberSet containsObject:@(i)]) {
            
            NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
            para.alignment = NSTextAlignmentCenter;
            //因为文字的上下间距没有居中需要增加一段高度
            [numStr drawInRect:CGRectMake(columnX,lineY + ((self.ballWidth - numRect.size.height) / 2),self.ballWidth,self.ballWidth)
                withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor redColor], NSParagraphStyleAttributeName : para}];
        }else {
            NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
            para.alignment = NSTextAlignmentCenter;
            [numStr drawInRect:CGRectMake(columnX,lineY + ((self.ballWidth - numRect.size.height) / 2),self.ballWidth,self.ballWidth)
                withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName : para}];
        }
    }
    //绘制线方法
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //去取得当前选中的位置用来判断是否在数组中
    CGRect selectRect = [self getRectWithTouch:touches];
    
    NSInteger selectIndex = [self.numberRectArray indexOfObject:NSStringFromCGRect(selectRect)];

    CGPoint resultPoint = [self getBigImageInSelectRect:selectRect.origin];
    if (resultPoint.x == 0 && resultPoint.y == 0) {
        //移除大字
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
    }else {
        [self addBigSelectImageWihtNumber:selectIndex + 1 location:resultPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //去取得当前选中的位置用来判断是否在数组中
    CGRect selectRect = [self getRectWithTouch:touches];
    
    NSInteger selectIndex = [self.numberRectArray indexOfObject:NSStringFromCGRect(selectRect)];
    
    CGPoint resultPoint = [self getBigImageInSelectRect:selectRect.origin];
    if (resultPoint.x == 0 && resultPoint.y == 0) {
        //移除大字
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
    }else {
        [self addBigSelectImageWihtNumber:selectIndex + 1 location:resultPoint];
    }
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //移除大字
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:999] removeFromSuperview];
    //去取得当前选中的位置用来判断是否在数组中
    CGRect selectRect = [self getRectWithTouch:touches];
    NSInteger selectIndex = [self.numberRectArray indexOfObject:NSStringFromCGRect(selectRect)];
    
    //后面的步骤只有在结束时才执行
    if ([self.selectNumberSet containsObject:@(selectIndex)]) {
        [self.selectNumberSet removeObject:@(selectIndex)];
    }else {
        [self.selectNumberSet addObject:@(selectIndex)];
    }
    //仅仅重新绘制选中区域
    [self setNeedsDisplayInRect:CGRectMake(selectRect.origin.x - (itemWidth - self.ballWidth - 1), selectRect.origin.y - (itemWidth - self.ballWidth - 1), itemWidth, itemWidth)];
}


//计算在windows上的坐标
- (CGPoint)getBigImageInSelectRect:(CGPoint)selectLocation {
    CGPoint resultPoint = CGPointZero;
    //计算Y的高度
    CGRect selfPoint = [self convertRect:[UIScreen mainScreen].bounds toView:nil];
    resultPoint.y = selectLocation.y + selfPoint.origin.y - self.ballWidth / 2;
    resultPoint.x = selectLocation.x + selfPoint.origin.x - self.ballWidth / 2;
    if (selectLocation.x == 0 && selectLocation.y == 0) {
        return CGPointZero;
    }
    return resultPoint;
}

- (void)addBigSelectImageWihtNumber:(NSInteger)selectNumber location:(CGPoint)location {
    UIImageView *backImage = nil;
    UILabel *label = nil;
    if (![[[UIApplication sharedApplication] keyWindow] viewWithTag:999]) {
        backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BetRedBallPressed.png"]];
        backImage.tag = 999;
        backImage.alpha = 1;
        [[UIApplication sharedApplication].delegate.window addSubview:backImage];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, - 3, self.ballWidth * 1.7, self.ballWidth * 1.7)];
        label.tag = 888;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:25];
        [backImage addSubview:label];
    }else {
        backImage = [[[UIApplication sharedApplication] keyWindow] viewWithTag:999];
        label = [[[UIApplication sharedApplication] keyWindow] viewWithTag:888];
    }
    backImage.frame = CGRectMake(location.x + (self.ballWidth / 8) + 1 , location.y - self.ballWidth + 2, (self.ballWidth * 1.7), (self.ballWidth * 1.7) * 1.5);
    label.text = [NSString stringWithFormat:@"%ld",selectNumber];
    
}


- (NSMutableArray *)numberRectArray {
    if (!_numberRectArray) {
        _numberRectArray = [NSMutableArray array];
        //每一块内容的大小
        itemWidth = self.frame.size.width / self.column;
        NSInteger lineNumber = -1;
        for (NSInteger i = 0; i < self.numberArray.count; i++) {
            NSInteger columnNumber = i % self.column;
            //判断是几行
            if (columnNumber == 0) lineNumber++;
            
            //通过自身控件的宽和高以及列数计算每一个块内容的位置
            CGFloat columnX = columnNumber * itemWidth + ((itemWidth - self.ballWidth) / 2);
            CGFloat lineY = lineNumber * itemWidth + ((itemWidth - self.ballWidth) / 2);
            
            CGRect rect = CGRectMake(columnX, lineY, self.ballWidth, self.ballWidth);
            [_numberRectArray addObject:NSStringFromCGRect(rect)];
        }
    }
    return _numberRectArray;
}

- (CGRect)getRectWithTouch:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    //点击后取得在 view 上的坐标点
    CGPoint locationSelf = [touch locationInView:self];
    if (locationSelf.y >= 0 && locationSelf.y <= self.frame.size.height) {
        for (NSString *rectStr in self.numberRectArray) {
            CGRect rect = CGRectFromString(rectStr);
            CGPathRef pathRef = CGPathCreateWithRect(rect, NULL);
            if (CGPathContainsPoint(pathRef, NULL, locationSelf, NO)) {
                return rect;
            }
        }
    }
    return  CGRectZero;
}

- (NSMutableSet *)selectNumberSet {
    if (!_selectNumberSet) {
        _selectNumberSet = [NSMutableSet set];
    }
    return _selectNumberSet;
}

- (void)setCanClick:(BOOL)canClick {
    _canClick = canClick;
    self.userInteractionEnabled = canClick;
}

@end
