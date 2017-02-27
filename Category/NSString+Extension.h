//
//  NSString+Extension.h
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 俞明. All rights reserved.
//
/*
 描述：提供了快速计算路径的方法
      提供了快速计算文本尺寸的方法
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
#pragma mark - 文本计算方法
/**
 *  快速计算出文本的真实尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

/**
 *  快速计算出文本的真实尺寸
 *
 *  @param text    需要计算尺寸的文本
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

#pragma mark - 验证文字信息
/**
 *  @author 俞明, 16-10-26 09:10:15
 *
 *  是否是纯数字
 */
@property (nonatomic, assign, readonly) BOOL checkNumber;
/**
 *  @author 俞明, 16-10-26 09:10:11
 *
 *  手机号
 */
@property (nonatomic, assign, readonly) BOOL checkPhone;
/**
 *  @author 俞明, 16-10-26 09:10:07
 *
 *  真实姓名
 */
@property (nonatomic, assign, readonly) BOOL checkRealName;
/**
 *  @author 俞明, 16-10-26 09:10:03
 *
 *  昵称
 */
@property (nonatomic, assign, readonly) BOOL checkNickname;
/**
 *  @author 俞明, 16-10-26 09:10:55
 *
 *  身份证号
 */
@property (nonatomic, assign, readonly) BOOL checkIdentityCard;
/**
 *  @author 俞明, 16-10-26 09:10:51
 *
 *  邮箱
 */
@property (nonatomic, assign, readonly) BOOL checkEmail;
/**
 *  @author 俞明, 16-10-26 09:10:46
 *
 *  验证密码
 */
@property (nonatomic, assign, readonly) BOOL checkPassword;
/**
 *  @author 俞明, 16-10-26 09:10:41
 *
 *  删除所有的空格
 */
@property (nonatomic,copy,readonly) NSString *deleteSpace;
/**
 *  @author 俞明, 16-10-26 09:10:31
 *
 *  邮编
 */
@property (nonatomic, assign, readonly) BOOL checkPostcode;
/**
 *  金钱效验
 */
@property (nonatomic, assign, readonly) BOOL checkMoney;

/**
 *  32位MD5加密
 */
@property (nonatomic,copy,readonly) NSString *MD5;
/**
 *  SHA1加密
 */
@property (nonatomic,copy,readonly) NSString *SHA1;
/**
 *  二维码
 */
@property (nonatomic, strong, readonly) UIImage *QRcode;

#pragma NSDate类
/*
 *  时间戳对应的NSDate
 */
@property (nonatomic,strong,readonly) NSDate *dateFromInterval;

/**
 *  （根据格式）返回当前的时间字符串
 */
@property (nonatomic,strong,readonly) NSString *formatNowTime;
/**
 *  将date转换成字符串(将有/无时差的date转换成字符串)
 *
 *  @param date         日期
 *  @param formatString 格式
 *  @param difference   是否有时间差 YES有时差/NO无时差
 *  默认为YES有时差
 */
+ (NSString *)timeStringFromDate:(NSDate *)date
                    formatString:(NSString *)formatString
                  timeDifference:(BOOL)difference;

/**
 *  时间戳转格式化的时间字符串(有/无时间差)
 *
 *  @param formatString 格式
 *  @param difference   是否有时间差 YES有时差/NO无时差
 *  默认为YES有时差
 */
- (NSString *)timestampToTimeStringWithFormatString:(NSString *)formatString
                                     timeDifference:(BOOL)difference;

