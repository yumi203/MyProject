//
//  YMPhotoCell.h
//  MyImagePickerDemo
//
//  Created by YuMing on 16/10/31.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;
@class YMPhotoCell;

@protocol YMPhotoCellDelegate <NSObject>

- (void)handleSelectImage:(YMPhotoCell *)cell isSelect:(BOOL)select asset:(ALAsset *)asset;

@end


@interface YMPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) id <YMPhotoCellDelegate>delegate;

@end
