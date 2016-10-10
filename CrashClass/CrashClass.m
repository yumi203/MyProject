//
//  CrashClass.m
//  PointsMall
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 高扬. All rights reserved.
//

#import "CrashClass.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AudioToolbox/AudioToolbox.h>
#import <sys/mount.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVAudioSession.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation CrashClass



#pragma mark - 检查崩溃方法
void UncaughtExceptionHandler(NSException *exception) {
    CrashClass *crash = [[CrashClass alloc] init];
    
    /// 创建一个根标签
    NSMutableString *xmlStr = [[NSMutableString alloc] init];
    [xmlStr appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<AllInfo>\n<systemInfo>\n"];
    
#pragma mark - 记录系统信息
    UIDevice *device = [UIDevice currentDevice];
    [xmlStr appendFormat:@"<设备>%@</设备>\n", device];
    //设备相关信息的获取
    NSString *strName = [[UIDevice currentDevice] name];
    [xmlStr appendFormat:@"<设备名称>%@</设备名称>\n", strName];
    NSString *strSysName = [[UIDevice currentDevice] systemName];
    [xmlStr appendFormat:@"<系统名称>%@</系统名称>\n", strSysName];
    
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    [xmlStr appendFormat:@"<系统版本号>%@</系统版本号>\n", strSysVersion];
    
    NSString *strModel = [[UIDevice currentDevice] model];
    [xmlStr appendFormat:@"<设备模式>%@</设备模式>\n", strModel];
    
    NSString *strLocModel = [[UIDevice currentDevice] localizedModel];
    [xmlStr appendFormat:@"<本地设备模式>%@</本地设备模式>\n", strLocModel];
    
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleName"];
    [xmlStr appendFormat:@"<App应用名称>%@</App应用名称>\n", strAppName];
    
    NSString *strAppVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    [xmlStr appendFormat:@"<App应用版本>%@</App应用版本>\n", strAppVersion];
    
    NSString *strAppBuild = [dicInfo objectForKey:@"CFBundleVersion"];
    [xmlStr appendFormat:@"<App应用Build版本>%@</App应用Build版本>\n", strAppBuild];

    //Getting the User’s Language
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    [xmlStr appendFormat:@"<语言>%@</语言>\n", language];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    [xmlStr appendFormat:@"<国家>%@</国家>\n", country];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [UIScreen mainScreen].scale ;
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    [xmlStr appendFormat:@"<分辨率>宽:%.0f | 高:%.0f</分辨率>\n", width,height];
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    [xmlStr appendFormat:@"<运营商>%@</运营商>\n", mCarrier];
    
    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    [xmlStr appendFormat:@"<获取当前网络的类型>%@</获取当前网络的类型>\n", mConnectType];
    [xmlStr appendFormat:@"<总磁盘容量>%lld</总磁盘容量>\n", [crash getTotalDiskSize]];
    [xmlStr appendFormat:@"<可用>%.0lld</可用>\n", [crash getAvailableDiskSize]];
    [xmlStr appendFormat:@"<总磁盘容量>%@</总磁盘容量>\n", [crash fileSizeToString:[crash getTotalDiskSize]]];
    [xmlStr appendFormat:@"<可用>%@</可用>\n", [crash fileSizeToString:[crash getAvailableDiskSize]]];
    
    //检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        if (!granted)
            [xmlStr appendString:@"<是否开启麦克风>否</是否开启麦克风>\n"];
        else
            [xmlStr appendString:@"<是否开启麦克风>是</是否开启麦克风>\n"];
    }];
    [xmlStr appendFormat:@"<内存>总:%.0f | 可用:%.0f</内存>\n", [crash availableMemory],[crash usedMemory]];
    
    
    NetworkStatus netstatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (netstatus)
    {
        case NotReachable:{
            // 没有网络连接
            [xmlStr appendString:@"<网络环境>没有网络连接</网络环境>\n"];
        }break;
        case ReachableViaWWAN:{
            // 使用3G网络
            [xmlStr appendString:@"<网络环境>GPRS/3G</网络环境>\n"];
        }break;
        case ReachableViaWiFi:{
            // 使用WIFI
            [xmlStr appendString:@"<网络环境>WIFI</网络环境>\n"];
        }break;
    }
    [xmlStr appendString:@"</systemInfo>\n"];
#pragma mark - 记录崩溃信息
    [xmlStr appendString:@"<crashInfo>\n"];
    
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    CGFloat softVersion = 1.0;
    [xmlStr appendFormat:@"<异常类型>%@</异常类型>\n", name];
    [xmlStr appendFormat:@"<崩溃的原因>%@</崩溃的原因>\n", reason];
    [xmlStr appendFormat:@"<手机系统>%.2f</手机系统>\n", systemVersion];
    [xmlStr appendFormat:@"<软件版本>%.2f</软件版本>\n", softVersion];
    [xmlStr appendFormat:@"<当前调用栈信息>%@</当前调用栈信息>\n", arr];
    [xmlStr appendString:@"</crashInfo>\n</AllInfo>\n"];

    NSLog(@"xmlString  %@", xmlStr);
    //文件保存路径.
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *file = [docPath stringByAppendingPathComponent:@"log.xml"];
    //写入disk
    [xmlStr writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:YES forKey:@"crash"];
    NSLog(@"%@", file);
}

- (float)cpu_usage
{
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    return tot_cpu;
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}


// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}


//获取总磁盘容量
-(long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}

//获取可用磁盘容量

-(long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

//另附字符串转换函数
-(NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}


@end
