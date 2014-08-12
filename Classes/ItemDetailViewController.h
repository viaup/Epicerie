//
//  ItemDetailViewController.h
//  Epicerie
//
//  Created by Pascal Viau on 11-05-11.
//  Copyright 2011 calepin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ListViewController;
@class EPItem;

@interface ItemDetailViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate>{
 
    ListViewController *lstViewController;
    EPItem *item;
    IBOutlet UILabel *itemNameLabel;
    IBOutlet UILabel *detailLabel;
	IBOutlet UITextField *qtyField;
    IBOutlet UITextView *noteField;
    IBOutlet UIButton *plusBtn;
    UIImage *plus_grey;
    UIImage *plus_blue;
    UIImage *plus_star;
}

@property (nonatomic, retain) ListViewController *lstViewController;
@property (nonatomic, retain) EPItem *item;
@property (nonatomic, retain) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *plusBtn;
@property (nonatomic, retain)  UIImage *plus_grey;
@property (nonatomic, retain)  UIImage *plus_blue;
@property (nonatomic, retain)  UIImage *plus_star;




- (IBAction)dismissController: (id)sender;
- (IBAction)emptyQtyField: (id)sender;
- (IBAction)emptyNoteField: (id)sender;
- (IBAction)qtyEditingChanged: (id)sender;

@end
