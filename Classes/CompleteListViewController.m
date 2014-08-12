//
//  CompleteListViewController.m
//  Epicerie
//
//  Created by Pascal Viau on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CompleteListViewController.h"
#import "EPList.h"
#import "EPItem.h"
#import "GTHeaderView.h"

static BOOL isSection0Expanded = NO, isSection1Expanded = NO, isSection2Expanded = NO;
static NSUInteger kMAX_SECTION_0_ROWS = 5, kMAX_SECTION_1_ROWS = 3, kMAX_SECTION_2_ROWS = 4;


@implementation CompleteListViewController

@synthesize categoriesArray;
@synthesize header0, header1, header2;

/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSLog(@"Avant l'appel a SUPER");
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
	 [self createList];
 }
	NSLog(@"Voici ce que je retourne: %@", self);
 return self;
}
*/
/*
- (id) init
{
	[super initWithStyle:UITableViewStylePlain];
	[[NSBundle mainBundle] loadNibNamed:@"CompleteListViewController" owner:self options:nil];

	
		
	return self;
	
}*/


- (void) createList
{
	int numberOfItems1 = 10;
	int numberOfItems2 = 6;	
	[self setCategoriesArray: [NSArray arrayWithObjects:@"Categorie 1", @"Categorie 2", nil]];
	NSString *nameOfList = @"Liste d'items";
	NSMutableArray *listOfItems1=[[NSMutableArray alloc] init];
	NSMutableArray *listOfItems2=[[NSMutableArray alloc] init];
	NSMutableDictionary *listOfCategories =[[[NSMutableDictionary alloc] init] autorelease];
	
	for (int i=0; i<numberOfItems1 ; i++) {
		[listOfItems1 addObject:[EPItem randomItem]];
	}
	for (int j=0; j<numberOfItems2 ; j++) {
		[listOfItems2 addObject:[EPItem randomItem]];
	}
	
	[listOfCategories setObject:listOfItems1 forKey:[categoriesArray objectAtIndex:0]];
	[listOfCategories setObject:listOfItems2 forKey:[categoriesArray objectAtIndex:1]];
	
	
	completeList = [[EPList alloc] initWithName:nameOfList
										   list:listOfCategories];
}
/*
- (id)initWithStyle:(UITableViewStyle)style
{
	return [self init];
}*/

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {


	//[self numberOfRows:0];
	int numberOfRows=0;
	NSDictionary *listOfCategories=[completeList listOfCategories];
	NSString *category =  [categoriesArray objectAtIndex:section];

	numberOfRows = [[listOfCategories objectForKey:category] count];

	//If we are editing, we will have one more row than we have possessions
	if ([self isEditing]) {
		numberOfRows++;
	}
	//[category release];
	return numberOfRows;
}
/*
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
	return [self header0];
}*/

//**************** DATA SOURCE METHODS ************************************

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [categoriesArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:@"UITableViewCell"] autorelease];
    }
	
	// If the table view is filling a row with a possession in it, do as normal

	NSDictionary *listOfCategories=[completeList listOfCategories];
	NSArray *listOfItems =[[NSArray alloc] init];
	NSString *category =  [categoriesArray objectAtIndex:[indexPath indexAtPosition:0]];

	listOfItems = [listOfCategories objectForKey:category];

	if ([indexPath length] < [listOfItems count]) {
		NSString *itemName =
			[[listOfItems objectAtIndex:[indexPath indexAtPosition:1]] name];
		[[cell textLabel] setText:itemName];
	} else	{
		[[cell textLabel] setText:@"Add New Item..."];
	}
	//NSLog(@"Jusqu'a la fin");
	
	//[[cell textLabel] setText:@"Hello le monde"];
	return cell;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{	

	return [categoriesArray objectAtIndex:section];
}*/


//**************** HEADER METHODS ***************************************

- (void)viewDidLoad {
    [super viewDidLoad];
	//[[NSBundle mainBundle] loadNibNamed:@"CompleteListViewController" owner:self options:nil];
	[self createList];
	
	self.header0 = [GTHeaderView headerViewWithTitle:@"Fruits et légumes"];
	[self.header0.button addTarget:self action:@selector(toggleSection0) forControlEvents:UIControlEventTouchUpInside];
	self.header1 = [GTHeaderView headerViewWithTitle:@"Viandes et poissons"];
	[self.header1.button addTarget:self action:@selector(toggleSection1) forControlEvents:UIControlEventTouchUpInside];
	self.header2 = [GTHeaderView headerViewWithTitle:@"Another Section (2)"];
	[self.header2.button addTarget:self action:@selector(toggleSection2) forControlEvents:UIControlEventTouchUpInside];

}

- (NSArray*)indexPathsInSection:(NSInteger)section {
	NSMutableArray *paths = [NSMutableArray array];
	NSInteger row;
	
	for ( row = 0; row < [self numberOfRowsInSection:section]; row++ ) {
		[paths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
	}
	
	return [NSArray arrayWithArray:paths];
}
/*
- (void)toggle:(BOOL*)isExpanded section:(NSInteger)section {
	*isExpanded = !*isExpanded;
	
	NSArray *paths = [self indexPathsInSection:section];
	
	if ( !*isExpanded ) [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	else [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
}*/
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return kMAX_SECTION_0_ROWS;
			break;
		case 1:
			return kMAX_SECTION_1_ROWS;
			break;
		case 2:
			return kMAX_SECTION_2_ROWS;
			break;
		default:
			break;
	}
	return 0;
}

- (void)toggleSection0 {
	[self toggle:&isSection0Expanded section:0];
}
- (void)toggleSection1 {
	[self toggle:&isSection1Expanded section:1];
}
- (void)toggleSection2 {
	[self toggle:&isSection2Expanded section:2];
}

- (void)toggle:(BOOL*)isExpanded section:(NSInteger)section
{
}

#pragma mark -
#pragma mark UITableViewDelegate
/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case 0:
			return isSection0Expanded ? kMAX_SECTION_0_ROWS : 0;
			break;
		case 1:
			return isSection1Expanded ? kMAX_SECTION_1_ROWS : 0;
			break;
		case 2:
			return isSection2Expanded ? kMAX_SECTION_2_ROWS : 0;
			break;
		default:
			break;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [NSString stringWithFormat:@"Section %d, Row %d", indexPath.section, indexPath.row];
	
    return cell;
}*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	/*switch (section) {
		case 0:
			return header0;
			break;
		case 1:
			return header1;
			break;
		case 2:
			return header2;
			break;
		default:
			break;
	}*/
	//NSLog(@"header0: %@", header0);
	return header0;
}


//**************** DELELGATE METHODS ************************************



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[completeList release];
	[categoriesArray release];
	[header0 release];
	[header1 release];
	[header2 release];
	
    [super dealloc];
}


@end
