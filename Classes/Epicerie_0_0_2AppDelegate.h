//
//  Epicerie_0_0_2AppDelegate.h
//  Epicerie
//
//  Created by Pascal Viau on 11-02-21.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListViewController;

@interface Epicerie_0_0_2AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	ListViewController *listViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ListViewController *listViewController;

//- (NSString *)archiveListPath;
//- (NSString *)archiveCategoriesPath;

- (void) archiveList;

@end

