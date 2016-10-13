//
//  LottoView.m
//  LottoDemo2
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "LottoView.h"

#define kItemWidth 24
#define kLeftViewWidth 60
//期数
@interface NumberPeriodsView : UIView

- (instancetype)initWithPeriodsArray:(NSArray *)periodsArray;

@property (nonatomic, strong) NSArray *periodsArray;

@end
//中间内容
@interface NumberView : UIView

- (instancetype)initWithNumberArray:(NSArray *)numberArray;

@property (nonatomic, strong) NSArray *numberArray;

@end
//上层数字
@interface TopNumberView : UIView

- (instancetype)initWithNumber:(NSInteger)number;

@property (nonatomic, assign) NSInteger number;

@end
//下面能选择的数字

@interface BottomNumberView : UIView

- (instancetype)initWithNumber:(NSInteger)number;

@property (nonatomic, assign) NSInteger number;

@end
//上和下悬浮的View

@interface TopBottomView : UIView {
    BOOL hiddenFlag;
}

- (instancetype)initWithFrame:(CGRect)frame HiddenWrods:(BOOL)hidden;

@end
//全部内容的容器
@interface LottoView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NumberPeriodsView *periodsView;
@property (nonatomic, strong) TopNumberView *topView;
@property (nonatomic, strong) BottomNumberView *bottomView;

@end

#pragma mark - LottoView
@implementation LottoView

- (instancetype)initWithFrame:(CGRect)frame listArray:(NSArray<NSDictionary *> *)listArray {
    if (self = [super initWithFrame:frame]) {
        self.listArray = listArray;
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    self.backgroundColor = [UIColor redColor];
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kItemWidth, [UIScreen mainScreen].bounds.size.width, self.frame.size.height - kItemWidth * 2)];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor grayColor];
    }
    return _scrollView;
}

- (void)setListArray:(NSArray *)listArray {
    if (_listArray != listArray) {
        _listArray = listArray;
        //获取数据中是多少位数
        NSInteger numberCount = [[[listArray lastObject] objectForKey:@"number"] count];
        //不包括左侧期数内容的大小
        CGSize contentSize = CGSizeMake(numberCount * (kItemWidth + 1), kItemWidth * listArray.count);
        //设置scroll内容大小
        self.scrollView.contentSize = CGSizeMake(contentSize.width + kLeftViewWidth, contentSize.height);
        //内容
        NumberView *numView = [[NumberView alloc] initWithNumberArray:self.listArray];
        numView.frame = CGRectMake(kLeftViewWidth, 0, contentSize.width, contentSize.height);
        [self.scrollView addSubview:numView];
        
        //期数
        NSMutableArray *tempPeriodsArray = [NSMutableArray array];
        for (NSDictionary *dic in listArray) {
            //获取期数
            [tempPeriodsArray addObject:[dic objectForKey:@"periods"]];
        }
        self.periodsView = [[NumberPeriodsView alloc] initWithPeriodsArray:tempPeriodsArray];
        self.periodsView.frame = CGRectMake(0, 0, kLeftViewWidth, contentSize.height);
        [self.scrollView addSubview:self.periodsView];
        //通过懒加载创建TopView
        self.topView.frame = CGRectMake(kLeftViewWidth, 0, contentSize.width, kItemWidth);
        self.bottomView.frame = CGRectMake(kLeftViewWidth, CGRectGetMaxY(self.scrollView.frame), contentSize.width, kItemWidth);
        TopBottomView *top = [[TopBottomView alloc] initWithFrame:CGRectMake(0, 0, kLeftViewWidth, kItemWidth) HiddenWrods:YES];
        [self addSubview:top];
        TopBottomView *Bottom = [[TopBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), kLeftViewWidth, kItemWidth) HiddenWrods:NO];
        [self addSubview:Bottom];
        
        
    }
}
//懒加载上面的数字View
- (TopNumberView *)topView {
    if (!_topView) {
        //获取数据中是多少位数
        NSInteger numberCount = [[[self.listArray lastObject] objectForKey:@"number"] count];
        _topView = [[TopNumberView alloc] initWithNumber:numberCount];
        [self addSubview:_topView];
    }
    return _topView;
}
//懒加载下方点击的View
- (BottomNumberView *)bottomView {
    if (!_bottomView) {
        //获取数据中是多少位数
        NSInteger numberCount = [[[self.listArray lastObject] objectForKey:@"number"] count];
        _bottomView = [[BottomNumberView alloc] initWithNumber:numberCount];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

//用 bounces 属性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.x <= 0)) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }else if (scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width) {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, scrollView.contentOffset.y);
    }
    
    self.periodsView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0);
    self.topView.transform = CGAffineTransformMakeTranslation(- scrollView.contentOffset.x, 0);
    self.bottomView.transform = CGAffineTransformMakeTranslation(- scrollView.contentOffset.x, 0);
}

