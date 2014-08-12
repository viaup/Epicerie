//
//  WTHeaderView.m
//  WarfareTouch
//
//  Created by Brad Goss on 10-02-02.
//  Copyright 2010 GossTech Inc. All rights reserved.
//

#import "GTHeaderView.h"


@implementation GTHeaderView

@synthesize mainView, button, label, isSectionExpanded;

+ (id)headerViewWithTitle:(NSString*)title {
	GTHeaderView *headerView = [[GTHeaderView alloc] init];
	[headerView.label setText:title];
	return [headerView autorelease];
}
- (id) init {
	self = [super initWithFrame:CGRectMake(0., 0., 320., 44.)];
	if (self != nil) {
		//[self setIsSectionExpanded:NO];
		[[NSBundle mainBundle] loadNibNamed:@"WTHeaderView" owner:self options:nil];
		
		[self addSubview:mainView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
	self = [super init];
	
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
