//
//  WTHeaderView.m
//  WarfareTouch
//
//  Created by Brad Goss on 10-02-02.
//  Copyright 2010 GossTech Inc. All rights reserved.
//

#import "EPIdentHeaderView.h"


@implementation EPIdentHeaderView

@synthesize mainView, button, label, isSectionExpanded;

+ (id)headerViewWithTitle:(NSString*)title {
	EPIdentHeaderView *headerView = [[EPIdentHeaderView alloc] init];
	[headerView.label setText:title];
	return [headerView autorelease];
}
- (id) init {
	self = [super initWithFrame:CGRectMake(0., 0., 320., 44.)];
	if (self != nil) {
		//[self setIsSectionExpanded:NO];
		[[NSBundle mainBundle] loadNibNamed:@"EPIdentHeaderView" owner:self options:nil];
		
		[self addSubview:mainView];
	}
	return self;
}

- (NSString *) description {
	
	return [NSString stringWithFormat:@"header : %@",
			label];
}

@end