@end

#pragma mark - NumberPeriodsView
@implementation NumberPeriodsView

- (instancetype)initWithPeriodsArray:(NSArray *)periodsArray {
    if (self = [super init]) {
        self.periodsArray = periodsArray;
    }
    return self;
}
//使用drawRect的创建方式相同内容速度是用时2.101958 ms 内存占用4.3M 速度是普通创建方式的25倍
- (void)drawRect:(CGRect)rect {
    //获取上下文方法
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger index = 0;
    for (NSString *periods in self.periodsArray) {
        index % 2 == 0 ? CGContextSetRGBFillColor(context, 0.87, 0.5, 0.87, 1) : CGContextSetRGBFillColor(context, 0.87, 0.87, 0.5, 1);
        CGContextFillRect(context, CGRectMake(0,index * kItemWidth,kLeftViewWidth,kItemWidth));
        
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.alignment = NSTextAlignmentCenter;
        //+4是因为文字的上下间距没有居中
        [[NSString stringWithFormat:@"%@期",periods] drawInRect:CGRectMake(0,4 + index * kItemWidth,kLeftViewWidth,kItemWidth)
             withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1], NSParagraphStyleAttributeName : para}];
        index++;
    }
    NSInteger listCount = self.periodsArray.count;
    //画期数右侧线条
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);//线条颜色
    CGContextMoveToPoint(context, kLeftViewWidth - 1, 0);
    CGContextAddLineToPoint(context, kLeftViewWidth - 1, listCount * kItemWidth);
    //绘制线方法
    CGContextStrokePath(context);
}
@end

#pragma mark - NumberView
@implementation NumberView

- (instancetype)initWithNumberArray:(NSArray *)numberArray {
    if (self = [super init]) {
        self.numberArray = numberArray;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger index = 0;
    //数字的个数
    NSInteger listCount = [[self.numberArray[index] objectForKey:@"number"] count];
    for (NSDictionary *dic in self.numberArray) {
        //设置背景颜色
        index % 2 == 0 ? CGContextSetRGBFillColor(context, 0.87, 0.5, 0.87, 1) : CGContextSetRGBFillColor(context, 0.87, 0.87, 0.5, 1);
        CGContextFillRect(context, CGRectMake(0,index * kItemWidth,listCount * (kItemWidth + 1),kItemWidth));
        NSInteger numbIndex = 0;
        NSInteger selectIndex = 0;
        //绘制文字以及图片
        NSArray *numberArr = [dic objectForKey:@"number"];
        NSArray *awardArray = [dic objectForKey:@"award"];
        for (NSString *numStr in numberArr) {
            if (!(numbIndex == [awardArray[selectIndex] integerValue])) {
                NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
                para.alignment = NSTextAlignmentCenter;
                //+4是因为文字的上下间距没有居中
                [numStr drawInRect:CGRectMake(numbIndex * kItemWidth + 1 * numbIndex,4 + index * kItemWidth,kItemWidth,kItemWidth)
                    withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1], NSParagraphStyleAttributeName : para}];
            }else {
                [[UIColor colorWithRed:0.755 green:0.056 blue:0.081 alpha:1.000] set];
                CGContextFillEllipseInRect(context, CGRectMake(numbIndex * kItemWidth + 1 * numbIndex,index * kItemWidth, kItemWidth, kItemWidth));
                NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
                para.alignment = NSTextAlignmentCenter;
                //+4是因为文字的上下间距没有居中
                [numStr drawInRect:CGRectMake(numbIndex * kItemWidth + 1 * numbIndex,4 + index * kItemWidth,kItemWidth,kItemWidth)
                    withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName : para}];
                if (selectIndex < 4) {
                    selectIndex++;
                }
            }
            numbIndex++;
        }
        index++;
    }
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);//线条颜色
    for (NSInteger i = 0; i < listCount; i++) {
        //画期数竖着的线线条
        CGContextMoveToPoint(context,kItemWidth + i * kItemWidth + 1 * i, 0);
        CGContextAddLineToPoint(context,kItemWidth + i * kItemWidth + 1 * i, self.numberArray.count * kItemWidth);
    }
    CGContextStrokePath(context);
}

