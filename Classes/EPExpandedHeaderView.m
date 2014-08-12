//
//  EPExpandedHeaderView.m
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-03-25.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "EPExpandedHeaderView.h"


@implementation EPExpandedHeaderView


@synthesize mainView, button, label, isSectionExpanded;

+ (id)headerViewWithTitle:(NSString*)title {
	EPExpandedHeaderView *headerView = [[EPExpandedHeaderView alloc] init];
	[headerView.label setText:title];
	return [headerView autorelease];
}
- (id) init {
	self = [super initWithFrame:CGRectMake(0., 0., 320., 44.)];
	if (self != nil) {
		//[self setIsSectionExpanded:NO];
		[[NSBundle mainBundle] loadNibNamed:@"EPExpandedHeaderView" owner:self options:nil];
		
		[self addSubview:mainView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
	self =[super init];
	
	[self setMainView:[decoder decodeObjectForKey:@"mainView"]];
	[self setButton:[decoder decodeObjectForKey:@"button"]];
	[self setLabel:[decoder decodeObjectForKey:@"label"]];
	[self setIsSectionExpanded:[decoder decodeBoolForKey:@"isSectionExpanded"]];
	
	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	
	[encoder encodeObject:mainView forKey:@"mainView"];
	[encoder encodeObject:button forKey:@"button"];
	[encoder encodeObject:label forKey:@"label"];
	[encoder encodeBool:isSectionExpanded forKey:@"isSectionExpanded"];
	
}

- (NSString *) description {
	
	return [NSString stringWithFormat:@"header : %@",
			label];
}

@end
