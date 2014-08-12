//
//  EPAddItemViewController.m
//  Epicerie 0.0.2
//
//  Created by Pascal Viau on 11-03-19.
//  Copyright 2011. All rights reserved.
//

#import "EPAddItemViewController.h"
#import "GTHeaderView.h"
#import	"EPExpandedHeaderView.h"
#import "RootViewController.h"
#import "EPItem.h"
#import "EPList.h"



@implementation EPAddItemViewController

@synthesize rtViewController, sectionName, productName, actionMode, firstLine, secondLine, textField;


- (id) initWithSectionName:(NSString  *)sectName
{
	self=[super initWithNibName:@"EPAddItemViewController" bundle:nil];
	[self setSectionName:sectName];

	return self;

}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        addProductViewController =[EPAddProductViewController alloc] initWithNibName:[EPAddProductViewController bundle:mainBundle];
    }
    return self;
}
*/

#pragma mark -
#pragma mark UIViewController

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
}*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//to show the keyboard
	[textField becomeFirstResponder];
	//set text of the view
	if ([actionMode isEqualToString:@"section"]) {
		[[self firstLine] setText:@"Ajouter une section "];
		[[self secondLine] setText:[NSString stringWithFormat:@" après « %@ »", [self sectionName]]];
	}
    
    else if ([actionMode isEqualToString:@"lastSection"]){
        [[self firstLine] setText:@"Ajouter une section "];
		[[self secondLine] setText:[NSString stringWithFormat:@" pour le produit « %@ »", [self productName]]];
    }
	else {
		[[self firstLine] setText:@"Ajouter un produit "];
		[[self secondLine] setText:[NSString stringWithFormat:@" dans « %@ »", [self sectionName]]];
	}

	
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark IBAction

