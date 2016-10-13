# 代码整理

- CrashClass 崩溃是存储到本地

引入头文件后在AppDelegate中写下这句话即可 NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
- FTPManager 可配合崩溃日志上传至FTP

//判断网络环境
```
NetworkStatus netstatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
if (netstatus == ReachableViaWiFi) {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];     
    if ([user boolForKey:@"crash"]) {
        [user setBool:NO forKey:@"crash"];
        dispatch_queue_t defQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(defQueue, ^{
        self.ftpmanager = [[FTPManager alloc] initWithServer:@"FTP地址" user:@"用户名" password:@"密码" directory:@"存储路径，可多级，自动创建目录，自动创建1级目录下ini文件，第一次过后可根据修改ini文件设置下次是否再次上传"];
        });
    }
}
```
- tradeView
简单的实现了交易密码框
可由代码和xib两种方式创建
- 常用的Category的整理--UIView的Category中有个人封装的tapGuesture的Block
- 封装带des加密的网络请求
- 选择菜单以及弹出文字
- 模仿网易大乐透走势图动画,LottoDemo为普通控件创建实现动画，LottoDemo2为纯绘制实现效果，速度为普通实现方式的25倍，LottoDemo实现速度为54-60毫秒,纯绘制实现速度为2毫秒左右