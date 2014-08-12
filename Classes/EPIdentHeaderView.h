//
//  WTHeaderView.h
//  WarfareTouch
//
//  Created by Brad Goss on 10-02-02.
//  Copyright 2010 GossTech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EPIdentHeaderView : UIView {
	IBOutlet UIView *mainView;
	IBOutlet UIButton *button;
	IBOutlet UILabel *label;
	BOOL isSectionExpanded;
}

@property (assign) UIView *mainView;
@property (assign) UIButton *button;
@property (assign) UILabel *label;
@property (assign) BOOL isSectionExpanded;

+ (id)headerViewWithTitle:(NSString*)title;
- (NSString *) description;

@end
