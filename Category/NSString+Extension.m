//
//  NSString+Extension.m
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 俞明. All rights reserved.
//
#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Extension)

/**
 *  快速返回沙盒中，Documents文件的路径
 *
 *  @return Documents文件的路径
 */
+ (NSString *)pathForDocuments
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  快速返回Documents文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Documents文件中某个子文件的路径
 */
+ (NSString *)filePathAtDocumentsWithFileName:(NSString *)fileName
{
    return  [[self pathForDocuments] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回沙盒中Library下Caches文件的路径
 *
 *  @return 快速返回沙盒中Library下Caches文件的路径
 */
+ (NSString *)pathForCaches
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)filePathAtCachesWithFileName:(NSString *)fileName
{
    return [[self pathForCaches] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回MainBundle(资源捆绑包的)的路径
 *
 *  @return 快速返回MainBundle(资源捆绑包的)的路径
 */
+ (NSString *)pathForMainBundle
{
    return [NSBundle mainBundle].bundlePath;
}

/**
 *  快速返回MainBundle(资源捆绑包的)下文件的路径
 *
 *  @param fileName MainBundle(资源捆绑包的)下的文件名
 *
 *  @return 快速返回MainBundle(资源捆绑包的)下文件的路径
 */
+ (NSString *)filePathAtMainBundleWithFileName:(NSString *)fileName
{
    return [[self pathForMainBundle] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回沙盒中tmp(临时文件)文件的路径
 *
 *  @return 快速返回沙盒中tmp文件的路径
 */
+ (NSString *)pathForTemp
{
    return NSTemporaryDirectory();
}

/**
 *  快速返回沙盒中，temp文件中某个子文件的路径
 *
 *  @param fileName 子文件名
 *
 *  @return 快速返回temp文件中某个子文件的路径
 */
+ (NSString *)filePathAtTempWithFileName:(NSString *)fileName
{
    return [[self pathForTemp] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回沙盒中，Library下Preferences文件的路径
 *
 *  @return 快速返回沙盒中Library下Caches文件的路径
 */
+ (NSString *)pathForPreferences
{
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  快速返回沙盒中，Library下Preferences文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Preferences文件中某个子文件的路径
 */
+ (NSString *)filePathAtPreferencesWithFileName:(NSString *)fileName
{
    return [[self pathForPreferences] stringByAppendingPathComponent:fileName];
}

/**
 *  快速你指定的系统文件的路径
 *
 *  @param directory NSSearchPathDirectory枚举
 *
 *  @return 快速你指定的系统文件的路径
 */
+ (NSString *)pathForSystemFile:(NSSearchPathDirectory)directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
}

/**
 *  快速返回沙盒中，你指定的系统文件的中某个子文件的路径。tmp文件除外，请使用filePathAtTempWithFileName
 *
 *  @param directory 你指的的系统文件
 *  @param fileName  子文件名
 *
 *  @return 快速返回沙盒中，你指定的系统文件的中某个子文件的路径
 */
+ (NSString *)filePathForSystemFile:(NSSearchPathDirectory)directory withFileName:(NSString *)fileName
{
    return [[self pathForSystemFile:directory] stringByAppendingPathComponent:fileName];
}

/**
 *  快速计算出文本的真实尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    NSDictionary *arrts = @{NSFontAttributeName:font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
}

/**
 *  快速计算出文本的真实尺寸
 *
 *  @param text    需要计算尺寸的文本
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    return [text sizeWithFont:font andMaxSize:maxSize];
}


- (BOOL)checkNumber {
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPredicate evaluateWithObject:self];
}

//正则判断手机号码格式

- (BOOL)checkPhone {
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:self] == YES)
//        || ([regextestcm evaluateWithObject:self] == YES)
//        || ([regextestct evaluateWithObject:self] == YES)
//        || ([regextestcu evaluateWithObject:self] == YES))
//    {
//        if([regextestcm evaluateWithObject:self] == YES) {
//            NSLog(@"China Mobile");
//        } else if([regextestct evaluateWithObject:self] == YES) {
//            NSLog(@"China Telecom");
//        } else if ([regextestcu evaluateWithObject:self] == YES) {
//            NSLog(@"China Unicom");
//        } else {
//            NSLog(@"Unknow");
//        }
//        
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phonePredicate evaluateWithObject:self];
}


- (BOOL)checkRealName {
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,4}$";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [nicknamePredicate evaluateWithObject:self];
}

//昵称
- (BOOL)checkNickname {
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5\\w]{4,20}$";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [nicknamePredicate evaluateWithObject:self];
    
}

//身份证号
- (BOOL)checkIdentityCard {
    if (self.length <= 0)
        return NO;
    
    NSString *identityCardRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityCardRegex];
    return [identityCardPredicate evaluateWithObject:self];
}

//邮箱
- (BOOL)checkEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:self];

}

//邮编
- (BOOL)checkPostcode{
    NSString *postcodeRegex = @"^[1-9]\\d{5}$";
    NSPredicate *postcodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",postcodeRegex];
    return [postcodePredicate evaluateWithObject:self];
}
//验证钱
- (BOOL)checkMoney {
    NSString *moenyRegex = @"^[1-9]\\d{5}$";
    NSPredicate *moenyPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moenyRegex];
    return [moenyPredicate evaluateWithObject:self];
}

//验证密码是否是6-20位必须包含数字以及字母
- (BOOL)checkPassword {
    NSString *passwordRegex = @"^([a-zA-Z0-9]){6,20}$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:self];
}


/** 删除所有的空格 */
-(NSString *)deleteSpace{
    
    NSMutableString *strM = [NSMutableString stringWithString:self];
    
    [strM replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, strM.length)];
    
    return [strM copy];
}



/**
 *  32位MD5加密
 */
-(NSString *)MD5{
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}

/**
 *  SHA1加密
 */
-(NSString *)SHA1{
    
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}

- (UIImage *)QRcode {
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:self] withSize:200.0f];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    return customQrcode;
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)
        {
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

//转换时区
+ (NSInteger)zoneFromDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return [zone secondsFromGMTForDate:date];
}

/*
 *  时间戳对应的NSDate
 */
- (NSDate *)dateFromInterval{
    NSTimeInterval timeInterval = [self integerValue];
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

/**
 *  根据格式返回当前的时间字符串
 */
- (NSString *)formatNowTime {
    return [[self class] timeStringFromDate:[NSDate date] formatString:self timeDifference:YES];
}

/**
 *  将date转换成字符串(将有/无时差的date转换成字符串)
 */
+ (NSString *)timeStringFromDate:(NSDate *)date
                    formatString:(NSString *)formatString
                  timeDifference:(BOOL)difference{
    //实例化时间格式化工具
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //定义格式
    [format setDateFormat:formatString];
    if (difference) //有时差
        return [format stringFromDate:date];
    //无时差
    NSInteger fromInterval = [self zoneFromDate:date];
    NSDate *toDate = [date dateByAddingTimeInterval:-(fromInterval)];
    return [format stringFromDate:toDate];
    
}
/**
 *  时间戳转格式化的时间字符串(有/无时间差)
 */
- (NSString *)timestampToTimeStringWithFormatString:(NSString *)formatString
                                     timeDifference:(BOOL)difference{
    //时间戳转date
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    return [[self class] timeStringFromDate:date formatString:formatString timeDifference:difference];
}




/**
 *  距离时间戳中的时间经过了或者还剩多少天
 */
- (NSInteger)dayFromTimestamp {
    NSDate *fromDate = self.dateFromInterval;
    //取得当前时间的date
    NSDate *nowDate = [NSDate date];
    //进行日期比较
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;//返回的类型，只返回天
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:nowDate options:NSCalendarWrapComponents];
    return [components day];
}
/**
 *  不指定格式的时间字符串转换成(无时差)NSDate
 */
- (NSDate *)dateFromString {
    NSString *fromatString = nil;
    //如果有时间
    if ([self containsString:@":"]) {
        if ([self containsString:@"-"]) {
            fromatString = @"yyyy-MM-dd HH:mm:ss";
        }else if([self containsString:@"/"]) {
            fromatString = @"yyyy/MM/dd HH:mm:ss";
        }else if([self containsString:@"年"]){
            fromatString = @"yyyy年MM月dd日HH:mm:ss";
        }else if(self.length > 8) {
            fromatString = @"yyyyMMddHHmmss";
        }else if(self.length == 8){//没有年
            fromatString = @"HH:mm:ss";
        }else {
            fromatString = @"HHmmss";
        }
    }else {//没有时间
        if ([self containsString:@"-"]) {
            fromatString = @"yyyy-MM-dd";
        }else if([self containsString:@"/"]) {
            fromatString = @"yyyy/MM/dd";
        }else if([self containsString:@"年"]){
            fromatString = @"yyyy年MM月dd日";
        }else {
            fromatString = @"yyyyMMdd";
        }
    }
    
    return [self dateFromStringWithFormatString:fromatString];
}
/**
 *  时间字符串转换成(无时差)NSDate
 */
- (NSDate *)dateFromStringWithFormatString:(NSString *)formatString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    //根据格式取得字符串的date
    NSDate *fromDate = [format dateFromString:self];
    //转换时区
    NSInteger fromInterval = [[self class] zoneFromDate:fromDate];
    //取得转换时区后的date
    NSDate *toDate = [fromDate dateByAddingTimeInterval:fromInterval];
    return toDate;
}
/**
 *  距离字符串中的时间经过了或者还剩多少天
 */
- (NSInteger)dayFromStringWithFormatString:(NSString *)formatString{
    //取得字符串的date
    NSDate *fromDate = [self dateFromStringWithFormatString:formatString];
    
    //取得当前时间的date
    NSDate *nowDate = [NSDate date];
    //转换时区
    NSInteger interval = [[self class] zoneFromDate:nowDate];
    //取得转换时区后的date
    NSDate *localeDate = [nowDate dateByAddingTimeInterval:interval];
    
    //进行日期比较
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;//返回的类型，只返回天
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:NSCalendarWrapComponents];
    
    return [components day];
}

@end