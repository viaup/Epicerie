//
//  EPSaveListController.h
//  Epicerie
//
//  Created by Pascal Viau on 11-06-03.
//  Copyright 2011 calepin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ListViewController;  

@interface EPSaveListController : UIViewController {
    
    ListViewController *lstViewController;
    IBOutlet UITextField *textField;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIButton *saveButton;
    NSDate *saveDate;
    
}

@property (nonatomic, retain) ListViewController *lstViewController;
@property (nonatomic, retain) NSDate *saveDate;

- (IBAction)dismissController: (id)sender;
- (IBAction)saveList: (id)sender;
- (IBAction)checkIfEmpty: (id) sender;
- (void) showAlertWithTitle:(NSString*)title message:(NSString *)mess;

@end
