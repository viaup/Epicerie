//
//  EPList.m
//  Epicerie
//
//  Created by Pascal Viau on 11-02-08.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "EPList.h"
#import "EPItem.h"

@implementation EPList

@synthesize listOfCategories, listName, dateSaved;



- (id) init
{
	return [self initWithName: @"Nouvelle liste"
						 list: nil];
}


- (id) initWithName: (NSString *) lname
{
	return [self initWithName: (NSString *) lname
						 list: [[[NSMutableDictionary alloc] init] autorelease]];
}

- (id) initWithName: (NSString *) lname
			   list: (NSMutableDictionary *) lst
{
	self = [super init];
	
	//Verify the initialization
	if (!self) {
		NSLog(@"L'initialisation d'un objet EPList a echoue");
		return nil;
	}
	
	[self setListOfCategories:lst];
	[self setListName:lname];	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
	self =[super init];
	
	[self setListOfCategories:[decoder decodeObjectForKey:@"listOfCategories"]];
	[self setListName:[decoder decodeObjectForKey:@"listName"]];
	dateSaved= [[decoder decodeObjectForKey:@"dateSaved"] retain];
	
	return self;

}

- (void)encodeWithCoder:(NSCoder *)encoder{

	[encoder encodeObject:listOfCategories forKey:@"listOfCategories"];
	[encoder encodeObject:listName forKey:@"listName"];
	[encoder encodeObject:dateSaved forKey:@"dateSaved"];
	
}

- (NSString *) description {
	
	return [NSString stringWithFormat:@"Nom de la liste : %@, liste : %@",
			listName,
			listOfCategories];
}
/*
- (id)copyWithZone:(NSZone *)zone
{
    NSLog(@"EPList copyWithZone called");
    EPList *newList= [[EPList allocWithZone:zone] initWithName:[self listName]];
    [newList setListOfCategories:[listOfCategories mutableCopyWithZone:zone]];
    return newList;
}*/

- (void) dealloc
{
	[listOfCategories release];
	[listName release];
	[dateSaved release];
	[super dealloc];
}



		 
		

@end