@end
#pragma mark - TopNumberView
@implementation TopNumberView

- (instancetype)initWithNumber:(NSInteger)number {
    if (self = [super init]) {
        self.number = number;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //获取上下文方法
    CGContextRef context = UIGraphicsGetCurrentContext();
    //填充背景颜色
    CGContextSetRGBFillColor(context, 0.87, 0.87, 0.5, 1);
    CGContextFillRect(context, CGRectMake(0,0,self.number * (kItemWidth + 1),kItemWidth));
    for (NSInteger i = 0; i < self.number; i++) {
        //画期数竖着的线线条
        CGContextMoveToPoint(context,kItemWidth + i * kItemWidth + 1 * i, 0);
        CGContextAddLineToPoint(context,kItemWidth + i * kItemWidth + 1 * i, kItemWidth);
    }
    //绘制数字
    for (NSInteger i = 0; i < self.number ; i++) {
        NSString *numStr = [NSString stringWithFormat:@"%ld",i];
        
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.alignment = NSTextAlignmentCenter;
        //+4是因为文字的上下间距没有居中
        [numStr drawInRect:CGRectMake(i * kItemWidth + 1 * i,4,kItemWidth,kItemWidth)
            withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1], NSParagraphStyleAttributeName : para}];
    }
   
    //绘制线方法
    CGContextStrokePath(context);
}

@end

#pragma mark - BottomNumberView
@implementation BottomNumberView

- (instancetype)initWithNumber:(NSInteger)number {
    if (self = [super init]) {
        self.number = number;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //获取上下文方法
    CGContextRef context = UIGraphicsGetCurrentContext();
    //填充背景颜色
    CGContextSetRGBFillColor(context, 0.87, 0.87, 0.5, 1);
    CGContextFillRect(context, CGRectMake(0,0,self.number * (kItemWidth + 1),kItemWidth));
    for (NSInteger i = 0; i < self.number; i++) {
        //画期数竖着的线线条
        CGContextMoveToPoint(context,kItemWidth + i * kItemWidth + 1 * i, 0);
        CGContextAddLineToPoint(context,kItemWidth + i * kItemWidth + 1 * i, kItemWidth);
    }
    //绘制数字
    for (NSInteger i = 0; i < self.number ; i++) {
        NSString *numStr = [NSString stringWithFormat:@"%ld",i];
        
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.alignment = NSTextAlignmentCenter;
        //+4是因为文字的上下间距没有居中
        [numStr drawInRect:CGRectMake(i * kItemWidth + 1 * i,4,kItemWidth,kItemWidth)
            withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1], NSParagraphStyleAttributeName : para}];
    }
    
    //绘制线方法
    CGContextStrokePath(context);
}

@end

#pragma mark - TopBottomView
@implementation TopBottomView

- (instancetype)initWithFrame:(CGRect)frame HiddenWrods:(BOOL)hidden {
    if (self = [super initWithFrame:frame]) {
        hiddenFlag = hidden;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //获取上下文方法
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制背景色
    CGContextSetRGBFillColor(context, 0.87, 0.87, 0.5, 1);
    CGContextFillRect(context, CGRectMake(0, 0, kLeftViewWidth, kItemWidth));

    if (!hiddenFlag) {
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.alignment = NSTextAlignmentCenter;
        //绘制下方文字
        //+4是因为文字的上下间距没有居中
        [@"选  号" drawInRect:CGRectMake(0, 4, kLeftViewWidth, kItemWidth)
             withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName : para}];
        //绘制方法
        CGContextStrokePath(context);

    }
    //绘制上方和下方末尾的分割线
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);//线条颜色
    CGContextMoveToPoint(context, kLeftViewWidth - 1, 0);
    CGContextAddLineToPoint(context, kLeftViewWidth - 1, kItemWidth);
    //绘制方法
    CGContextStrokePath(context);
}

@end
