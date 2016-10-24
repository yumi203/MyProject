//
//  YMWebCacheProtocol.h
//  WebCacheDemo
//
//  Created by YuMing on 16/10/24.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMWebCacheProtocol : NSURLProtocol

+ (void)start;

/**
 *  @author 俞明, 16-10-24 10:10:10
 *
 *  控制缓存内容大小
 *
 *  @param countLimit         缓存应该保留的对象的最大数量。(对象数量也就是能存多少个)
 *  @param costLimit          缓存在开始逐出对象之前可以保持的最大总成本。(也就是最大可以存字节)
 *  @param ageLimit           缓存中对象的最大到期时间。(单个对象的到期时间)
 *  @param freeDiskSpaceLimit 自动修整检查时间间隔（以秒为单位）。 默认值为60（1分钟）。缓存保存一个内部定时器，以检查缓存是否达到其限制，如果达到限制，它将开始逐出对象。
 */
+ (void)changeCacheCountLimit:(NSInteger)countLimit costLimit:(NSInteger)costLimit ageLimit:(NSTimeInterval)ageLimit freeDiskSpaceLimit:(NSInteger)freeDiskSpaceLimit;

@end
