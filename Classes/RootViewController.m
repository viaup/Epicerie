//
//  RootViewController.m
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-02-21.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "RootViewController.h"
#import "OverlayViewController.h"
#import "EPList.h"
#import "EPItem.h"
#import "GTHeaderView.h"
#import "EPIdentHeaderView.h"
#import "EPExpandedHeaderView.h"
#import "CJSONDeserializer.h"
#import "EPAddItemViewController.h"

//static NSUInteger MAX_SECTION_0_ROWS = 10, MAX_SECTION_1_ROWS = 6;
static NSUInteger MAX_STRING_LENGTH_EDIT = 18;

@implementation RootViewController

@synthesize completeList, categoriesArray, editingCategoriesArray, searchBar, headersArray, rightButton, 
aCopyOfListItems, ovController, addItemViewController, indexPathForProduct, indexPathForActionSheet;




#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	//if completeList is not set
	if (!completeList) {
		//check if there's data saved
		if ([NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(@"list.data")]) {
			//NSLog(@"from archive...");
			[self getListFromArchive];
		}
		else {
			//NSLog(@"from JSON...");
			[self getListFromJSON];
		}

		
	}
	
	//add search bar
	//[self addSearchBar];
	//set navbar title
	[self setTitle:[[self completeList] listName]];
	//create right button
	rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sections"
												   style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(editingButtonPressed:)];
	//[rightButton setTitle:@"Ordonner"];
	
	self.navigationItem.rightBarButtonItem = rightButton;
	//set editingCategoriesArray
	if (!editingCategoriesArray) {
		editingCategoriesArray= [[NSMutableArray alloc] init];
	}
	//isDeleting=NO;

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![self isEditing]){
        [self addSearchBar];
    }
    
    
}


- (void)viewDidDisappear:(BOOL)animated
{
	if (searching) {
		[self doneSearching_Clicked:nil];
	}
}

/*
- (void) viewWillAppear:(BOOL)animated
{
}*/


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	//searching
	if (searching)
		return 1;
	//editing
	else if([self isEditing]){
		return 1;
	}
	else
		return [categoriesArray count];
}


// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	//searching
	if (searching)
		return [aCopyOfListItems count];
	//editing
	else if	([self isEditing]){
		return [editingCategoriesArray count];
	}
	else {
		BOOL isItExpanded = [[[headersArray objectAtIndex:section] objectForKey:@"normal"] isSectionExpanded];
		int itemCount = [[[completeList listOfCategories] objectForKey:
						  [categoriesArray objectAtIndex:section]] count];
		
		return isItExpanded ? itemCount : 0;	
	}


}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:@"UITableViewCell"] autorelease];
		//background image of the cell
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
		[cell setBackgroundView:backgroundImage];
		[backgroundImage release];

    }
    cell.textLabel.alpha=1.0;
	//searching
	if(searching){
        UIImageView *backgroundImage;
        //if no item found
        //first row
        if ([[[aCopyOfListItems objectAtIndex:0] name] isEqualToString:@"Ajouter dans la section :"]) {
            if (indexPath.row==0) {
                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_bg_selected.png"]];
            }
            else{
                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_bg.png"]];
            }
            
        }
        
        else if ([[[aCopyOfListItems objectAtIndex:[aCopyOfListItems count]-1] name] isEqualToString:@"Ajouter..."]) {
            
            if (indexPath.row==[aCopyOfListItems count]-1) {
                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg_add.png"]];
                cell.textLabel.alpha=0.5;
            }
            
            else
                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
        }
        
        else{
            backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
        }
		
		[cell setBackgroundView:backgroundImage];
		[backgroundImage release];
		[[cell textLabel] setText:[[aCopyOfListItems objectAtIndex:indexPath.row]name]];
		//add a checkmark if the item is in cart
		if ([[aCopyOfListItems objectAtIndex:indexPath.row] isInCart]) {
			UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkMark.png"]];
			cell.accessoryView = checkMark;
			[checkMark release];
		}
		else {
			cell.accessoryView = nil;
		}
        //[self addSearchBar];
	}
	//editing
	else if([self isEditing]){
		NSString *nameOfItem= [categoriesArray objectAtIndex:[indexPath row]];
		//to shorten the section name
		if ([nameOfItem length]>MAX_STRING_LENGTH_EDIT) {
			nameOfItem = [[nameOfItem substringToIndex:MAX_STRING_LENGTH_EDIT] stringByAppendingString:@"..."];
		}
		[[cell textLabel] setText:nil];
		//background image of the «section», which is in fact a row, with identation
		EPIdentHeaderView *identHeader = [EPIdentHeaderView headerViewWithTitle:nameOfItem];
		[cell setBackgroundView:identHeader];
	}
	
	else {
		//get the items in the section
		NSArray *items = [self listOfItemsWithIndexPath:indexPath];
		//get the item for the row
		EPItem *item= [items objectAtIndex:indexPath.row];
		NSString *itemName=[item name];
		[[cell textLabel] setText:itemName];
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
		[cell setBackgroundView:backgroundImage];
		[backgroundImage release];
		//add a checkmark if the item is in cart
		if ([item isInCart]) {
			UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkMark.png"]];
			cell.accessoryView = checkMark;
			[checkMark release];
		}
		else {
			cell.accessoryView = nil;
		}
	}
	[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return @"Supprimer";
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 

	NSDictionary *listOfCategories=[completeList listOfCategories];
	NSArray *listOfItems;
	NSString *category =  nil;
	NSString *selectedItemName = nil;
	
	//searching
	if(searching){

        
		int j;
		//get the selected item
		selectedItemName = [[aCopyOfListItems objectAtIndex:[indexPath indexAtPosition:1]]name];
        
        if ([[[aCopyOfListItems objectAtIndex:0] name] isEqualToString:@"Ajouter dans la section :"]) {
            
            if (![selectedItemName isEqualToString:@"Ajouter dans la section :"]) {
                if ([selectedItemName isEqualToString:@"Nouvelle section..."])  {
                    [self showAddItemViewWithActionMode:@"lastSection"];
                    return;
                }
                else {
                     [self addProduct:[[self searchBar] text] toSection:selectedItemName];

                }
               
            }
        }
        // if ajouter... is pressed
        else if ([[[aCopyOfListItems objectAtIndex:[aCopyOfListItems count]-1] name] isEqualToString:@"Ajouter..."]) {

            addCellSelected=YES;
            [self searchTableView];
        }
        
		for (int i=0; i<[categoriesArray count]; i++) {
			//get the header to toggle section
			GTHeaderView *header =[[headersArray objectAtIndex:i] objectForKey:@"normal"];
			j=0;
			listOfItems = [listOfCategories objectForKey:[categoriesArray objectAtIndex:i]];
			for (EPItem *itemFromList in listOfItems) {
				//if it is the selected item
             
				if ([[itemFromList name] isEqualToString: selectedItemName]) {
					//is in cart or not
                    
					if ([itemFromList isInCart]) {
						[itemFromList setIsInCart:NO];
					}
					else {
						[itemFromList setIsInCart:YES];
					}
					//quit searching mode
					[self performSelector:@selector(doneSearching_Clicked:)];
					//toggle the section to see the selected item
					if (![header isSectionExpanded]) {
						[self toggleSection:[header button]];
					
					}
					//scroll to see the selected item
					NSIndexPath * newIndexPath= [NSIndexPath indexPathForRow:j inSection:i];
					[tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
				}
				j++;
			}
           
		}
		self.tableView.tableHeaderView = searchBar;
	}
	else {
		category =  [categoriesArray objectAtIndex:[indexPath indexAtPosition:0]];
		listOfItems = [listOfCategories objectForKey:category];
		EPItem *item= [listOfItems objectAtIndex:[indexPath indexAtPosition:1]];
		if ([item isInCart] || [[item name] isEqualToString:@"[Section vide]"]) {
			[item setIsInCart:NO];
		}
		else {
			[item setIsInCart:YES];
		}
		
	}

	[self.tableView reloadData];

}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (searching || [self isEditing]) {
		return 0.0;
	}
    else{
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	//searching
	if (searching || [self isEditing]) {
		return nil;
	}
	//to eventually change the aspect of the header while expanded (to add later)
	else if ([[[headersArray objectAtIndex:section] objectForKey:@"normal"] isSectionExpanded])
	{
		return [[headersArray objectAtIndex:section] objectForKey:@"expanded"];
	}
		
	else	
		return [[headersArray objectAtIndex:section] objectForKey:@"normal"];
}


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searching) {
        if ([[[aCopyOfListItems objectAtIndex:0] name] isEqualToString:@"Ajouter dans la section :"]) {
            if (indexPath.row!=0) {
                return 5;
            }
            else{
                return 3;
            }
            
        }
        
    }
	return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
	[[cell textLabel] setFont:[UIFont fontWithName:@"American Typewriter" size:18.0]];
}


