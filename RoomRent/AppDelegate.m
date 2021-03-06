//
//  AppDelegate.m
//  RoomRent
//
//  Created by Bishal Heuju on 3/30/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "AppDelegate.h"

#import <SWRevealViewController/SWRevealViewController.h>
#import "SidebarViewController.h"
#import "DBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Use Firebase library to configure APIs
    [FIRApp configure];
    
    
    [self setupDefaults];
    
    //MARK: AUTO LOGIN
    //Get userData from UserDefaults
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_USER_OBJECT];
    
    if (userData != nil) {
        
        //Preload Data into database
        [self preloadData];
        
        //Logged In User
        
        //For SDWebImage Manager to send api_token in header (needed only once: appdelegate autologin/signin)
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        
        //Switch to tabBarViewController
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainTabBarController = [mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        
        UIViewController *sidebarVC = [mainStory instantiateViewControllerWithIdentifier:@"SidebarViewController"];
        
        //UINavigationController *mainVC = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
        SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:sidebarVC frontViewController:mainTabBarController];
        
        [window setRootViewController:revealVC];
        [window makeKeyAndVisible];
        
    } else {
        //Not Logged In
        
        //Do Nothing
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)setupDefaults {
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
}

-(void)preloadData {
    
    //GET: /posts
    [[APICaller sharedInstance:nil] callApiForGET:POST_PATH parameters:nil sendToken:true successBlock:^(id responseObject) {
        
        id data = [responseObject valueForKey:@"data"];
        
        NSLog(@"%@", data);
        
        for (id postJsonObject in data) {
            
            Post *post = [[Post alloc] initPostWithJson:postJsonObject];
            [[DBManager sharedInstance] addPost:post];
            
            id userJson = [postJsonObject valueForKey:JSON_KEY_USER_OBJECT];
            User *user = [[User alloc] initUserFromJson:userJson];
            [[DBManager sharedInstance] addUser:user];
            
            id images = [postJsonObject valueForKey:JSON_KEY_POST_IMAGES];
            for (NSString* imagename in images) {
                [[DBManager sharedInstance] addImage:post.postId fileName:imagename];
            }
            
        }
        
    }];
}



@end
