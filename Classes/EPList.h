//
//  EPList.h
//  Epicerie
//
//  Created by Pascal Viau on 11-02-08.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EPList : NSObject <NSCoding> {
	
	NSMutableDictionary *listOfCategories;
	NSString *listName;
	NSDate *dateSaved;

}

@property (nonatomic, retain) NSMutableDictionary *listOfCategories;
@property (nonatomic, copy) NSString *listName;
@property (nonatomic, retain) NSDate *dateSaved;


- (id) initWithName: (NSString *) lname;

- (id) initWithName: (NSString *) lname
			   list: (NSMutableDictionary *) lst;



@end
