//
//  EPCategory.h
//  Epicerie
//
//  Created by Pascal Viau on 11-02-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EPCategory : NSObject {
	
	NSString *categoryName;
	NSMutableArray *itemsList;

}

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSMutableArray *itemsList;


-(id) initWithCategoryName: (NSString*) name
				 itemsList: (NSMutableArray *) list;



-(id) initWithCategoryName: (NSString*) name;



@end
