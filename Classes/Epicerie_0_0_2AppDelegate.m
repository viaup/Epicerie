//
//  Epicerie_0_0_2AppDelegate.m
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-02-21.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "Epicerie_0_0_2AppDelegate.h"
#import "RootViewController.h"
#import "ListViewController.h"
#import "EPList.h"


@implementation Epicerie_0_0_2AppDelegate

@synthesize window;
@synthesize navigationController, listViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // Add the navigation controller's view to the window and display.
	

	listViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
	[listViewController setRtViewController:[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil]];
	
    
	if (![[listViewController  rtViewController]  completeList]) {
		//check if there's data saved
		
		if ([NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"list.data")]) {
			[[listViewController  rtViewController]  getListFromArchive];
		}
		else {
			[[listViewController  rtViewController]  getListFromJSON];
		}
		
		
	}
	
	[listViewController setNavController:[self navigationController]];
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    [[[self	navigationController] navigationBar] setBarStyle:UIBarStyleDefault];
    [[[self	navigationController] navigationBar] setTintColor:[UIColor colorWithRed:0.2 green:0.45 blue:0.62 alpha:1.0]];
    
    //UINavigationBar image for iOS 5
//    if (version >= 5.0) {
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar_blue.png"] forBarMetrics: UIBarMetricsDefault];
//    }


	[[self navigationController] pushViewController:listViewController
										   animated:YES];
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void) archiveList
{
	//Get full path of list archive
	NSString *listPath=pathInDocumentDirectory(@"list.data");
	NSString *categoriesPath=pathInDocumentDirectory(@"categories.data");

	
	//get the EPList
	EPList *list=[[listViewController rtViewController] completeList];
	NSMutableArray *categories =[[listViewController rtViewController] categoriesArray];
	
	[NSKeyedArchiver archiveRootObject:list toFile:listPath];
	[NSKeyedArchiver archiveRootObject:categories toFile:categoriesPath];
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self archiveList];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[self archiveList];
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

/*@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"navBar_blue.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end*/

