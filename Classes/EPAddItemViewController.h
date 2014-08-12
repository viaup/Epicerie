//
//  EPAddItemViewController.h
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-03-19.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface EPAddItemViewController : UIViewController <UIActionSheetDelegate> {
			
	RootViewController *rtViewController;
	NSString *sectionName;
	NSString *actionMode;
    NSString *productName;
	IBOutlet UILabel *firstLine;
	IBOutlet UILabel *secondLine;
	IBOutlet UITextField *textField;
	//UIView *mainView;

}

@property (nonatomic, retain) RootViewController *rtViewController;
@property (nonatomic, retain) NSString *sectionName;
@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *actionMode;
@property (nonatomic, retain) IBOutlet UILabel *firstLine;
@property (nonatomic, retain) IBOutlet UILabel *secondLine;
@property (nonatomic, retain) IBOutlet UITextField *textField;
//@property (nonatomic, retain) IBOutlet UIView *mainView;


- (id) initWithSectionName:(NSString  *)sectionName;
- (IBAction)addButtonPressed: (id)sender;
- (IBAction)dismissController: (id)sender;
- (void) addProduct;
- (void) addSection;
//- (void) showActionSheet;
//- (IBAction)changeTextWithSegmentedControl: (id) sender;

@end