#pragma mark -
#pragma mark Expanding sections

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	return [[[completeList listOfCategories] objectForKey:
			 [categoriesArray objectAtIndex:section]] count];
}

//-Il y a toujours soit zéro ou une section ouverte
//-Déceler celle qui est ouverte (celle marquée comme ouverte).
//-Déceler la section touchée.
//-Si la section touchée == la section ouverte, on fait rien.
//-On ferme d'abord la section ouverte. On la marque comme fermée.
//-On ouvre ensuite la section touchée. On la marque comme ouverte

- (void)toggleSection:(id)sender {


	int indexSelected= [headersArray count];
    int indexExpanded= [headersArray count];
    
	
	//find the section by comparing buttons
	for (int i=0; i<[headersArray count]; i++) {
		
		//if the header is touched
		if ([[[headersArray objectAtIndex:i] objectForKey:@"normal"] button] == sender ||
			[[[headersArray objectAtIndex:i] objectForKey:@"expanded"] button] == sender) {
			indexSelected=i;	

		}
        
        // if the header is expanded
        if ( [[[headersArray objectAtIndex:i] objectForKey:@"normal"] isSectionExpanded] ){
            indexExpanded=i;
        }

	}
    
    
    [[self tableView] beginUpdates];
    //si une section est ouverte mas pas sélectionnée
    if (indexExpanded<[headersArray count]) {
        NSArray *expandedPaths = [self indexPathsInSection:indexExpanded];
        [[[headersArray objectAtIndex:indexExpanded] objectForKey:@"normal"] setIsSectionExpanded:NO];

        [self.tableView deleteRowsAtIndexPaths:expandedPaths withRowAnimation:UITableViewRowAnimationFade];

        
    }

    if (indexSelected<[headersArray count] && indexExpanded != indexSelected) {
        NSArray *selectedPaths = [self indexPathsInSection:indexSelected];
        [[[headersArray objectAtIndex:indexSelected] objectForKey:@"normal"] setIsSectionExpanded:YES];

        [self.tableView insertRowsAtIndexPaths:selectedPaths withRowAnimation:UITableViewRowAnimationFade];

        
    }
    [[self tableView] endUpdates];

    if (indexExpanded<indexSelected) {
        [self.tableView scrollToRowAtIndexPath:[[NSIndexPath indexPathWithIndex:indexSelected] indexPathByAddingIndex:0]
                              atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
//	[[self tableView] reloadData];
}


- (NSArray*)indexPathsInSection:(NSInteger)section {

	NSMutableArray *paths = [NSMutableArray array];
	NSInteger row;
	
	for ( row = 0; row < [self numberOfRowsInSection:section]; row++ ) {
		[paths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
	}
	
	return [NSArray arrayWithArray:paths];
}


#pragma mark -
#pragma mark Editing

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self isEditing] && [indexPath row] == [possessions count]) {
		// The last row during editing will show an insert style button
		return UITableViewCellEditingStyleInsert;
	}
	// All other rows remain deleteable
	return UITableViewCellEditingStyleDelete;
}
 
 
 
 - (NSIndexPath *)tableView:(UITableView *)tableView
 targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
 toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
 {
	if ([proposedDestinationIndexPath row] < [possessions count]) {
	//If we are moving to a row that currently is showing a possession,
	// the we return te row the user wanted to move to
 return proposedDestinationIndexPath;
	}
	//We get here if we are trying to move a row to under "Add New Item..."
	//row, have the moving row go one row above it instead.
	NSIndexPath *betterIndexPath =
	[NSIndexPath indexPathForRow:[possessions count] - 1 inSection:0];
 
	return	betterIndexPath;
 }
