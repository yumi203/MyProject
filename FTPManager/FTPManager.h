//
//  FTPManager.h
//  UpLoadFTP
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FTPStep) {
    FTPStepCheckDir              = 0,
    FTPStepCreateDir                ,
    FTPStepCheckHasIni              ,
    FTPStepUpLoadIni                ,
    FTPStepDownIniAndReadIni        ,
    FTPStepUpLoadLog
};

@interface FTPManager : NSObject

- (instancetype)initWithServer:(NSString *)server user:(NSString *)user password:(NSString *)password directory:(NSString *)directory;

@end

@interface CManager : NSObject

//用来记录目录的引用计数
@property (nonatomic, assign) NSInteger dirNum;
//用来记录是否跳转的标记
@property (nonatomic, assign) BOOL flag;
//用来记录创建目录的url
@property (nonatomic, strong) NSMutableArray *urlArray;
//用来存储所有的url
@property (nonatomic, strong) NSMutableArray *tempArray;
//保存ini的路径方便下载
@property (nonatomic, strong) NSString *iniPath;

- (void)clean;


@end
