//
//  EPItem.m
//  Epicerie
//
//  Created by Pascal Viau on 11-02-07.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "EPItem.h"


@implementation EPItem

@synthesize name, quantity, note, isSelected, isInCart;

+ (id) randomItem
{
	NSArray *randomNameList = [NSArray arrayWithObjects:@"patates",
								   @"carottes",
								   @"laitue",
								   @"poivron",
								   @"concombre", nil];
	
	
	int nameIndex = random() % [randomNameList count];
	
	NSString *randomName = [NSString stringWithFormat:@"%@",
							[randomNameList objectAtIndex:nameIndex]];

	
	EPItem *newItem = [[self alloc] initWithName:randomName];
	

	return [newItem autorelease];					   									
}



- (id) init
{
	return [self initWithName:@"Item"
					 quantity:@""];
}

- (id) initWithName: (NSString *) itName
{
	return [self initWithName:itName
					 quantity:@""];
}




- (id) initWithName: (NSString *) itName
		   quantity: (NSString*) itQty;
{
	//call the superclass's initializer
	self = [super init];
	
	//Verify the initialization
	if (!self) {
		NSLog(@"L'initialisation d'un objet EPItem a echoue");
		return nil;
	}
	
	[self setName:itName];
	[self setQuantity:itQty];
    [self setNote:@""];
	[self setIsSelected:NO];
	[self setIsInCart:NO];
	
	return self;
	
}

- (id)initWithCoder:(NSCoder *)decoder{
	self =[super init];
	
	[self setName:[decoder decodeObjectForKey:@"name"]];
	[self setQuantity:[decoder decodeObjectForKey:@"quantity"]];
    [self setNote:[decoder decodeObjectForKey:@"note"]];
	[self setIsSelected:[decoder decodeBoolForKey:@"isSelected"]];
	[self setIsInCart:[decoder decodeBoolForKey:@"isInCart"]];
	
	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:quantity forKey:@"quantity"];
    [encoder encodeObject:note forKey:@"note"];
	[encoder encodeBool:isSelected forKey:@"isSelected"];
	[encoder encodeBool:isInCart forKey:@"isInCart"];
	
}

- (NSString *) description {
	
	return [NSString stringWithFormat:@"item : %@",
			name];
}
/*
- (id)copyWithZone:(NSZone *)zone
{
    NSLog(@"EPItem copyWithZone called");
    EPItem *newItem=[[EPItem allocWithZone:zone] initWithName:[self name]];
    [newItem setNote:[[self note] copyWithZone:zone]];
    [newItem setQuantity:[[self quantity] copyWithZone:zone]];
    [newItem setIsSelected:[self isSelected] ? YES : NO];
    [newItem setIsInCart:[self isInCart] ? YES : NO];
    return newItem;

}*/

- (void) dealloc
{
	[name release];
	[quantity release];
    [note release];
	[super dealloc];
}
		   

@end
