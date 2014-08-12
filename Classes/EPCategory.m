//
//  EPCategory.m
//  Epicerie
//
//  Created by Pascal Viau on 11-02-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EPCategory.h"
#import "EPItem.h"


@implementation EPCategory

@synthesize categoryName, itemsList;

- (id) initWithCategoryName: (NSString*) name
				 itemsList: (NSMutableArray *) list
{
	self = [super init];
	if (!self) {
		NSLog(@"L'initialisation d'un objet EPCategory a echoue");
		return nil;
	}
	
	[self setCategoryName: name];
	[self setItemsList: list];
	
	return self;
}


- (id) initWithCategoryName: (NSString*) name
{
	return [self initWithCategoryName:name
							itemsList:nil];
}

- (id) init
{
	return [self initWithCategoryName:@"Categorie"
							itemsList:nil];
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"Categorie : %@, Items: %@",
			categoryName,
			itemsList];
}

- (void) dealloc
{
	[categoryName release];
	[itemsList release];
	[super dealloc];
}
			
			

@end
