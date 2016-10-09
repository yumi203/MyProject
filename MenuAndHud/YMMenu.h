//
//  YMMenu.h
//  sportsm
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MenuType) {
    MenuTypeTableView            = 0,
    MenuTypeCollectionView          ,
};


@interface YMMenu : UIView
//显示方法
+ (void)showMenuWithArray:(NSArray *)listArray superView:(UIView *)superView menuType:(MenuType)type clickRow:(void (^)(NSInteger row))block;

@end

@interface CellOfContent : UICollectionViewCell

@property (nonatomic, strong) UILabel *contentLabel;

@end

