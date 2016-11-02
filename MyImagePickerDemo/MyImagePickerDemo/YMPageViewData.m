//
//  YMPageViewData.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/2.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMPageViewData.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation YMPageViewData

+ (YMPageViewData *)sharedInstance
{
    static dispatch_once_t onceToken;
    static YMPageViewData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[YMPageViewData alloc] init];
    });
    return sSharedInstance;
}

- (NSUInteger)photoCount
{
    return self.photoAssets.count;
}

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    ALAsset *photoAsset = self.photoAssets[index];
    
    ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
    
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                   scale:[assetRepresentation scale]
                                             orientation:UIImageOrientationUp];
    return fullScreenImage;
}



@end
