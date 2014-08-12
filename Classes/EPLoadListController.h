//
//  EPLoadListController.h
//  Epicerie
//
//  Created by Pascal Viau on 11-06-07.
//  Copyright 2011 calepin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListViewController;

@interface EPLoadListController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView * tableView;
    IBOutlet UILabel * titleLabel;
    IBOutlet UIButton * addButton;
    IBOutlet UIButton * replaceButton;
    ListViewController *lstViewController;
    NSInteger selectedIndex;
    NSMutableArray *savedLists;
    BOOL isDeleting;
    
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) ListViewController *lstViewController;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSMutableArray * savedLists;

- (IBAction)dismissController: (id)sender;
- (IBAction)addList: (id)sender;
- (IBAction)replaceList: (id)sender;

@end
