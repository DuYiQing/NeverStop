//
//  AppDelegate.m
//  NeverStop
//
//  Created by Jiang on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RegisterViewController.h"
#import "MessageViewController.h"
#import "MotionViewController.h"
#import "MyViewController.h"
#import "ScopeViewController.h"
#import "MatchViewController.h"
#import "HealthManager.h"
#import "StartViewController.h"
#import "HistoryViewController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()
<
UITabBarControllerDelegate,
JPUSHRegisterDelegate
>
@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) EMError *error;

@end

@implementation AppDelegate

#pragma mark - 捕获异常信息

void uncaughtExceptionHandler(NSException *exception) {
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSString *syserror = [NSString stringWithFormat:@"异常名称：%@\n异常原因：%@\n异常堆栈信息：%@", name, reason, stackArray];
    DDLogInfo(@"CRASH: %@", syserror);
    
    NSString *dirName = @"exception";
    NSString *fileDir = [NSString stringWithFormat:@"%@/%@/", [FileManagerUtils getDocumentsPath], dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[fileDir stringByExpandingTildeInPath]];
    [fileManager createFileAtPath:[fileDir stringByAppendingString:[NSDate getSystemTimeString]] contents:[syserror dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AMapServices sharedServices].apiKey = @"7a51d2c58640778bd644ee3641609981";
    // 验证
    [HealthManager shareInstance];
    
    // 环信
    //AppKey:注册的AppKey。
    //apnsCertName:推送证书名（不需要加后缀）。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1175161105178569#jdtneverstop"];
    options.apnsCertName = @"NeverStop";
    self.error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!_error) {
        NSLog(@"初始化成功");
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self createTabBarController];
    
    [self DDLogsetup];
    [self initMobClick];
    
    NSLog(@"NSLog");
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    DDLogError(NSHomeDirectory());
    [self networkReachability];
    
#pragma mark - 3DTouch
    
    // 3Dtouch按压程序图标的快捷选项
    // 快捷菜单的图标
    UIApplicationShortcutIcon *icon0 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
    // 快捷菜单
    
    UIApplicationShortcutItem *item0 = [[UIApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"开始运动" localizedSubtitle:nil icon:icon0 userInfo:nil];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"2" localizedTitle:@"我的" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"3" localizedTitle:@"运动记录" localizedSubtitle:nil icon:icon2 userInfo:nil];
    // 设置app快捷菜单
    [[UIApplication sharedApplication] setShortcutItems:@[item0, item1, item2]];
    
#pragma mark - 推送
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"2e4dd095d6b98926a2b748c0"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
// 自定义推送
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    
    
    return YES;
}
// 自定义消息
//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
//}


