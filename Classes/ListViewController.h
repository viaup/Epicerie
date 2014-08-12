//
//  ListViewController.h
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-03-01.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class RootViewController;
@class ItemDetailViewController;
@class EPPopUpNumber;
@class EPSaveListController;
@class EPLoadListController;
@class EPList;

@interface ListViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	
	UINavigationController *navController;
	RootViewController *rtViewController;
    ItemDetailViewController *detailViewController;
    EPSaveListController *saveListController;
    EPLoadListController * loadListController;
    EPList *tempList;
    //NSMutableArray *savedLists;
    EPPopUpNumber *popUp;

	NSMutableArray *categoriesArray;
	NSMutableArray *listHeadersArray;
    NSInteger minRows;
	BOOL isEmpty;
	BOOL xTouched;
    BOOL isDisplayed;
    BOOL buttonCanMove;
    int countDisp;

	

}

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet RootViewController *rtViewController;
@property (nonatomic, retain) IBOutlet ItemDetailViewController *detailViewController;
@property (nonatomic, copy) EPList * tempList;
//@property (nonatomic, copy) NSMutableArray * savedLists;
@property (nonatomic, retain) EPPopUpNumber *popUp;
@property (nonatomic, copy) NSMutableArray *categoriesArray;
@property (nonatomic, copy) NSMutableArray *listHeadersArray;
@property (nonatomic) NSInteger minRows;

- (void)fillListOfItemsInCart;
- (void) loadProductsList;
- (void) touchXMark: (id) sender;
- (void) showDetailView: (id) sender;
- (void) emptyList;
- (NSMutableArray *) listOfItemsInCartInSection: (NSInteger)section;
- (void) popUpNumber;
- (NSString *) selectedItemsCount;
- (void) popUpActionSheet;
- (void) showSaveListController;
- (void) saveListWithName:(NSString *)name date:(NSDate *)date;
- (void) showLoadListController;
- (void) sendEmail;
- (NSString *) composeEmail;
- (void) getListAtIndex:(NSInteger) index replaceList:(BOOL)replaced;
//- (void) dismissPopUpNumber;




@end
