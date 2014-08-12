//
//  EPPopUpNumber.m
//  Epicerie
//
//  Created by Pascal Viau on 11-05-25.
//  Copyright 2011 calepin. All rights reserved.
//

#import "EPPopUpNumber.h"
#import "ListViewController.h"


@implementation EPPopUpNumber

@synthesize mainView, centerButton, remainLabel, lsViewController;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0., 0., 50., 50.)];
    if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"EPPopUpNumber" owner:self options:nil];
		[self addSubview:mainView];
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)showActionSheets: (id)sender
{
    //NSLog(@"Add action sheet here");
    [lsViewController popUpActionSheet];
}

- (void)dealloc
{
    [super dealloc];
}

@end
