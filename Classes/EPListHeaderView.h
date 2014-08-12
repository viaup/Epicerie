//
//  EPListHeaderView.h
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-03-12.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EPListHeaderView : UIView {
	IBOutlet UIView *mainView;
	IBOutlet UIButton *button;
	IBOutlet UILabel *label;

}

@property (assign) UIView *mainView;
@property (assign) UIButton *button;
@property (assign) UILabel *label;

+ (id)headerViewWithTitle:(NSString*)title;
- (NSString *) description;

@end
