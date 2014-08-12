//
//  OverlayViewController.h
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-02-25.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;

@interface OverlayViewController : UIViewController {
	
	RootViewController *rvController;

}

@property (nonatomic, retain) RootViewController *rvController;

@end