// 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
// 注册失败处理
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)createTabBarController {
    
    // 运动圈页面
    ScopeViewController *scVC = [[ScopeViewController alloc] init];
    scVC.title = @"运动圈";
    UINavigationController *scNavigationController = [[UINavigationController alloc] initWithRootViewController:scVC];
    UIImage *scimage = [UIImage imageNamed:@"pyh"];
    scimage = [scimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *ascimage = [UIImage imageNamed:@"pyl"];
    ascimage = [ascimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    scNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"运动圈" image:scimage selectedImage:ascimage];
    
    
    


    
       
    
    // 比赛页面
    
    MatchViewController *maVC = [[MatchViewController alloc] init];
    maVC.title = @"赛事";
    UINavigationController *maNavigationController = [[UINavigationController alloc] initWithRootViewController:maVC];
    UIImage *maimage = [UIImage imageNamed:@"bsh"];
    maimage = [maimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *amaimage = [UIImage imageNamed:@"bsl"];
    amaimage = [amaimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    maNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"赛事" image:maimage selectedImage:amaimage];
    
    
    
    // 运动页面
    MotionViewController *moVC = [[MotionViewController alloc] init];
    moVC.title = @"运动";
    UINavigationController *moNavigationController = [[UINavigationController alloc] initWithRootViewController:moVC];
    UIImage *moimage = [UIImage imageNamed:@"ydh"];
    moimage = [moimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *amoimage = [UIImage imageNamed:@"ydl"];
    amoimage = [amoimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    moNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"运动" image:moimage selectedImage:amoimage];
    
    
    
//    // 消息页面
//    MessageViewController *meVC = [[MessageViewController alloc] init];
//    meVC.title =@"消息";
//    UINavigationController *meNavigationController = [[UINavigationController alloc] initWithRootViewController:meVC];
//    UIImage *meimage = [UIImage imageNamed:@"xxh"];
//    meimage = [meimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *ameimage = [UIImage imageNamed:@"xxl"];
//    ameimage = [ameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    meNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:meimage selectedImage:ameimage];
//    
    
    // 我的页面
    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.title = @"我的";
    UINavigationController *myNavigationController = [[UINavigationController alloc] initWithRootViewController:myVC];
    UIImage *myimage =[UIImage imageNamed:@"myh"];
    myimage = [myimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *amyimage = [UIImage imageNamed:@"myl"];
    amyimage = [amyimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:myimage selectedImage:amyimage];
    
    
    
    
    
    
    UITabBarController *rootTabBarController = [[UITabBarController alloc] init];
    rootTabBarController.viewControllers = @[scNavigationController,maNavigationController,moNavigationController,myNavigationController];
    rootTabBarController.delegate = self;
    rootTabBarController.selectedIndex = 2;
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]];
//    [UITabBar appearance].translucent = NO;
    self.tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[scNavigationController,maNavigationController,moNavigationController,myNavigationController];
    _tabBarController.delegate = self;
    _tabBarController.selectedIndex = 2;
    
    
    
    // 使用NSUserDefaults 读取用户数据
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    // 判断是否第一次进入应用
    if (![userDef boolForKey:@"notFirst"]) {
        // 如果是第一次,进入引导页
//        ViewController *viewController = [[ViewController alloc] init];
//        viewController.rootTabBarController = _tabBarController;
//        self.window.rootViewController = viewController;
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        registerVC.rootTabBarController = _tabBarController;
        self.window.rootViewController = registerVC;
        
    } else {
        // 否则直接进入应用
        self.window.rootViewController = _tabBarController;
    }

    
    

    
}

- (void)getUserInfo {
    
}

#pragma mark - NetworkReachability

- (void)networkReachability {
    AFNetworkReachabilityManager *mar = [AFNetworkReachabilityManager sharedManager];
    [mar setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未使识别的网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"不可达的（未连接的）");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"2G，3G 4G 网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WIFi");
                break;
            }
        }
    }];
    
    [mar startMonitoring];
}

#pragma makr UMeng

- (void)initMobClick {
    UMConfigInstance.appKey = kUMengAppKey;
    UMConfigInstance.channelId = kUMengChannelId;
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark setup

- (void)DDLogsetup {
    
    //    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //开启使用 XcodeColors
    setenv("XcodeColors", "YES", 0);
    //检测
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        // XcodeColors is installed and enabled!
        NSLog(@"XcodeColors is installed and enabled");
    }
    
    //开启DDLog 颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor brownColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    if ([shortcutItem.type isEqualToString:@"1"]) {
        self.tabBarController.selectedIndex = 2;
        StartViewController *startVC = [[StartViewController alloc] init];
        startVC.hidesBottomBarWhenPushed = YES;

        [self.tabBarController.selectedViewController pushViewController:startVC animated:YES];
    } else if ([shortcutItem.type isEqualToString:@"2"]) {
        self.tabBarController.selectedIndex = 4;
    } else if ([shortcutItem.type isEqualToString:@"3"]) {
        self.tabBarController.selectedIndex = 4;
        HistoryViewController *historyVC = [[HistoryViewController alloc] init];
       historyVC.hidesBottomBarWhenPushed = YES;
           [self.tabBarController.selectedViewController pushViewController:historyVC animated:YES];
    }

    

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [[EMClient sharedClient] applicationWillEnterForeground:application];

    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[SQLiteDatabaseManager shareManager] closeSQLite];
}

@end
