//
//  EPExpandedHeaderView.h
//  Epicerie
//
//  Created by Pascal Viau on 11-03-25.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EPExpandedHeaderView : UIView <NSCoding>{

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
