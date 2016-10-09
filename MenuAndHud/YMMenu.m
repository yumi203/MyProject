//
//  YMMenu.m
//  sportsm
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import "YMMenu.h"

#define TableViewRowHeight 40
#define CollectionViewItemCount 4.0f
#define CollectionViewItemHeight 20
#define CollectionViewMargin 10
#define CollectionViewItemWidth ([UIScreen mainScreen].bounds.size.width - CollectionViewMargin - CollectionViewItemCount * CollectionViewMargin) / CollectionViewItemCount

//设置颜色RGB
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//取#rgb值设置颜色
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YMMenu () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) MenuType type;
@property (nonatomic, copy) void (^block)(NSInteger);
@property (nonatomic, strong) UIButton *backGroundButton;
@property (nonatomic, assign) CGRect menuFrame;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation YMMenu

#pragma mark - 显示的方法

+ (void)showMenuWithArray:(NSArray *)listArray superView:(UIView *)superView menuType:(MenuType)type clickRow:(void (^)(NSInteger))block {
    YMMenu * instance= [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    instance.listArray = listArray;
    instance.type = type;
    instance.block = block;
    
    UIWindow *window =[[[UIApplication sharedApplication] delegate] window];
    [window addSubview:instance];
    
    CGRect rect = [superView convertRect:superView.bounds toView:window];
    CGFloat menuX, menuY, menuW, menuH;
    menuX = 0;
    menuY = rect.origin.y + rect.size.height;
    menuW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    menuH = screenHeight - menuY - 10;
    if (type == MenuTypeTableView) {
        if (menuH > listArray.count * TableViewRowHeight) {
            menuH = listArray.count * TableViewRowHeight;
        }
    }else {
        CGFloat tempHieght = ceil((listArray.count / CollectionViewItemCount)) * (CollectionViewItemHeight + CollectionViewMargin) + CollectionViewMargin;
        if (menuH > tempHieght) {
            menuH = tempHieght;
        }
    }
    instance.menuFrame = CGRectMake(menuX, menuY, menuW, menuH);

    instance.clipsToBounds = YES;
}

#pragma mark - 懒加载
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addSubview:self.backGroundButton];
}
//设置menu的frame的时候把对应类型的空间添加到视图上，并且初始化
- (void)setMenuFrame:(CGRect)menuFrame {
    _menuFrame = menuFrame;
    if (_type == MenuTypeTableView) {
        if (!_tableView) {
            [self addSubview:self.tableView];
        }
    }else {
        if (!_collectionView) {
            [self addSubview:self.collectionView];
        }
    }
}

//collectionView初始化
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(CollectionViewItemWidth, CollectionViewItemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = CollectionViewMargin;
        layout.minimumInteritemSpacing = CollectionViewMargin;
        layout.sectionInset = UIEdgeInsetsMake(CollectionViewMargin, CollectionViewMargin, CollectionViewMargin, CollectionViewMargin);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.menuFrame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = kUIColorFromRGB(0xf5f5f5);;
        
        [_collectionView registerClass:[CellOfContent class] forCellWithReuseIdentifier:NSStringFromClass([CellOfContent class])];

    }
    return _collectionView;
}

//tableView初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.menuFrame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = TableViewRowHeight;
        //去掉多余的分区
        [_tableView setTableFooterView:[[UIView alloc] init]];
        //取消分割线左侧的15像素
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.backgroundColor = kUIColorFromRGB(0xf5f5f5);
    }
    return _tableView;
}
//取消分割线左侧的15像素
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}
//懒加载背景的button
- (UIButton *)backGroundButton {
    if (!_backGroundButton) {
        _backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backGroundButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_backGroundButton addTarget:self action:@selector(hiddenMenu) forControlEvents:UIControlEventTouchUpInside];
        //设置把颜色设置成一个半透明的图片减少内存消耗
        UIImage *backImage = [self createImageWithColor:[UIColor colorWithWhite:0.000 alpha:0.2]];
        [_backGroundButton setBackgroundImage:backImage forState:UIControlStateNormal];
    }
    return _backGroundButton;
}

- (void)hiddenMenu {
    [self removeFromSuperview];
}

#pragma mark - 根据颜色创建图片
//给背景的button生成透明图片使用的方法
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

#pragma mark - CollectionViewDelegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellOfContent *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CellOfContent class]) forIndexPath:indexPath];
    cell.contentLabel.text = self.listArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.block(indexPath.row);
    [self hiddenMenu];
}

#pragma mark - TableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    cell.backgroundColor = kUIColorFromRGB(0xf5f5f5);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.block(indexPath.row);
    [self hiddenMenu];
}

@end



@implementation CellOfContent

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addSubview:self.contentLabel];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:(CGRect){.size = self.frame.size}];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.layer.borderColor = [UIColor grayColor].CGColor;
        _contentLabel.layer.borderWidth = 1;
        _contentLabel.layer.cornerRadius = self.frame.size.height / 2.0f;
        _contentLabel.layer.masksToBounds = YES;
        
    }
    return _contentLabel;
}



@end
