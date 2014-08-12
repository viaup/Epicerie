//
//  RootViewController.h
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-02-21.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EPList;
@class GTHeaderView;
@class OverlayViewController;
@class EPAddItemViewController;

@interface RootViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate> {
	
	//TableView
	EPList *completeList;
	NSMutableArray *categoriesArray;
	NSMutableArray *editingCategoriesArray;
	NSMutableArray *headersArray;

	
	//Add items
	EPAddItemViewController *addItemViewController;
	UIBarButtonItem *rightButton;
	
	//searchBar
	OverlayViewController * ovController;
	NSMutableArray *aCopyOfListItems;
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
	BOOL isDeleting;
    BOOL addCellSelected;
	
	//delete
    NSIndexPath *indexPathForProduct;
	NSIndexPath *indexPathForActionSheet;

}

@property (nonatomic, retain) EPList *completeList;
@property (nonatomic, retain) NSMutableArray *categoriesArray;
@property (nonatomic, retain) NSMutableArray *editingCategoriesArray;
@property (nonatomic, retain) NSMutableArray *headersArray;
@property (nonatomic, retain) UIBarButtonItem *rightButton;
@property (nonatomic, copy) NSMutableArray *aCopyOfListItems;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) OverlayViewController * ovController;
@property (nonatomic, retain) EPAddItemViewController *addItemViewController;
@property (nonatomic, retain) NSIndexPath *indexPathForProduct;
@property (nonatomic, retain) NSIndexPath *indexPathForActionSheet;


- (void) addProduct:(NSString *)product toSection:(NSString *)section;
- (void) showAddItemViewWithActionMode: (NSString *) actionMode;
- (void) getListFromJSON;
- (void) getListFromArchive;
- (NSArray*)indexPathsInSection:(NSInteger)section;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (void)toggleSection:(id)sender;
- (NSArray *) listOfItemsWithIndexPath: (NSIndexPath *)indexPath;
//- (BOOL) showAlertWithTitle:(NSString*)title message:(NSString *)message;

//searchBar
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (void) addSearchBar;

//editing
- (void) editingButtonPressed: (id) sender;

//actionSheets
- (void) showActionSheetWithTitle:(NSString*)title
				cancelButtonTitle:(NSString*)cancel
		   destructiveButtonTitle:(NSString*)destructive;


@end
