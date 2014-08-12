//
//  OverlayViewController.m
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-02-25.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "OverlayViewController.h"
#import "RootViewController.h"


@implementation OverlayViewController

@synthesize rvController;



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	[rvController doneSearching_Clicked:nil];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[rvController release];
    [super dealloc];
}


@end