/**
 *  时间字符串转换成NSDate(无时差)
 *
 *  @param formatString 字符串中的日期格式
 *  如：@"EEE, d MMM yyyy HH:mm:ss Z"
 *
 *  公元时代，例如AD公元
 *  yy: 年的后2位
 *  yyyy: 完整年
 *  MM: 月，显示为1-12
 *  MMM: 月，显示为英文月份简写,如 Jan
 *  MMMM: 月，显示为英文月份全称，如 Janualy
 *  dd: 日，2位数表示，如02
 *  d: 日，1-2位显示，如 2
 *  EEE: 简写星期几，如Sun
 *  EEEE: 全写星期几，如Sunday
 *  aa: 上下午，AM/PM
 *  H: 时，24小时制，0-23
 *  K：时，12小时制，0-11
 *  m: 分，1-2位
 *  mm: 分，2位
 *  s: 秒，1-2位
 *  ss: 秒，2位
 *  S: 毫秒
 *  常用日期结构：
 *  yyyy-MM-dd HH:mm:ss.SSS
 *  yyyy-MM-dd HH:mm:ss
 *  yyyy-MM-dd
 *  MM dd yyyy
 *  Z是时区
 *  例:
 *  2016-11-10 11:19:16 formatString格式为 @"yyyy-MM-dd HH:mm:ss"
 *  20161110111924 formatString格式为 @"yyyyMMddHHmmss"
 *  201697111924   formatString格式为 @"yyyyMdHHmmss"
 *
 */
- (NSDate *)dateFromStringWithFormatString:(NSString *)formatString;
/**
 *  距离时间戳中的时间经过了或者还剩多少天
 */
- (NSInteger)dayFromTimestamp;
/**
 *  不指定格式的时间字符串转换成(无时差)NSDate
 */
- (NSDate *)dateFromString;
/**
 *  距离字符串中的时间经过了或者还剩多少天
 */
- (NSInteger)dayFromStringWithFormatString:(NSString *)formatString;


#pragma mark - 路径方法
/**
 *  快速返回沙盒中，Documents文件的路径
 *
 *  @return Documents文件的路径
 */
+ (NSString *)pathForDocuments;
/**
 *  快速返回沙盒中，Documents文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Documents文件中某个子文件的路径
 */
+ (NSString *)filePathAtDocumentsWithFileName:(NSString *)fileName;
/**
 *  快速返回沙盒中，Library下Caches文件的路径
 *
 *  @return 快速返回沙盒中Library下Caches文件的路径
 */
+ (NSString *)pathForCaches;

/**
 *  快速返回沙盒中，Library下Caches文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Caches文件中某个子文件的路径
 */
+ (NSString *)filePathAtCachesWithFileName:(NSString *)fileName;

/**
 *  快速返回沙盒中，MainBundle(资源捆绑包的)的路径
 *
 *  @return 快速返回MainBundle(资源捆绑包的)的路径
 */
+ (NSString *)pathForMainBundle;

/**
 *  快速返回沙盒中，MainBundle(资源捆绑包的)中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回MainBundle(资源捆绑包的)中某个子文件的路径
 */
+ (NSString *)filePathAtMainBundleWithFileName:(NSString *)fileName;

/**
 *  快速返回沙盒中，tmp(临时文件)文件的路径
 *
 *  @return 快速返回沙盒中tmp文件的路径
 */
+ (NSString *)pathForTemp;

/**
 *  快速返回沙盒中，temp文件中某个子文件的路径
 *
 *  @param fileName 子文件名
 *
 *  @return 快速返回temp文件中某个子文件的路径
 */
+ (NSString *)filePathAtTempWithFileName:(NSString *)fileName;

/**
 *  快速返回沙盒中，Library下Preferences文件的路径
 *
 *  @return 快速返回沙盒中Library下Caches文件的路径
 */
+ (NSString *)pathForPreferences;

/**
 *  快速返回沙盒中，Library下Preferences文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Preferences文件中某个子文件的路径
 */
+ (NSString *)filePathAtPreferencesWithFileName:(NSString *)fileName;

/**
 *  快速返回沙盒中，你指定的系统文件的路径。tmp文件除外，tmp用系统的NSTemporaryDirectory()函数更加便捷
 *
 *  @param directory NSSearchPathDirectory枚举
 *
 *  @return 快速你指定的系统文件的路径
 */
+ (NSString *)pathForSystemFile:(NSSearchPathDirectory)directory;

/**
 *  快速返回沙盒中，你指定的系统文件的中某个子文件的路径。tmp文件除外，请使用filePathAtTempWithFileName
 *
 *  @param directory 你指的的系统文件
 *  @param fileName  子文件名
 *
 *  @return 快速返回沙盒中，你指定的系统文件的中某个子文件的路径
 */
+ (NSString *)filePathForSystemFile:(NSSearchPathDirectory)directory withFileName:(NSString *)fileName;

@end