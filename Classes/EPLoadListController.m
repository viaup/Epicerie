//
//  EPLoadListController.m
//  Epicerie
//
//  Created by Pascal Viau on 11-06-07.
//  Copyright 2011 calepin. All rights reserved.
//

#import "EPLoadListController.h"
#import "ListViewController.h"
#import "EPList.h"


static NSUInteger MIN_ROWS = 7;

@implementation EPLoadListController

@synthesize tableView, lstViewController, selectedIndex, savedLists;

- (id) init{

    [self initWithNibName:@"EPLoadListController" bundle:nil];
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

		return 1;

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {		
	
    if ([savedLists count]< MIN_ROWS) {
        if (isDeleting) {
            return MIN_ROWS-1;
        }
        
        else
            return MIN_ROWS;
    }
    
    else
		return [savedLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Check for a reusable cell first, use that if it exists
	
	
    
    
	UITableViewCell *cell = 
	[[self tableView] dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:@"UITableViewCell"] autorelease];
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
		[cell setBackgroundView:backgroundImage];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listCells_bg_selected.png"]]];
		[backgroundImage release];
		
    }

    if (savedLists && indexPath.row<[savedLists count] ){
        
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
        NSString *dateString = [dateFormatter stringFromDate:[[savedLists objectAtIndex:[indexPath row]] dateSaved]];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *hourString = [dateFormatter stringFromDate:[[savedLists objectAtIndex:[indexPath row]] dateSaved]];
        
        
        [[cell textLabel] setText:[[savedLists objectAtIndex:[indexPath row]] listName]];
        [[cell textLabel] setTextColor:[UIColor blackColor]];
        [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
        
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@\n%@", dateString, hourString]];
        [[cell detailTextLabel] setTextColor:[UIColor blackColor]];
        [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
        [[cell detailTextLabel] setAlpha:0.2];
        [[cell detailTextLabel] setFont:[UIFont fontWithName:@"American Typewriter" size:10.0]];
        [[cell detailTextLabel] setNumberOfLines:2];
        
        [cell setUserInteractionEnabled:YES];
    }
    
    else{
		//empty cell with background image
		[[cell textLabel] setText:nil];
        [[cell detailTextLabel] setText:nil];
        [cell setUserInteractionEnabled:NO];
	}
        
    
    
    
    
    
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!selectedIndex) {
    }
    addButton.alpha=1.0;
    replaceButton.alpha=1.0;
    selectedIndex=[indexPath row];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//change the font
	[[cell textLabel] setFont:[UIFont fontWithName:@"American Typewriter" size:18.0]];
    
}
/*
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    
	//If the table view is asking to commit a delete command
	if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        [savedLists removeObjectAtIndex:[indexPath row]];
        if ([savedLists count]==0) {
            addButton.alpha=0.5;
            replaceButton.alpha=0.5;
            [titleLabel setText:@"Aucune liste enregistrée"];
        }
        
        if ([savedLists count] < MIN_ROWS) {
            isDeleting=YES;
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationNone];
            isDeleting=NO;
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:
                                                      [NSIndexPath indexPathForRow:MIN_ROWS-1 inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
        else {
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationNone];
        }

		
		
	}

}

- (void)tableView:(UITableView *)aTableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Swipe !");
    
}

/*
- (void)setEditing:(BOOL)flag
		  animated:(BOOL)animated
{
	//Always call super implementation of this method, it needs to do work
    NSLog(@"Swipe !");
	[super setEditing:flag animated:animated];
    
    
}*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.userInteractionEnabled) {
        return UITableViewCellEditingStyleDelete;
    }
    
    else
        return UITableViewCellEditingStyleNone;
}


/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

}

*/

#pragma mark -
#pragma mark Selectors

- (IBAction)dismissController: (id)sender
{

    NSString *savedListsPath=pathInDocumentDirectory(@"savedLists.data");

	[NSKeyedArchiver archiveRootObject:savedLists toFile:savedListsPath];
    [lstViewController dismissModalViewControllerAnimated:YES];
    
    
}

- (IBAction)addList: (id)sender
{

    // if the list is not empty
    if ([savedLists count]>0 && selectedIndex>=0) {
        [lstViewController getListAtIndex:selectedIndex replaceList:NO];
        [self dismissController:sender];
    }
    

}
- (IBAction)replaceList: (id)sender
{
    // if the list is not empty
    

    if ([savedLists count]>0 && selectedIndex>=0){
        [lstViewController getListAtIndex:selectedIndex replaceList:YES];
        [self dismissController:sender];
    }
    
}

- (void)dealloc
{
    [tableView release];
    [titleLabel release];
    [addButton release];
    [replaceButton release];
    [lstViewController release];
    [savedLists release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!savedLists) {
        savedLists=[[NSMutableArray alloc] init];
    }
    
    NSString *savedListsPath=pathInDocumentDirectory(@"savedLists.data");
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath]) {
        //NSLog(@"from archive...");
        [self setSavedLists:[NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath]];
    }

    
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    addButton.alpha=0.5;
    replaceButton.alpha=0.5;

    
    if ([savedLists count]==0) {
        [titleLabel setText:@"Aucune liste enregistrée"];
        //addButton.alpha=0.5;
        //replaceButton.alpha=0.5;
        
    }
    else {
        [titleLabel setText:@"Sélectionnez une liste"];
        //addButton.alpha=1.0;
        //replaceButton.alpha=1.0;
    }   
        
    selectedIndex=-1;
    
    isDeleting=NO;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
