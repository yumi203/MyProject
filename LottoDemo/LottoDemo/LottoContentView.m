//
//  LottoContentView.m
//  LottoDemo
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "LottoContentView.h"

#define kItemWidth 24
#define kLeftViewWidth 40

@interface LottoContentView ()

@property (nonatomic, strong) NSArray *listArray;

@end

@implementation LottoContentView

- (instancetype)initWithContentArray:(NSArray<NSDictionary *> *)listArray {
    self.contentSize = CGSizeMake(kLeftViewWidth + 1 + (kItemWidth + 1) * [[[listArray lastObject] objectForKey:@"number"] count], kItemWidth * listArray.count);
    self = [super initWithFrame:(CGRect){.size = self.contentSize}];
    if (self) {
        self.listArray = listArray;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    NSMutableArray *tempPeriodsArray = [NSMutableArray array];
    
    NSInteger index = 0;
    for (NSDictionary *numberdic in self.listArray) {
        //创建多行内容
        NumberView *nView = [[NumberView alloc] initWithNumberArray:[numberdic objectForKey:@"number"] awardArray:[numberdic objectForKey:@"award"] color:[numberdic objectForKey:@"color"]];
        nView.frame = CGRectMake(kLeftViewWidth,index * kItemWidth, 1 + (kItemWidth + 1) * [[numberdic objectForKey:@"number"] count], kItemWidth);
        nView.backgroundColor = index % 2 == 0 ? [UIColor greenColor] : [UIColor yellowColor];
        [self addSubview:nView];
        //获取期数
        [tempPeriodsArray addObject:[numberdic objectForKey:@"periods"]];
        
        index++;
    }
    
    self.periodsView = [[NumberPeriodsView alloc] initWithPeriodsArray:tempPeriodsArray];
    self.periodsView.frame = CGRectMake(0, 0, kLeftViewWidth, kItemWidth * tempPeriodsArray.count);
    [self addSubview:self.periodsView];    

}

@end

@interface NumberView ()

@property (nonatomic, strong) NSArray *numberArray;
@property (nonatomic, strong) NSArray *awardArray;
@property (nonatomic, strong) NSString *color;

@end

@implementation NumberView

- (instancetype)initWithNumberArray:(NSArray *)numberArray awardArray:(NSArray *)awardArray color:(NSString *)color {
    self = [super init];
    if (self) {
        self.numberArray = numberArray;
        self.awardArray = awardArray;
        self.color = color;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    NSInteger index = 0;
    NSInteger selectIndex = 0;
    for (NSString *number in self.numberArray) {
        //文字的label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1 + index * kItemWidth + 1 * index, 0, kItemWidth, kItemWidth)];
        
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = number;
        label.textColor = [UIColor grayColor];
        //竖着的分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1 + kItemWidth + index * kItemWidth + 1 * index, 0, 1, kItemWidth)];
        [self addSubview:line];
        line.backgroundColor = [UIColor grayColor];
        if (index == [self.awardArray[selectIndex] integerValue]) {
            label.text = self.awardArray[selectIndex];
            label.textColor = [UIColor whiteColor];
            UIImage *colorImage = [self.color isEqualToString:@"red"] ? [UIImage imageNamed:@"hall_ball_red"] : [UIImage imageNamed:@"hall_ball_bule"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1 + index * kItemWidth + 1 * index, 0, kItemWidth, kItemWidth)];
            imageView.image = colorImage;
//            imageView.layer.cornerRadius = kItemWidth / 2.0f;
//            imageView.clipsToBounds = YES;
            [self addSubview:imageView];
            if (selectIndex < 4) {
                selectIndex++;
            }            
        }
        [self addSubview:label];
        index++;
    }
}

@end

@interface NumberPeriodsView ()

@property (nonatomic, strong) NSArray *periodsArray;

@end

@implementation NumberPeriodsView

- (instancetype)initWithPeriodsArray:(NSArray *)periodsArray {
    self = [super init];
    if (self) {
        self.periodsArray = periodsArray;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    NSInteger index = 0;
    for (NSString *periods in self.periodsArray) {
        //使用CALayer的创建方式相同内容速度是58.982968 ms 内存占用4M
//        CATextLayer * textLayer = [CATextLayer layer];
//        NSString * text = [NSString stringWithFormat:@"%@期", periods];
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
//        
//        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
//        para.alignment = NSTextAlignmentCenter;
//        
//        NSDictionary *attributeDict = @{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1], NSParagraphStyleAttributeName : para};
//        [attrStr setAttributes:attributeDict range:NSMakeRange(0, attrStr.length)];
//        textLayer.string = attrStr;
//        
//        //图层的大小(宽度固定根据文字定高度)
//        CGRect strRect = [attrStr boundingRectWithSize:CGSizeMake(kItemWidth, kItemWidth) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
//        textLayer.bounds = CGRectMake(0, 0, strRect.size.width, strRect.size.height + 5);//文本大小,默认是0
//        textLayer.alignmentMode = @"center";//文字对齐方式
//        textLayer.contentsScale = [UIScreen mainScreen].scale;//清晰度
//        textLayer.position = CGPointMake(0,index * kItemWidth);//位置
//        [self.layer addSublayer:textLayer];
//        普通控件创建方式相同内容速度是用时50.136983 ms内存占用4.7M
                //文字的label
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,index * kItemWidth, kLeftViewWidth, kItemWidth)];
                [self addSubview:label];
                label.text = [NSString stringWithFormat:@"%@期", periods];
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = index % 2 == 0 ? [UIColor greenColor] : [UIColor yellowColor];
        
                //竖着的线
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kLeftViewWidth - 1, index * kItemWidth, 1, kItemWidth)];
                [self addSubview:line];
                line.backgroundColor = [UIColor grayColor];
        
        index++;
    }
}

@end

