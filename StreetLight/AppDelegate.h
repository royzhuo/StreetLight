//
//  AppDelegate.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/25.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong) UITabBarController *tabbarController; //选项卡控制器

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

