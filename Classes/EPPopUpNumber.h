//
//  EPPopUpNumber.h
//  Epicerie
//
//  Created by Pascal Viau on 11-05-25.
//  Copyright 2011 calepin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListViewController;

@interface EPPopUpNumber : UIView {
    
    IBOutlet UIView *mainView;
    IBOutlet UIButton *centerButton;
    IBOutlet UILabel *remainLabel;
    ListViewController *lsViewController;

}

@property (assign) UIView *mainView;
@property (retain) UIButton *centerButton;
@property (retain) UILabel *remainLabel;
@property (retain) ListViewController *lsViewController;


- (IBAction)showActionSheets: (id)sender;


@end
