//
//  EpicerieAppDelegate.h
//  Epicerie
//
//  Created by Pascal Viau on 11-02-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class CompleteListViewController;

@interface EpicerieAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	CompleteListViewController *clvController;
/*    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;*/
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
/*
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;*/

@end

