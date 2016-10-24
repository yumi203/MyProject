//
//  YMWebCacheProtocol.m
//  WebCacheDemo
//
//  Created by YuMing on 16/10/24.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMWebCacheProtocol.h"
#import "YYCache.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround;

@end

@interface YMCachedData : NSObject <NSCoding>
@property (nonatomic, readwrite, strong) NSData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLRequest *redirectRequest;
@end


@interface YMWebCacheProtocol () // <NSURLConnectionDelegate, NSURLConnectionDataDelegate> iOS5-only
{
    BOOL useCache;
    NSString *cacheKey;
}

@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSMutableData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
- (void)appendData:(NSData *)newData;
@property (nonatomic, strong) YYCache *cache;
@end

@implementation YMWebCacheProtocol

//注册协议
+ (void)start {
    [NSURLProtocol registerClass:self];
    [self changeCacheCountLimit:INT_MAX costLimit:1024 * 1024 * 20 ageLimit:DBL_MAX freeDiskSpaceLimit:60];
}
+ (void)changeCacheCountLimit:(NSInteger)countLimit costLimit:(NSInteger)costLimit ageLimit:(NSTimeInterval)ageLimit freeDiskSpaceLimit:(NSInteger)freeDiskSpaceLimit {
    YYCache *cache = [[YYCache alloc] initWithName:@"YYCacheDB"];
    cache.diskCache.countLimit = countLimit;
    cache.diskCache.costLimit = costLimit;
    cache.diskCache.ageLimit = ageLimit;
    cache.diskCache.freeDiskSpaceLimit = freeDiskSpaceLimit;
}

//用来标记这次请求是否是我们拦截的如果是 则不进行处理
static NSString * kOurRecursiveRequestFlagProperty = @"com.MY.Des.HTTPProtocol";
//以下这个链接为host的网址不做处理
static NSString * kHostFlag = @"www.baidu.com";

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    BOOL        shouldAccept;
    NSURL *     url;
    NSString *  scheme;
    shouldAccept = (request != nil);
    if (shouldAccept) {
        url = [request URL];
        shouldAccept = (url != nil);
    }
    
    if (shouldAccept) {
        shouldAccept = ([self propertyForKey:kOurRecursiveRequestFlagProperty inRequest:request] == nil);
    }
    
    if (shouldAccept) {
        scheme = [[url scheme] lowercaseString];
        shouldAccept = (scheme != nil);
        shouldAccept = (![scheme  isEqual: @"https"]);
    }
    
    //    if (shouldAccept) {
    //        shouldAccept = ![[url host] isEqualToString:kHostFlag];
    //    }
    
    return shouldAccept;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    self.cache = [[YYCache alloc] initWithName:@"YYCacheDB"];
//        [self.cache removeAllObjects];
    
    //将URL转换成名字
    cacheKey = [NSString stringWithFormat:@"%lx", [[[self.request URL] absoluteString] hash]];
    //如果存在缓存则不请求网络
    if ([self.cache.diskCache containsObjectForKey:cacheKey]) {
        YMCachedData *cacheData = (YMCachedData *)[self.cache.diskCache objectForKey:cacheKey];
        if (cacheData) {
            NSData *data = [cacheData data];
            NSURLResponse *response = [cacheData response];
            NSURLRequest *redirectRequest = [cacheData redirectRequest];
            if (redirectRequest) {
                [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
            } else {
                [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed]; //我们处理缓存自己。
                [[self client] URLProtocol:self didLoadData:data];
                [[self client] URLProtocolDidFinishLoading:self];
            }
        }
        else {
            [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
        }
    }else {
        NSMutableURLRequest *connectionRequest = [[self request] mutableCopyWorkaround];

        [[self class] setProperty:@YES forKey:kOurRecursiveRequestFlagProperty inRequest:connectionRequest];
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:connectionRequest delegate:self];
        [self setConnection:connection];
    }
}

- (void)stopLoading
{
    [[self connection] cancel];
}

// NSURLConnection的代理（一般我们通过这个到我们的客户端）
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest =[request mutableCopyWorkaround];
        //如果重新定向则移除请求的标记
        [[self class] removePropertyForKey:kOurRecursiveRequestFlagProperty inRequest:redirectableRequest];
        
        YMCachedData *cacheDate = [[YMCachedData alloc] init];
        [cacheDate setResponse:response];
        [cacheDate setData:[self data]];
        [cacheDate setRedirectRequest:redirectableRequest];
        [self.cache.diskCache setObject:cacheDate forKey:cacheKey];
        
        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        return redirectableRequest;
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self setResponse:response];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed]; //我们自己缓存。
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    
    YMCachedData *cacheDate = [[YMCachedData alloc] init];
    [cacheDate setResponse:[self response]];
    [cacheDate setData:[self data]];
    [self.cache.diskCache setObject:cacheDate forKey:cacheKey];
    
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

//根据网页内容拼接数据
- (void)appendData:(NSData *)newData
{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }
    else {
        [[self data] appendData:newData];
    }
}

@end
//将属性归档
@implementation YMCachedData

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *propertyList = [[self class] propertyList];
    for (NSString *propertyName in propertyList) {
        [aCoder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        NSArray *properNames = [[self class] propertyList];
        for (NSString *propertyName in properNames) {
            [self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName];
        }
    }
    return self;
}

+ (NSArray *)propertyList {
    
    NSMutableArray *array = [NSMutableArray array];
    unsigned int propertyListCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyListCount);
    for (int i = 0; i < propertyListCount; i++) {
        NSString *property = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        [array addObject:property];
    }
    
    return [array copy];
}

@end
//重新复制Request
@implementation NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL] 
        cachePolicy:[self cachePolicy]
    timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    return mutableURLRequest;
}
@end






