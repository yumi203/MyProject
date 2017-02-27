//
//  NSDate+Extension.m
//  HLJSportsLottery
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 俞明. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
static NSDateFormatter *formatter_;
static  NSCalendar *calendar_;

- (BOOL)isToday
{
    formatter_.dateFormat = @"yyyyMMdd";
    
    NSString *selfDay = [formatter_ stringFromDate:self];
    NSString *nowDay = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfDay isEqualToString:nowDay];
}

- (BOOL)isYesterday
{
    formatter_.dateFormat = @"yyyyMMdd";
    
    NSString *selfDay = [formatter_ stringFromDate:self];
    NSString *nowDay = [formatter_ stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [formatter_ dateFromString:selfDay];
    NSDate *nowDate = [formatter_ dateFromString:nowDay];
    
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmp = [calendar_ components:units fromDate:nowDate toDate:selfDate options:0];
    
    return cmp.year == 0 && cmp.month == 0 && cmp.day == 1;
}

- (BOOL)isTomorrow
{
    formatter_.dateFormat = @"yyyyMMdd";
    
    NSString *selfDay = [formatter_ stringFromDate:self];
    NSString *nowDay = [formatter_ stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [formatter_ dateFromString:selfDay];
    NSDate *nowDate = [formatter_ dateFromString:nowDay];
    
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmp = [calendar_ components:units fromDate:nowDate toDate:selfDate options:0];
    
    return cmp.year == 0 && cmp.month == 0 && cmp.day == -1;
}

- (BOOL)isThisYear
{
    formatter_.dateFormat = @"yyyy";
    NSString *selfYear = [formatter_ stringFromDate:self];
    NSString *currentYear = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfYear isEqualToString:currentYear];
}
- (BOOL)isInOneMinute
{
    formatter_.dateFormat = @"yyyyMMddHHmm";
    
    NSString *selfSecond = [formatter_ stringFromDate:self];
    NSString *nowSecond = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfSecond isEqualToString:nowSecond];
}

- (BOOL)isInOneHour
{
    formatter_.dateFormat = @"yyyyMMddHH";
    
    NSString *selfHour = [formatter_ stringFromDate:self];
    NSString *nowHour = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfHour isEqualToString:nowHour];
    
}

/*
 *  时间戳
 */
-(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}

/*
 *  时间成分
 */
-(NSDateComponents *)components{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit= NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self];
}
/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    return components;
}
/**
 *  将date转换成字符串(将有/无时差的date转换成字符串)
 */
- (NSString *)timeStringFormatString:(NSString *)formatString
                      timeDifference:(BOOL)difference{
    //实例化时间格式化工具
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //定义格式
    [format setDateFormat:formatString];
    if (difference) //有时差
        return [format stringFromDate:self];
    //无时差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger fromInterval = [zone secondsFromGMTForDate:self];
    NSDate *toDate = [self dateByAddingTimeInterval:-(fromInterval)];
    return [format stringFromDate:toDate];
    
}
@end
