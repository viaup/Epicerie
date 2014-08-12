//
//  CompleteListViewController.h
//  Epicerie
//
//  Created by Pascal Viau on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPList;
@class GTHeaderView;



@interface CompleteListViewController : UITableViewController {
	
	EPList *completeList;
	NSArray *categoriesArray;
	GTHeaderView *header0;
	GTHeaderView *header1;
	GTHeaderView *header2;


}

@property (nonatomic, copy) NSArray *categoriesArray;
@property (retain) GTHeaderView *header0;
@property (retain) GTHeaderView *header1;
@property (retain) GTHeaderView *header2;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void) createList;
- (NSArray*)indexPathsInSection:(NSInteger)section;
- (void)toggle:(BOOL*)isExpanded section:(NSInteger)section;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;


- (void)toggleSection0;
- (void)toggleSection1;
- (void)toggleSection2;


@end
