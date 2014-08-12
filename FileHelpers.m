/*
 *  FileHelpers.m
 *  Epicerie 0.0.2
 *
 *  Created by Pascal Viau on 11-04-12.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
	//Get list of document directories in sandbox
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	//Get one and only document directory from that list
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	
	//Append passed in file name to that directory, return it
	return [documentDirectory stringByAppendingPathComponent:fileName];
}