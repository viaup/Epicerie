//
//  EPListHeaderView.m
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-03-12.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "EPListHeaderView.h"


@implementation EPListHeaderView

@synthesize mainView, button, label;

+ (id)headerViewWithTitle:(NSString*)title {
	EPListHeaderView *headerView = [[EPListHeaderView alloc] init];
	[headerView.label setText:title];
	return [headerView autorelease];
}
- (id) init {
	self = [super initWithFrame:CGRectMake(0., 0., 320., 44.)];
	if (self != nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EPListHeaderView" owner:self options:nil];
		
		[self addSubview:mainView];
	}
	return self;
}


- (NSString *) description {
	
	return [NSString stringWithFormat:@"header : %@",
			label];
}

@end
