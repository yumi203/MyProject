//
//  YMPhotoCell.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/10/31.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMPhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface YMPhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@end

@implementation YMPhotoCell

- (void)awakeFromNib {
    // Initialization code
    self.selectImage.userInteractionEnabled = YES;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (_isSelect) {
        self.selectImage.image = [UIImage imageNamed:@"select"];
    }else {
        self.selectImage.image = [UIImage imageNamed:@"unSelect"];
    }
}

- (void)setAsset:(ALAsset *)asset {
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    self.picImageView.image = thumbnail;
    _asset = asset;
}

- (IBAction)handleSelectButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleSelectImage:isSelect:asset:)]) {
        [self.delegate handleSelectImage:self isSelect:self.isSelect asset:self.asset];
    }

}



@end