*/

 - (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
 {
		   
	
	//If the table view is asking to commit a delete command
	//if (editingStyle==UITableViewCellEditingStyleDelete) {
     [self setIndexPathForActionSheet:indexPath];
     [self setIndexPathForProduct:indexPath];
        
        //add or remove section, add product
        if ([self isEditing]) {
            
            NSString *deleteSectionTitle =[NSString stringWithFormat:
                                           @"Voulez-vous supprimer définitivement la section « %@ » et tous ses produits ?",
                                           [categoriesArray objectAtIndex:[indexPath row]]];
            
            
            //confirmation action sheet
			[self showActionSheetWithTitle:deleteSectionTitle
						 cancelButtonTitle:@"Annuler"
					destructiveButtonTitle:@"Supprimer"];
            /*
            NSString *modificationTitle =[NSString stringWithFormat:@"Section « %@ »",
                                          [categoriesArray objectAtIndex:[indexPath row]]];
            
            //show options in an action sheet
            UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:modificationTitle
                                                                    delegate:self
                                                           cancelButtonTitle:@"Annuler"
                                                      destructiveButtonTitle:@"Supprimer la section"
                                                           otherButtonTitles:@"Ajouter une section", @"Ajouter un produit", nil];
            
            [actionSheet showInView:[self tableView]];
            [actionSheet release];*/
        }
        
        //remove product
        else{
            if ([[[[[completeList listOfCategories] objectForKey:
                    [categoriesArray objectAtIndex:[indexPath section]]]
                   objectAtIndex:[indexPath row]] name] isEqualToString:@"[Section vide]"]) {
                [self showActionSheetWithTitle:@"La section est déjà vide." 
                             cancelButtonTitle:@"Annuler"
                        destructiveButtonTitle:nil];
            }
            
            
			[self showActionSheetWithTitle:@"Voulez-vous supprimer définitivement ce produit ?" 
						 cancelButtonTitle:@"Annuler"
					destructiveButtonTitle:@"Supprimer"];
        
        }
    


		
		
	//}
     /*
	//if in insert style
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self setIndexPathForActionSheet:indexPath]; 

	}*/
 }
 
//to move the «section» that are in fact rows
 - (void)tableView:(UITableView *)tableView
 moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
 toIndexPath:(NSIndexPath *)toIndexPath
 {
	 NSString *category =[categoriesArray objectAtIndex:[fromIndexPath row]];
	 GTHeaderView *header =[headersArray objectAtIndex:[fromIndexPath row]];
 
	//Retain category and header so that it is not deallocated when it is removes from the array
	 [category retain];
	 [header retain];

 
	//Remove them from our arrays, it is automatically sent release
	 [categoriesArray removeObjectAtIndex:[fromIndexPath row]];
	 [headersArray removeObjectAtIndex:[fromIndexPath row]];

 
	//Re-insert them into arrays at new location, it is automatically retained
	  [categoriesArray insertObject:category atIndex:[toIndexPath row]];
	  [headersArray insertObject:header atIndex:[toIndexPath row]];

	 [category release];
	[header release];

	 
 }
 

- (void) editingButtonPressed: (id) sender
{
	//if in editing mode
	if ([self isEditing]) {
		
		
		NSMutableArray *paths=[[NSMutableArray alloc] init];
		
		//fill paths
		for (int i=0; i<[[self editingCategoriesArray] count]; i++) {
			[paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		}
		
		//empty the array
		[[self editingCategoriesArray] removeObjectsInArray:[self categoriesArray]];
		[sender setTitle:@"Sections"];
		
		self.tableView.tableHeaderView = searchBar;
		[[self tableView] beginUpdates];
		[[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
		//fill the array
		[editingCategoriesArray setArray:categoriesArray];
 
		[self setEditing:NO animated:YES];
		//a set of section indexes TO ADD (count-1)
		NSIndexSet *set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [categoriesArray count]-1)]; 
		[[self tableView] insertSections:set withRowAnimation:UITableViewRowAnimationFade];

		[[self tableView] endUpdates];
		
		[set release];
		[paths release];
		
	}
	
	else {
		
		//remove the search bar
		self.tableView.tableHeaderView = nil;

		NSMutableArray *paths=[[NSMutableArray alloc] init];
		
		[editingCategoriesArray setArray:categoriesArray];
		for (int i=0; i<[editingCategoriesArray count]; i++) {
			[paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [[[headersArray objectAtIndex:i] objectForKey:@"normal"] setIsSectionExpanded:NO];
		}
		[sender setTitle:@"Terminé"];
		[self setEditing:YES animated:YES];
		[[self tableView] reloadData];
		[[self tableView] reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
		[[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

		[paths release];
	}
	
	
		
}

- (void)setEditing:(BOOL)flag
		  animated:(BOOL)animated
{
	//Always call super implementation of this method, it needs to do work
	[super setEditing:flag animated:animated];
 

}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    
    if (searching) {
		 return UITableViewCellEditingStyleNone;
	 }  
	else {
		return UITableViewCellEditingStyleDelete;
	}


}




#pragma mark -
#pragma mark Search bar


//Adding the search bar
- (void) addSearchBar {
	if (!aCopyOfListItems) {
		aCopyOfListItems =[[NSMutableArray alloc] init];
	}

	self.tableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.placeholder= @"Rechercher ou ajouter";
	[searchBar setShowsCancelButton:NO animated:NO];
	searching = NO;
	letUserSelectRow = YES;
}

//Handling events
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {

	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.7;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    //[self.tableView insertSubview:ovController.view aboveSubview:self.navigationController.navigationBar];
	
	
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	
	// Set the return key and keyboard appearance of the search bar
	for (UIView *searchBarSubview in [searchBar subviews]) {
		
		if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
			
			@try {
				
				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
				[(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
				[(UITextField *)searchBarSubview setDelegate:self];
			}
			@catch (NSException * e) {
				
				// ignore exception
			}
		}
	}
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Terminé" style:UIBarButtonItemStyleDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

//Searching the table view
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[aCopyOfListItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
        [self.tableView reloadData];
	}
	else {
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
        [self.tableView reloadData];
        [self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	}
	
	//[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	NSMutableDictionary * listOfCategories = [completeList listOfCategories];
	
    //if the user don't want to add anyway the product
    if (!addCellSelected) {
        for (NSString *category in listOfCategories)
        {
            NSArray *array = [listOfCategories objectForKey:category];
            [searchArray addObjectsFromArray:array];
        }
        
        //anchored search results first in the list
        for (EPItem *iTemp in searchArray)
        {
            
            NSRange anchoredResultsRange = [[iTemp name] rangeOfString:searchText
                                                               options:(NSAnchoredSearch | NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch)];
            
            if (anchoredResultsRange.length > 0){
                [aCopyOfListItems addObject:iTemp];
            }
        }
        
        
        //other search results
        for (EPItem *iTemp in searchArray)
        {
            
            NSRange anchoredResultsRange = [[iTemp name] rangeOfString:searchText
                                                               options:(NSAnchoredSearch | NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch)];
            NSRange otherResultsRange = [[iTemp name] rangeOfString:searchText
                                                            options:(NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch)];
            
            if (otherResultsRange.length > 0 && anchoredResultsRange.length <=0){
                [aCopyOfListItems addObject:iTemp];
            }
        }
    }
	
    
    //if he want to add it anyway
    else{
        [aCopyOfListItems removeAllObjects];
        addCellSelected=NO;
    
    }

    //if the item is not in the list
    if ([aCopyOfListItems count] ==0) {
        
        EPItem *addToSectionItem=[[EPItem alloc]initWithName:@"Ajouter dans la section :"];
        EPItem *addNewSectionItem=[[EPItem alloc]initWithName:@"Nouvelle section..."];
        [aCopyOfListItems addObject:addToSectionItem];
        [aCopyOfListItems addObject:addNewSectionItem];
        [addToSectionItem release];
        [addNewSectionItem release];

        
        for (NSString *cat in categoriesArray) {
            EPItem *catItem=[[EPItem alloc]initWithName:cat];
            [aCopyOfListItems addObject:catItem];
            [catItem release];
        }
    }
    else {
        EPItem *addItem=[[EPItem alloc]initWithName:@"Ajouter..."];
        [aCopyOfListItems addObject:addItem];
        [addItem release];
    }
	
	[searchArray release];
	searchArray = nil;
}

//finish searching
- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = rightButton;
	self.tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self doneSearching_Clicked:nil];
	return NO;
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//NSString *modificationTitle =[NSString stringWithFormat:@"Section « %@ »",
	//							  [categoriesArray objectAtIndex:[indexPathForActionSheet row]]];
	//NSString *deleteSectionTitle =[NSString stringWithFormat:
	//							   @"Voulez-vous supprimer définitivement la section « %@ » et tous ses produits ?",
	//							   [categoriesArray objectAtIndex:[indexPathForActionSheet section]]];
	
	//remove product
	if ([[actionSheet title] isEqualToString:@"Voulez-vous supprimer définitivement ce produit ?"]) {
		if (buttonIndex == 0) {
            
			//if there's just 1 item, replace by «section vide»
			if ([[[completeList listOfCategories] objectForKey:
                 [categoriesArray objectAtIndex:[indexPathForProduct section]]] count]==1
                ) {
				EPItem *emptySection =[[EPItem alloc] initWithName:@"[Section vide]"];
				
				[[[completeList listOfCategories] objectForKey:
				  [categoriesArray objectAtIndex:[indexPathForProduct section]]]
				 replaceObjectAtIndex:[indexPathForProduct row] withObject:emptySection];
				[emptySection release];
				
				
				[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForProduct]
										withRowAnimation:UITableViewRowAnimationNone];
			}
			
			
			else {
                
				[[[completeList listOfCategories] objectForKey:
				  [categoriesArray objectAtIndex:[indexPathForProduct section]]] removeObjectAtIndex:[indexPathForProduct row]];
				
				//We also remove that row from the table view with an animation
				[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForProduct]
										withRowAnimation:UITableViewRowAnimationNone];
			}

		}
		//do nothing
		else {
			//NSLog(@"user pressed Cancel");
		}
	}
    
/*    
	//sections modification
	else if([[actionSheet title] isEqualToString:modificationTitle]){
		//add product and section button
		if (buttonIndex == 1 || buttonIndex == 2){
            
            if (buttonIndex == 1) {
                [self showAddItemViewWithActionMode:@"section"];
            }
            
            else{
                [self showAddItemViewWithActionMode:@"product"];
            }
*/            
            
            /*
			 if (!addItemViewController) {
			 addItemViewController =[[EPAddItemViewController alloc]
			 initWithSectionName:[categoriesArray objectAtIndex:[indexPathForActionSheet row]]];
			 [addItemViewController setRtViewController:self];
			 }
			 else {
			 [addItemViewController setSectionName:[categoriesArray objectAtIndex:[indexPathForActionSheet row]]];
			 }
			if (buttonIndex == 1) {
				[addItemViewController setActionMode:@"section"];
			}
			else {
				[addItemViewController setActionMode:@"product"];
			}

			 [self presentModalViewController:addItemViewController animated:YES];*/
		/*}
		//delete section button
		else if (buttonIndex == 0){
			//confirmation action sheet
			[self showActionSheetWithTitle:deleteSectionTitle
						 cancelButtonTitle:@"Annuler"
					destructiveButtonTitle:@"Supprimer"];
			
		}

	}
*/	
	//delete section
	//else if([[actionSheet title] isEqualToString:deleteSectionTitle])
    else
	{
		if (buttonIndex == 0) {
			[headersArray removeObjectAtIndex:[indexPathForActionSheet row]];
			[[completeList listOfCategories]
			 removeObjectForKey:[editingCategoriesArray objectAtIndex:[indexPathForActionSheet row]]];
			[categoriesArray removeObjectAtIndex:[indexPathForActionSheet row]];
			[editingCategoriesArray removeObjectAtIndex:[indexPathForActionSheet row]];

			
			//We also remove that row from the table view with an animation
			[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForActionSheet]
									withRowAnimation:UITableViewRowAnimationNone];

		}

	}

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




#pragma mark -
#pragma mark Project methods


- (void) addProduct:(NSString *)product toSection:(NSString *)section;
{

    //add product
    
    //cap product name
    NSString *firstCapChar = [[product substringToIndex:1] capitalizedString];
    NSString *cappedString = [product stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    NSString *itemExisting;
    
    //new item with capped name
    EPItem * newItem=[[EPItem alloc] initWithName:cappedString];
    
    //will be in product list
    [newItem setIsInCart:YES];
    
    NSMutableArray *listOfItems=[self.completeList.listOfCategories
                                 objectForKey:section];
    
    
     //if section is empty, remove item "[Section vide]" before adding a new one
    if ([[[listOfItems objectAtIndex:0] name] isEqualToString:@"[Section vide]"])
    {
        [listOfItems removeLastObject];
    }
    
    //insert in order
    int orderIndex=0;
    BOOL alreadyExisting=NO;
    for (int itemIndex=0; itemIndex<[listOfItems count]; itemIndex++) {
        

        NSString *s1=[[listOfItems objectAtIndex:itemIndex] name];
        NSString *s2=product;
        NSComparisonResult result = [s1 compare:s2
                                        options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)
                                          range:NSMakeRange(0, [s1 length])
                                         locale:[NSLocale currentLocale]];
        
        if (result==NSOrderedAscending ) {
            orderIndex++;
        }
        
        if (result==0) {
            itemExisting=s1;
            alreadyExisting=YES;
        }
        
    }
    
    //if the product doesn't already exist
    if (!alreadyExisting) {
        [listOfItems insertObject:newItem atIndex:orderIndex];
    }
    else {
        //alert if the product is already in the section
        NSString *title= [NSString stringWithFormat:@" « %@ »", itemExisting];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:@"Ce produit est déjà dans la section"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [newItem release];

    [[self rightButton] setTitle:@"Sections"];
    int aSection=[[self categoriesArray] indexOfObject:section];
    
    for (int i=0; i<[[self headersArray] count]; i++) {
        if (i==aSection) {
            [[[[self headersArray] objectAtIndex:i] objectForKey:@"normal"] setIsSectionExpanded:YES];
        }
        else {
            [[[[self headersArray] objectAtIndex:i] objectForKey:@"normal"] setIsSectionExpanded:NO];
        }
        
    }
    [self setEditing:NO animated:YES];
    [[self tableView] reloadData];
    
    
    [self doneSearching_Clicked:nil];
    //add search bar
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    //scroll to the proper position
    NSIndexPath * newIndexPath= [NSIndexPath indexPathForRow:orderIndex inSection:aSection];
    
    [[self tableView] scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
	
    

}


- (void) showAddItemViewWithActionMode: (NSString *) actionMode{

    if (!addItemViewController) {
        addItemViewController =[[EPAddItemViewController alloc]
                                initWithSectionName:[[categoriesArray objectAtIndex:[indexPathForActionSheet section]]autorelease]];
        [addItemViewController setRtViewController:self];
    }
    else {
        [addItemViewController setSectionName:[[categoriesArray objectAtIndex:[indexPathForActionSheet section]]autorelease]];
    }

    [addItemViewController setActionMode:actionMode];
    [addItemViewController setProductName:searchBar.text];


    
    [self presentModalViewController:addItemViewController animated:YES];


}


//create the complete list
- (void) getListFromJSON
{
	//read data from JSON
	NSString* path = [[NSBundle mainBundle] pathForResource:@"list" 
													 ofType:@"json"];

	NSData *jsonData =[NSData dataWithContentsOfFile:path];
	NSError *error = nil;
	id listObject = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
	
	NSString *category=nil;
	NSMutableArray *categories=[[NSMutableArray alloc] init];//autorelease
	NSMutableDictionary *listOfCat =[[NSMutableDictionary alloc] init]; //autorelease
	NSString *nameOfList = @"Produits";
	NSMutableArray *arrayOfHeaders = [[NSMutableArray alloc] init]; //autorelease

	//category in the json
	for (category in listObject) {
		[categories addObject:category];
		NSMutableArray *listOfNames = [[NSMutableArray alloc] init];
		

		//fill listOfNames
		for (int i=0; i<[ [listObject objectForKey:category] count]; i++) {
			//capitalize the string
			NSString *firstCapChar = [[[[listObject objectForKey:category] objectAtIndex:i] substringToIndex:1] capitalizedString];
			NSString *cappedString = [[[listObject objectForKey:category] objectAtIndex:i] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
			[listOfNames addObject:cappedString];
		}
        
        //if the category in the NSMutableArray doesn't exist
		if (![listOfCat objectForKey:category]) {
			[listOfCat setObject:[NSMutableArray arrayWithCapacity:[listOfNames count]] forKey:category];
		}
		//sort listOfNames
		[listOfNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		//fill the dictionnary
		for (int j=0; j<[listOfNames count]; j++) {
			[[listOfCat objectForKey:category] addObject:[[EPItem alloc] initWithName:[listOfNames objectAtIndex:j]]];
		}
		[listOfNames release];
			 
	}
	//sort categories	 
	[categories sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	//creation of headers
	for (NSString *cat in categories) {
		
		GTHeaderView *header = [GTHeaderView headerViewWithTitle:cat];
		[header.button addTarget:self action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];
		[header setIsSectionExpanded:NO];
		

		EPExpandedHeaderView *expandedHeader = [EPExpandedHeaderView headerViewWithTitle:cat];
		[expandedHeader.button addTarget:self action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];
		[header setIsSectionExpanded:NO];
		
		//dictionary that hold header for normal state or expanded state (not in use right now)
		NSMutableDictionary * headerDict=[[NSMutableDictionary alloc] init];
		[headerDict setObject:header forKey:@"normal"];
		[headerDict setObject:expandedHeader forKey:@"expanded"];

		[arrayOfHeaders addObject:headerDict];
		
	}
	[category release];
	
	[self setCategoriesArray:categories];
	[self setHeadersArray:arrayOfHeaders];

	
	completeList = [[EPList alloc] initWithName:nameOfList
										   list:listOfCat];
	 
	[categories release];
	[listOfCat release];
	[arrayOfHeaders release];


}

- (void) getListFromArchive
{
	//Get path of archive file
	NSString *listPath=pathInDocumentDirectory(@"list.data");
	NSString *categoriesPath=pathInDocumentDirectory(@"categories.data");
	//NSString *headersPath=pathInDocumentDirectory(@"headers.data");
	[self setCompleteList:[NSKeyedUnarchiver unarchiveObjectWithFile:listPath]];
	[self setCategoriesArray:[NSKeyedUnarchiver unarchiveObjectWithFile:categoriesPath]];
	
	NSMutableArray *arrayOfHeaders = [[NSMutableArray alloc] init];
	for (NSString *cat in [self categoriesArray]) {
		
		GTHeaderView *header = [GTHeaderView headerViewWithTitle:cat];
		[header.button addTarget:self action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];
		[header setIsSectionExpanded:NO];
		
		
		EPExpandedHeaderView *expandedHeader = [EPExpandedHeaderView headerViewWithTitle:cat];
		[expandedHeader.button addTarget:self action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];
		[header setIsSectionExpanded:NO];
		
		//dictionary that hold header for normal state or expanded state (not in use right now)
		NSMutableDictionary * headerDict=[[NSMutableDictionary alloc] init];
		[headerDict setObject:header forKey:@"normal"];
		[headerDict setObject:expandedHeader forKey:@"expanded"];
		
		[arrayOfHeaders addObject:headerDict];
		
	}
	[self setHeadersArray:arrayOfHeaders];
	[arrayOfHeaders release];
}


//get an array of items at the given indexPath
- (NSArray *) listOfItemsWithIndexPath: (NSIndexPath *)indexPath
{
	NSDictionary *listOfCategories=[completeList listOfCategories];
	//NSArray *listOfItems =[[NSArray alloc] init];
	NSString *category =  [categoriesArray objectAtIndex:[indexPath indexAtPosition:0]];
	
	NSArray *listOfItems = [listOfCategories objectForKey:category];
	return listOfItems;
}

- (void) showActionSheetWithTitle:(NSString*)title
				cancelButtonTitle:(NSString*)cancel
		   destructiveButtonTitle:(NSString*)destructive
{
	UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:title
															delegate:self
												   cancelButtonTitle:cancel
											  destructiveButtonTitle:destructive
												   otherButtonTitles:nil];
	[actionSheet showInView:[self tableView]];
	[actionSheet release];

}


/*
- (void) showAlertWithTitle:(NSString*)title message:(NSString *)mess
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:mess
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Annuler", nil];
	[alertView show];
	[alertView release];
}*/
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		
		(@"user pressed OK");
		canDelete=YES;
	}
	else {
		NSLog(@"user pressed Cancel");
		canDelete=NO;
	}
}

*/

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return YES;
 }
 
*/


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




- (void)dealloc {
	[completeList release];
	[categoriesArray release];
	[editingCategoriesArray release];
	[headersArray release];
	[addItemViewController release];
	[rightButton release];
	[ovController release];
	[aCopyOfListItems release];
	[searchBar release];
	[indexPathForActionSheet release];
    [super dealloc];
	
}


@end

