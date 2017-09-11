//
//  AppDelegate.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/25.
//  Copyright © 2017年 street. All rights reserved.
//

#import "AppDelegate.h"
#import "LightManagerController.h"
#import "LightControlController.h"
#import "WarnWatchController.h"
#import "SysSettingController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:RGB(0, 205, 102)];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //初始化接口
    
    //[HttpTool sharedInstance].baseUrl=@"http://192.168.9.57:9001";
    
    
    
    //初始化控制器
    self.tabbarController=[[UITabBarController alloc]init];
    self.tabbarController.delegate=self;
    LightManagerController *lightManger=[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"lightManager"];
    LightControlController *lightControl=[ViewTool initViewByStoryBordName:@"LightControl" withViewId:@"lightControl"];
    WarnWatchController *warn=[ViewTool initViewByStoryBordName:@"WarnWatch" withViewId:@"warn"];
    SysSettingController *SysSetting=[ViewTool initViewByStoryBordName:@"SystemSetting" withViewId:@"sys"];
    
    NSArray *views=@[lightManger,lightControl,warn,SysSetting];
    NSArray *titles=@[@"路灯管理",@"路灯控制",@"警告监控",@"系统设置"];
    NSArray *items=@[@"ldgl",@"ldkz",@"xtsz",@"sys_setting"];
    NSArray *itemsed=@[@"ldgl_d",@"ldkz_d",@"gjjk_d",@"xtsz_d"];
    self.tabbarController.viewControllers=views;
    for (int i=0; i<self.tabbarController.viewControllers.count; i++) {
        UIViewController *tabView=(UIViewController *)self.tabbarController.viewControllers[i];
        tabView.tabBarItem.title=titles[i];
        tabView.tabBarItem.image=[[UIImage imageNamed:items[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabView.tabBarItem.selectedImage=[[UIImage imageNamed:itemsed[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds] ];
    self.window.rootViewController=self.tabbarController;
    [self.window makeKeyAndVisible];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:RGB(0, 205, 102)} forState:UIControlStateSelected];
    
    IQKeyboardManager *keyboardManager=[IQKeyboardManager sharedManager];
    keyboardManager.enable=YES;
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    //判断是否有配置ip 用户等信息
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *loginToken=[userDefault valueForKey:@"loginToken"];
    if (loginToken==nil) {
        [self.window.rootViewController presentViewController:[ViewTool initViewByStoryBordName:@"Login" withViewId:@"login"] animated:YES completion:nil];
    }else{
        [User sharedInstance].id=[userDefault valueForKey:@"id"];
        [User sharedInstance].appuser=[userDefault valueForKey:@"appuser"];
        [User sharedInstance].apppwd=[userDefault valueForKey:@"apppwd"];
        [User sharedInstance].mark=[userDefault valueForKey:@"mark"];
        [User sharedInstance].guardianname=[userDefault valueForKey:@"guardianname"];
        [User sharedInstance].guardiancode=[userDefault valueForKey:@"guardiancode"];
        [User sharedInstance].regtime=[userDefault valueForKey:@"regtime"];
        [User sharedInstance].inccode=[userDefault valueForKey:@"inccode"];
        [User sharedInstance].tel=[userDefault valueForKey:@"tel"];
        [User sharedInstance].token=loginToken;
        [HttpTool sharedInstance].baseUrl=[userDefault valueForKey:@"pingtaiUrl"];
        [HttpTool sharedInstance].pingtaiUrl=[userDefault valueForKey:@"pingtaiUrl"];
        [HttpTool sharedInstance].serverUrl=[userDefault valueForKey:@"serverUrl"];
        
       
        
    }
    
    
    //配置高德地图key
    [AMapServices sharedServices].apiKey=@"7069bb1b498fbcb7e9c4faab52dfe64f";
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.street.StreetLight" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StreetLight" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StreetLight.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark 选项卡协议
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    //检查网络
//
//    NSString *token=[User sharedInstance].token;
//        if (token==nil||[token isEqualToString:@""]) {
//            [viewController presentViewController: [ViewTool initViewByStoryBordName:@"Login" withViewId:@"login"] animated:YES completion:nil];
//            return NO;
//            return  YES;
//
//        }else return YES;
//}

@end
