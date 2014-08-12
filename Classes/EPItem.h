//
//  EPItem.h
//  Epicerie
//
//  Created by Pascal Viau on 11-02-07.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EPItem : NSObject <NSCoding> {
	
	NSString *name;
	NSString *quantity;
    NSString *note;
	BOOL isSelected;
	BOOL isInCart;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isInCart;

+ (id) randomItem; 

- (id) initWithName: (NSString *) itName;

- (id) initWithName: (NSString *) itName
		   quantity: (NSString*) itQty;



@end