- (IBAction)addButtonPressed: (id)sender
{
    
	
	//if textfield is empty, do nothing
	if ([[textField text] isEqualToString:@""]) {
		return;
	}
	
	//add product
	if ([actionMode isEqualToString:@"product"]){
        [self addProduct];
	}
	
	//add section 
	else {
        [self addSection];
	}
	//empty the textfield
	[[self textField] setText:@""];

    [self dismissController:nil];
    NSIndexPath * newIndexPath;
    if ([actionMode isEqualToString:@"lastSection"]){
        newIndexPath= [NSIndexPath indexPathForRow:NSNotFound inSection:[[rtViewController categoriesArray] count]-1];
        
    }
    else if ([actionMode isEqualToString:@"section"]){
        newIndexPath= [NSIndexPath indexPathForRow:[[rtViewController categoriesArray] indexOfObject:sectionName] inSection:0];
        

    }
    
    [[rtViewController tableView] scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


- (IBAction)dismissController: (id)sender
{
	[rtViewController dismissModalViewControllerAnimated:YES];
    if ([actionMode isEqualToString:@"lastSection"]){
        [rtViewController doneSearching_Clicked:nil];
    }   
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self addButtonPressed:nil];
	//[self dismissController:nil];
	return NO;
}


#pragma mark -
#pragma mark Class methods

- (void) addProduct{
    
    NSString *itemExisting=[[[NSString alloc] init] autorelease];
    NSString *firstCapChar = [[[textField text] substringToIndex:1] capitalizedString];
    NSString *cappedString = [[textField text] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    
    EPItem * newItem=[[EPItem alloc] initWithName:cappedString];
    //if section is empty, remove item "[Section vide]" before adding a new one
    NSMutableArray *listOfItems=[[[rtViewController completeList] listOfCategories]
                                 objectForKey:sectionName];
    if ([[[listOfItems objectAtIndex:0] name] isEqualToString:@"[Section vide]"])
    {
        [listOfItems removeLastObject];
    }
    
    //insert in order
    int orderIndex=0;
    BOOL alreadyExisting=NO;
    for (int itemIndex=0; itemIndex<[listOfItems count]; itemIndex++) {
        
        //NSString *s1=[[NSString alloc] init];
        //NSString *s2=[[NSString alloc] init];
        NSString *s1=[[listOfItems objectAtIndex:itemIndex] name];
        NSString *s2=[textField text];
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
    rtViewController.tableView.tableHeaderView = rtViewController.searchBar;
    //[listOfItems release];
    [[rtViewController rightButton] setTitle:@"Modifier"];
    int section=[[rtViewController categoriesArray] indexOfObject:sectionName];
    
    for (int i=0; i<[[rtViewController headersArray] count]; i++) {
        if (i==section) {
            [[[[rtViewController headersArray] objectAtIndex:i] objectForKey:@"normal"] setIsSectionExpanded:YES];
        }
        else {
            [[[[rtViewController headersArray] objectAtIndex:i] objectForKey:@"normal"] setIsSectionExpanded:NO];
        }
        
    }
    [rtViewController setEditing:NO animated:YES];
    [[rtViewController tableView] reloadData];
    
    //add search bar
    rtViewController.tableView.tableHeaderView = rtViewController.tableView.tableHeaderView;
    //scroll to the proper position
    NSIndexPath * newIndexPath= [NSIndexPath indexPathForRow:orderIndex inSection:section];
    [[rtViewController tableView] scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

}

- (void) addSection{

    
    NSString *itemExisting=[[[NSString alloc] init] autorelease];
    
    //new array to add for new key
    NSMutableArray *newArray =[[[NSMutableArray alloc] init] autorelease];
    EPItem * emptyItem=[[EPItem alloc] initWithName:@"[Section vide]"];//modify so it cannot be selected !!!
    [newArray addObject:emptyItem];
    [emptyItem release];
    //capitalize first letter
    NSString *firstCapChar = [[[textField text] substringToIndex:1] capitalizedString];
    NSString *cappedString = [[textField text] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    
    //new header
    GTHeaderView *header = [GTHeaderView headerViewWithTitle:cappedString];
    [header.button addTarget:rtViewController action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];


    [header setIsSectionExpanded:NO];

    
    //new expandedHeader
    EPExpandedHeaderView *expandedHeader = [EPExpandedHeaderView headerViewWithTitle:cappedString];
    [expandedHeader.button addTarget:rtViewController action:@selector(toggleSection:) forControlEvents:UIControlEventTouchUpInside];
    [header setIsSectionExpanded:NO];
    
    //verify if new section already exist
    BOOL alreadyExisting=NO;
    for (int i=0; i<[[rtViewController editingCategoriesArray] count]; i++) {
        
        
        NSString *s1=[[rtViewController editingCategoriesArray] objectAtIndex:i];
        NSString *s2=[textField text];
        NSComparisonResult result = [s1 compare:s2
                                        options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)
                                          range:NSMakeRange(0, [s1 length])
                                         locale:[NSLocale currentLocale]];
        
        if (result==0) {
            itemExisting=s1;
            alreadyExisting=YES;
        }
    }
    
    //if it doesn't exist
    if (!alreadyExisting) {
        //find the index of the section (+1 to put it after)
        int sectionIndex;
        //if action mode is lastindex (add section frome search bar)
        if ([actionMode isEqualToString:@"lastSection"]){
            sectionIndex=[[rtViewController categoriesArray] count];
        }
        else{
            sectionIndex=[[rtViewController categoriesArray] indexOfObject:sectionName]+1;
        }
        
        //set the new, empty section
        [[[rtViewController completeList] listOfCategories] setObject:newArray forKey:cappedString];
        
        //set headers
        NSMutableDictionary * headerDict=[[[NSMutableDictionary alloc] init] autorelease];
        [headerDict setObject:header forKey:@"normal"];
        [headerDict setObject:expandedHeader forKey:@"expanded"];
        
        // if the last element of the array is selected, add instead of insert
        if (sectionIndex == [[rtViewController categoriesArray] count]) {
            [[rtViewController categoriesArray] addObject:cappedString];
            if (rtViewController.isEditing) {
                [[rtViewController editingCategoriesArray] addObject:cappedString];
            }
            [[rtViewController headersArray] addObject:headerDict];
        }
        else{
            [[rtViewController categoriesArray] insertObject:cappedString atIndex:sectionIndex];
            if (rtViewController.isEditing) {
                [[rtViewController editingCategoriesArray] insertObject:cappedString atIndex:sectionIndex];
            }
            [[rtViewController headersArray] insertObject:headerDict atIndex:sectionIndex];
        }
    }
    else {
        //alert if the product is already in the section
        NSString *title= [NSString stringWithFormat:@" « %@ »", itemExisting];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:@"Cette section existe déjà"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    //add the product to the section
    [rtViewController addProduct:productName toSection:cappedString];
    self.productName=nil;
    [self.productName release];
    //NSLog(@"productNameAddSection %d", [productName retainCount]);
    [[rtViewController tableView] reloadData];


}


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)dealloc {
	[rtViewController release];
	[sectionName release];
    [productName release];
	[actionMode release];
	[firstLine release];
	[secondLine release];
	[textField release];
    [super dealloc];
}


@end
