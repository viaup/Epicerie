//
//  ListViewController.m
//  Epicerie
//
//  Created by Pascal Viau on 11-03-01.
//  Copyright 2011 __Calepin__. All rights reserved.
//

#import "ListViewController.h"
#import "RootViewController.h"
#import "ItemDetailViewController.h"
#import "EPItem.h"
#import "EPList.h"
#import "EPListHeaderView.h"
#import "EPPopUpNumber.h"
#import "EPSaveListController.h"
#import "EPLoadListController.h"

static NSUInteger MIN_ROWS = 12;
static NSString *NAME_OF_LIST=@"Ma liste";
static NSUInteger HEADERS_HEIGHT = 20;


@implementation ListViewController

@synthesize navController, rtViewController, detailViewController, tempList, popUp, categoriesArray, listHeadersArray, minRows;

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (isEmpty) {
		return 1;
	}
	else {
		
		return [[self categoriesArray] count];
	}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {		
	

	if (isEmpty) {
		return minRows+2;
	}
	
	else {
		
		//number of categories and items in list
		int nbOfRowsInList=0;
		for (NSString *category in categoriesArray) {
			for (EPItem *item in [[[rtViewController completeList] listOfCategories] objectForKey:category]) {
				if ([item isInCart]) {
					nbOfRowsInList++;
				}
			}
		}
		
		int numberOfRows =[[self listOfItemsInCartInSection:section] count];
		//if it's the last section and there's not enough cells to fill the screen
		if ((section == [categoriesArray count]-1) && nbOfRowsInList < minRows){
			//if the x is touched, remove 1 row
			if (xTouched) {
				return numberOfRows + minRows -nbOfRowsInList -1;
			}
			
			else {
				return numberOfRows + minRows -nbOfRowsInList;
			}
		}

		return numberOfRows;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Check for a reusable cell first, use that if it exists
	
	
	
	UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:@"UITableViewCell"] autorelease];
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
		[cell setBackgroundView:backgroundImage];
		[backgroundImage release];
		
    }
	
	NSMutableArray *listOfItemsInCart;
	
	if (isEmpty) {
		listOfItemsInCart=nil;
	}
	else {
		listOfItemsInCart = [self listOfItemsInCartInSection:indexPath.section];
	}
	
	
	
	//if the row correspond to a item in the list
	if (listOfItemsInCart && indexPath.row<[listOfItemsInCart count] ) {
		
		//if item is selected and is in cart
		if ([[listOfItemsInCart objectAtIndex:indexPath.row]isSelected] && [[listOfItemsInCart objectAtIndex:indexPath.row]isInCart]) {
			//add the blue line 
			UIImageView *selectedBkgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg_selected.png"]];
			[cell setBackgroundView:selectedBkgImage];
			[selectedBkgImage release];
			//add x mark
			UIButton *xMarkBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
			xMarkBtn.frame = CGRectMake(0, 0, 50, 50);
			[xMarkBtn setImage:[UIImage imageNamed:@"x_mark2.png"] forState:UIControlStateNormal];
			[xMarkBtn setTitle:[[listOfItemsInCart objectAtIndex:indexPath.row] name] forState:UIControlStateNormal];
			[xMarkBtn addTarget:self action:@selector(touchXMark:) forControlEvents:UIControlEventTouchUpInside];
			[cell setAccessoryView:xMarkBtn];
            
            //remove detail label
            cell.detailTextLabel.text = @"";
			
		}
		else {
			//remove the blue line
			UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
			[cell setBackgroundView:backgroundImage];
			[backgroundImage release];
            //add plus button
            
            UIButton *plusBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
            plusBtn.frame = CGRectMake(0, 0, 50, 50);
            if ([[[listOfItemsInCart objectAtIndex:indexPath.row] note] length]>0 &&
                [[[listOfItemsInCart objectAtIndex:indexPath.row] quantity] length]>0){
                [plusBtn setImage:[UIImage imageNamed:@"plus_star.png"] forState:UIControlStateNormal];
            }

            else if ([[[listOfItemsInCart objectAtIndex:indexPath.row] quantity] length]>0){
                [plusBtn setImage:[UIImage imageNamed:@"plus_blue.png"] forState:UIControlStateNormal];
            }
            else if ([[[listOfItemsInCart objectAtIndex:indexPath.row] note] length]>0){
                [plusBtn setImage:[UIImage imageNamed:@"plus_star.png"] forState:UIControlStateNormal];
            }
            
            else {
                [plusBtn setImage:[UIImage imageNamed:@"plus_grey.png"] forState:UIControlStateNormal];
            }
                
            
            cell.detailTextLabel.text = [[listOfItemsInCart objectAtIndex:indexPath.row] quantity];
            cell.detailTextLabel.font = [UIFont fontWithName:@"American Typewriter" size:16];
            cell.detailTextLabel.backgroundColor=[UIColor clearColor];
            
            [plusBtn setTitle:[[listOfItemsInCart objectAtIndex:indexPath.row] name] forState:UIControlStateNormal];
            [plusBtn addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
            [cell setAccessoryView:plusBtn];
            


		}
		
		
		NSString *name=[[[NSString alloc] initWithString:[[listOfItemsInCart objectAtIndex:indexPath.row] name]] autorelease];

        //truncate string to show detail label
        int maxLength=20
        - [[[listOfItemsInCart objectAtIndex:indexPath.row] quantity] length];
        if (![[[listOfItemsInCart objectAtIndex:indexPath.row] quantity]isEqualToString:@""] && [name length]>maxLength)
        {
            name=[[name substringToIndex:maxLength] stringByAppendingString:@"..."];
        }

		[[cell textLabel] setText:name];
		[[cell textLabel] setTextColor:[UIColor blackColor]];
		[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
        //[name release];
        
        

		
		
	}
	
	else{
		//empty cell with background image
		[[cell textLabel] setText:nil];
		UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cells_bg.png"]];
		[cell setBackgroundView:backgroundImage];
		[backgroundImage release];
		[cell setAccessoryView:nil];
	}

	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if ([[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]) {
		
		NSMutableArray *listOfItemsInCart=[self listOfItemsInCartInSection:indexPath.section];
		if (![[listOfItemsInCart objectAtIndex:indexPath.row]isSelected]) {
			[[listOfItemsInCart objectAtIndex:indexPath.row]setIsSelected:YES];
            
		}
		else {
			[[listOfItemsInCart objectAtIndex:indexPath.row]setIsSelected:NO];
		}
        [self popUpNumber];
	[self.tableView reloadData];	
	}
	else {
		[self loadProductsList];
	}

	
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//change the font
	[[cell textLabel] setFont:[UIFont fontWithName:@"American Typewriter" size:18.0]];
    

    if (![[cell textLabel] text]) {
        [[cell detailTextLabel] setText:@""];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (isEmpty) {
        return 0.0;
    }
    
    else{
        return HEADERS_HEIGHT;
    }
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (isEmpty) {
		return nil;
	}
	
	return [[self listHeadersArray] objectAtIndex:section];
}


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

#pragma mark -
#pragma mark Project methods

- (void)fillListOfItemsInCart {
	
	NSMutableDictionary *listOfCat=[[rtViewController completeList] listOfCategories];
    NSMutableArray *arrayOfCategories=[NSMutableArray arrayWithArray:[rtViewController categoriesArray]];
	NSMutableArray *listOfCategories=[[NSMutableArray alloc] init];
	NSMutableArray *arrayOfHeaders=[[NSMutableArray alloc] init]; 
    
	BOOL categoryIsInCart=NO;
	NSArray *listOfItems;
	
    if (!tempList) {
        tempList=[[EPList alloc] init];
        [tempList setListOfCategories:[[NSMutableDictionary alloc] init]];
        //[tempList setListName:[[NSString alloc] init]];
    }
    [[tempList listOfCategories] removeAllObjects];
    
	for (int i=0; i<[listOfCat count]; i++) {
        NSMutableArray *listOfItemsInCart=[[NSMutableArray alloc] init];
		
		listOfItems = [listOfCat objectForKey:[arrayOfCategories objectAtIndex:i]];
		for (EPItem *itemFromList in listOfItems) {
			if ([itemFromList isInCart]) {
                //list of items for tempList
                [listOfItemsInCart addObject:itemFromList];
				categoryIsInCart=YES;
			}
            
		}
		if (categoryIsInCart) {
			[listOfCategories addObject:[arrayOfCategories objectAtIndex:i]];
			EPListHeaderView *header = [EPListHeaderView headerViewWithTitle:[arrayOfCategories objectAtIndex:i]];
			[arrayOfHeaders addObject:header];
			categoryIsInCart=NO;
            
            
            
            //fill temporary list
            [[tempList listOfCategories] setObject:listOfItemsInCart forKey:[arrayOfCategories objectAtIndex:i]];
		}
        [listOfItemsInCart release];
	}
	
	
	[self setListHeadersArray:arrayOfHeaders];
	[self setCategoriesArray:listOfCategories];	
	
	if ([categoriesArray count]>0) {
		isEmpty=NO;
	}
	else {
		isEmpty=YES;
	}

	[arrayOfHeaders release];
	[listOfCategories release];
}


- (NSMutableArray *) listOfItemsInCartInSection: (NSInteger)section
{
	NSMutableArray *listOfItemsInCart= [[NSMutableArray alloc] init];
	NSIndexPath * newIndexPath= [NSIndexPath indexPathForRow:0 inSection:section];	
	NSArray *listOfItems= [[[rtViewController completeList] listOfCategories] objectForKey:
						   [[self categoriesArray] objectAtIndex:newIndexPath.section]];
	
	for (int i=0;i<[listOfItems count];i++) {
		if ([[listOfItems objectAtIndex:i] isInCart]) {
			[listOfItemsInCart addObject:[listOfItems objectAtIndex:i]];
		}
	}
	return [listOfItemsInCart autorelease];
	
}

- (void) popUpNumber
{

    //counter to count number of click
    countDisp++;

    CGRect labelFrame= popUp.remainLabel.frame;
    labelFrame.origin.y=6.0;
    /*
    CGRect popUpFrame = popUp.mainView.frame;
    popUpFrame.origin.y = 5.0;
    popUpFrame.origin.x = 70.0;
     */
    if (isDisplayed) {
        popUp.remainLabel.alpha=1.0;
        popUp.remainLabel.frame= labelFrame;
        popUp.centerButton.titleLabel.alpha=0.0;
        //popUp.mainView.alpha= 0.0;
        //popUp.mainView.frame = popUpFrame;
    }
    else
        popUp.remainLabel.alpha=0.0;
        //popUp.mainView.alpha= 1.0;
    
    popUp.remainLabel.text=[NSString stringWithFormat:@"reste : %@", [self selectedItemsCount]];
    //popUp.label.text=[NSString stringWithFormat:@"reste : %@", [self selectedItemsCount]];

  
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         popUp.remainLabel.alpha=1.0;
                         popUp.remainLabel.frame= labelFrame;
                         popUp.centerButton.titleLabel.alpha=0.0;
                         //popUp.mainView.frame = popUpFrame;
                         //popUp.mainView.alpha= 0.0;
                         //popUp.bkgImage.alpha= 1.0;
                     } 
                     completion:^(BOOL finished){
                         isDisplayed=YES;
                         CGRect labelFrame= popUp.remainLabel.frame;
                         labelFrame.origin.y=20.0;
                         //CGRect popUpFrame = popUp.mainView.frame;
                         //popUpFrame.origin.y = 20.0;
                         [UIView animateWithDuration:0.3
                                               delay:1.5
                                             options: UIViewAnimationCurveEaseOut
                                          animations:^{
                                              popUp.remainLabel.alpha=0.0;
                                              popUp.remainLabel.frame= labelFrame;
                                            popUp.centerButton.titleLabel.alpha=1.0;
                                              //popUp.mainView.alpha= 1.0;
                                              //popUp.mainView.frame = popUpFrame;
                                              
                                              //popUp.bkgImage.alpha= 1.0;
                                          } 
                                          completion:^(BOOL finished){
                                              //NSLog(@"Retarct!");
                                              countDisp--;
                                              if (countDisp==0) {
                                                  isDisplayed=NO;
                                              }
                                              
                                          }];
                     }];    

}

- (NSString *) selectedItemsCount
{
    
    int isNotSelectedCount=0;
    int inCartCount=0;
    
    
    for (NSString *categorie in categoriesArray) {
        for (EPItem *item in [[[rtViewController completeList] listOfCategories] objectForKey:categorie]) {
            if ([item isInCart]) {
                inCartCount++;
                if (![item isSelected])  {
                    isNotSelectedCount++;
                    
                    
                }
            }


        }
    }
    
    return [NSString stringWithFormat:@"%d / %d", isNotSelectedCount, inCartCount];

}

- (void) popUpActionSheet
{

    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil
															delegate:self
												   cancelButtonTitle:@"Annuler"
											  destructiveButtonTitle:nil
												   otherButtonTitles: @"Enregistrer la liste", @"Sélectionner une liste", @"Envoyer par courriel", nil];
	
	[actionSheet showInView:[self tableView]];
	[actionSheet release];
}

//present the modal view to save a list
- (void) showSaveListController
{
    buttonCanMove=NO;
    if(saveListController == nil){
        saveListController = [[EPSaveListController alloc] init];
        
    }
    
    [saveListController setLstViewController:self];
    
    [self presentModalViewController:saveListController animated:YES];


}



//present the modal view to load a liste
- (void) showLoadListController{

    buttonCanMove=NO;
    if(loadListController == nil){
        loadListController = [[EPLoadListController alloc] init];
        [loadListController setLstViewController:self];
    }
    
    NSString *savedListsPath=pathInDocumentDirectory(@"savedLists.data");
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath]) {
        [loadListController setSavedLists:nil];
        [loadListController setSavedLists:[NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath]];
    }

    [[loadListController tableView] reloadData];
    [self presentModalViewController:loadListController animated:YES];
}

- (void) sendEmail{

    if ([MFMailComposeViewController canSendMail])
	{
        
		
		MFMailComposeViewController *eMailController = [[MFMailComposeViewController alloc] init];
		eMailController.mailComposeDelegate = self;
        NSString *messageBody=[self composeEmail];
		[eMailController setSubject:@"liste d'épicerie"];
		[eMailController setMessageBody:messageBody isHTML:YES];
        buttonCanMove=NO;
		[self presentModalViewController:eMailController animated:YES];
		[eMailController release];
		
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device is not set up for email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}

}

- (NSString *) composeEmail{
    
    NSString *listForEmail = @"";
    NSString *notes = @"";
    
    
    for (int i=0; i<[[self listHeadersArray] count];i++) {
//        NSLog(@"list of headers %@", [[[[self listHeadersArray] objectAtIndex:i]label] text]);
        NSMutableArray *list =[self listOfItemsInCartInSection:i];
        listForEmail = [listForEmail stringByAppendingFormat:@"<p style='background-color:#F8F8F8;'>%@ :</p>",[[[[self listHeadersArray] objectAtIndex:i]label] text]];
        
        for (EPItem *item in list) {
            if (![[item quantity] isEqualToString:@""] && ![[item note] isEqualToString:@""]){
                notes=[NSString stringWithFormat:@"(%@, %@)", [item quantity], [item note]];
            }
            else if(![[item quantity] isEqualToString:@""] || ![[item note] isEqualToString:@""]){
                notes=[NSString stringWithFormat:@"(%@%@)", [item quantity], [item note]];
            
            }
            else{
                notes=@"";
            }
            listForEmail = [listForEmail stringByAppendingFormat:@"<p style='padding:0px 20px 0px 25px; border-bottom-style:solid ;border-bottom-width:1px;border-bottom-color:#DDEEFF'>%@ %@<input type='checkbox' style='float:right; position:relative; top:1px;'/></p>",[item name], notes];
        }
    }
    
    
    
    return listForEmail;

}


- (void) getListAtIndex:(NSInteger)index replaceList:(BOOL)replaced
{

    NSMutableArray *savedLists=[[[NSMutableArray alloc] init] autorelease];//+1
    NSString *savedListsPath=pathInDocumentDirectory(@"savedLists.data");
    
    //get the list from archive
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath]) {
        savedLists = [NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath];
    }
    
    //NSLog(@"savedList %@", [savedLists objectAtIndex:index]);
    
    //NSString *completeName=[[[NSString alloc]init] autorelease];
    //NSString *selectedName=[[[NSString alloc] init] autorelease];
    
    //loop in the complete liste
    for (NSString *category in [[rtViewController completeList] listOfCategories]) {
        
        //int i=0;
        for (int i=0; i<[[[[rtViewController completeList] listOfCategories] objectForKey:category] count];i++) {
            EPItem *completeArrayItem=[[[[rtViewController completeList] listOfCategories] objectForKey:category] objectAtIndex:i];

            
            NSString *completeName=[NSString stringWithString:[completeArrayItem name]];
            //if the list in the savedLists has the category 
            if ([[[savedLists objectAtIndex:index]listOfCategories] objectForKey:category]){
                for (EPItem *selectedArrayItem in [[[savedLists objectAtIndex:index]listOfCategories] objectForKey:category]) {
                    
                    NSString *selectedName=[NSString stringWithString:[selectedArrayItem name]];
                    
                                            
                    //NSLog(@"selectedItem name %@", [selectedArrayItem name]);
                    NSRange anchoredResultsRange = [completeName rangeOfString:selectedName
                                                                                   options:(NSLiteralSearch | NSBackwardsSearch)];
                    //if item is in selected list, replace item
                    if (anchoredResultsRange.length > 0 && [completeName length]==[selectedName length]){
                        //if the item is selected, deselect
                        [selectedArrayItem setIsSelected:NO];
                        //if in add mode, keep the quantity and note values if there's no value already 
                        if (!replaced && (![[completeArrayItem quantity] isEqualToString:@""] || ![[completeArrayItem note] isEqualToString:@""]) ) {
                            [selectedArrayItem setQuantity:[completeArrayItem quantity]];
                            [selectedArrayItem setNote:[completeArrayItem note]];
                        }
                        
                        
                        [[[[rtViewController completeList] listOfCategories] objectForKey:category] replaceObjectAtIndex:i withObject:selectedArrayItem];

                        
                    }
                    
                }
            }
            
            else if (replaced){
                [completeArrayItem setQuantity:@""];
                [completeArrayItem setNote:@""];
                [completeArrayItem setIsSelected:NO];
                [completeArrayItem setIsInCart:NO];
            }
            //[completeName release];
        }
        
        //i++;
    }

    //[completeName release];
    //[selectedName release];
    
    [[self tableView] reloadData];

}

#pragma mark -
#pragma mark MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{    
	switch (result)
	{
		case MFMailComposeResultCancelled:
		{
			break;
		}
		case MFMailComposeResultSaved:
		{
			break;
		}
		case MFMailComposeResultSent:
		{
			break;
		}
		case MFMailComposeResultFailed:
		{
			break;
		}
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Email Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			break;
	}
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    minRows=MIN_ROWS;
	[self fillListOfItemsInCart];
	[self setTitle:NAME_OF_LIST];
	xTouched=NO;
    countDisp=0;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Produits"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(loadProductsList)];

	
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Effacer"
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(emptyList)];
	self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.hidesBackButton=YES;
    
    if (isEmpty) {
        self.navigationItem.leftBarButtonItem = nil;
        
    }
    else {
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    if (!popUp) {
        popUp=[[EPPopUpNumber alloc] init];
        [popUp setLsViewController:self];
        CGRect popUpFrame = popUp.mainView.frame;
        popUpFrame.origin.y = 20.0;
        popUpFrame.origin.x = 70.0;
        popUp.mainView.frame=popUpFrame;
        popUp.mainView.alpha= 1.0;
        [self.parentViewController.view addSubview:popUp.mainView];
    }
    
    else {
    
        if (buttonCanMove) {
            CGRect popUpFrame = popUp.mainView.frame;
            popUpFrame.origin.y = 20.0;
            popUpFrame.origin.x = 70.0;
            
            
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options: UIViewAnimationCurveEaseInOut
                             animations:^{
                                 popUp.mainView.frame = popUpFrame;
                                 popUp.mainView.alpha= 1.0;
                                 //popUp.bkgImage.alpha= 1.0;
                             } 
                             completion:^(BOOL finished){
                                 
                             }];  
        }

    
    }
    

	
	
	[rightButton release];
	[leftButton release];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    buttonCanMove=YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (buttonCanMove) {
        [self setTitle:NAME_OF_LIST];
        CGRect popUpFrame = popUp.mainView.frame;
        popUpFrame.origin.y = 20.0;
        popUpFrame.origin.x = 0.0;
        
        
        
        
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             popUp.mainView.frame = popUpFrame;
                             popUp.mainView.alpha= 0.0;
                             //popUp.bkgImage.alpha= 1.0;
                         } 
                         completion:^(BOOL finished){
                             
                         }];  
    }
    

}


#pragma mark -
#pragma mark Selectors


- (void) loadProductsList
{
	/*
	if (!rtViewController) {
		rtViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	}*/
	[[self navController] pushViewController:rtViewController
									animated:YES];
	
}

- (void) touchXMark: (id) sender
{
	[[self tableView] reloadData];
	for (int i=0; i<[categoriesArray count]; i++) {
		//int j=0;
		for (int j=0; j<[[self listOfItemsInCartInSection:i] count]; j++) {
	
            //find the item to delete
			if ([[[[self listOfItemsInCartInSection:i] objectAtIndex:j] name] isEqualToString:[sender titleForState:UIControlStateNormal]]) {
				
				NSArray *paths =[NSArray arrayWithObject:[NSIndexPath indexPathForRow:j inSection:i]];
                [[[self listOfItemsInCartInSection:i] objectAtIndex:j]setQuantity:@""];
                [[[self listOfItemsInCartInSection:i] objectAtIndex:j]setNote:@""];
				[[[self listOfItemsInCartInSection:i] objectAtIndex:j]setIsSelected:NO];
				[[[self listOfItemsInCartInSection:i] objectAtIndex:j]setIsInCart:NO];
				xTouched=YES;
				[self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
				xTouched=NO;
				
                //remove from tempList
                [[[tempList listOfCategories] objectForKey:[categoriesArray objectAtIndex:i]]removeObjectAtIndex:j];
	

				[[rtViewController tableView] reloadData];
                [self popUpNumber];
				return;
			}
			
		}
	}
	
}

//show the item detail view
- (void) showDetailView: (id) sender
{
    buttonCanMove=NO;
    int nbItemsInList=0;
    for (int i=0; i<[categoriesArray count]; i++) {
		for (int j=0; j<[[self listOfItemsInCartInSection:i] count]; j++) {
            nbItemsInList++;
            //find the item to delete
			if ([[[[self listOfItemsInCartInSection:i] objectAtIndex:j] name] isEqualToString:[sender titleForState:UIControlStateNormal]]) {
                /*
                [self setMinRows:16];
                [[self tableView] reloadData];
                NSIndexPath * newIndexPath= [NSIndexPath indexPathForRow:j inSection:i];
                [[self tableView] scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];*/
                
                //Add the overlay view.
                if(detailViewController == nil){
                    detailViewController = [[ItemDetailViewController alloc] initWithNibName:@"ItemDetailViewController" bundle:[NSBundle mainBundle]];
                    
                }
                
                
                [detailViewController setLstViewController:self];
                [detailViewController setItem:[[self listOfItemsInCartInSection:i] objectAtIndex:j]];

                /*
                CGFloat yaxis = CELLS_HEIGHT*nbItemsInList + HEADERS_HEIGHT*(i+1) ;
                CGFloat width = self.view.frame.size.width;
                CGFloat height = self.view.frame.size.height-50;
                
                //Parameters x = origion on x-axis, y = origon on y-axis.
                CGRect frame = CGRectMake(0, yaxis, width, height);
                detailViewController.view.frame = frame;
                detailViewController.view.backgroundColor = [UIColor grayColor];
                //detailViewController.view.alpha = 0.5;
                
                
                [self.tableView insertSubview:detailViewController.view aboveSubview:self.parentViewController.view];*/
                [self presentModalViewController:detailViewController animated:YES];
			}
			
		}
	}

}

- (void) emptyList
{
    //action sheet to delete liste
	UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:@"Que voulez vous effacer ?"
															delegate:self
												   cancelButtonTitle:@"Annuler"
											  destructiveButtonTitle:nil
												   otherButtonTitles: @"Les produits raturés", @"La liste complète", nil];
	
	[actionSheet showInView:[self tableView]];
	[actionSheet release];
    /*
	//action sheet to delete liste
	UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:@"Voulez-vous effacer toute la liste ?\n(Pour effacer un seul produit, appuyer sur le symbole X après l'avoir sélectionné)"
															delegate:self
												   cancelButtonTitle:@"Annuler"
											  destructiveButtonTitle:@"Effacer"
												   otherButtonTitles: nil];
	
	[actionSheet showInView:[self tableView]];
	[actionSheet release];
	*/
}

- (void) saveListWithName:(NSString *)name date:(NSDate *)date{
    

    
    NSMutableArray *savedLists=[[[NSMutableArray alloc] init] autorelease];
    NSString *savedListsPath=pathInDocumentDirectory(@"savedLists.data");
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath]) {
        //NSLog(@"from archive...");
        savedLists = [NSKeyedUnarchiver unarchiveObjectWithFile:savedListsPath];
    }
    
    
    [tempList setListName:name];
    [tempList setDateSaved:date];
    [savedLists addObject:tempList];


    
    

	
	[NSKeyedArchiver archiveRootObject:savedLists toFile:savedListsPath];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //menu effacer
    if ([[actionSheet title] isEqualToString:@"Que voulez vous effacer ?"]) {
        //effacer les produits rayés
        if (buttonIndex==0) {
            //effacer les produits rayés
            for (NSString *category in [[rtViewController completeList] listOfCategories]) {
                int i=0;
                for (EPItem *item in [[[rtViewController completeList] listOfCategories] objectForKey:category]) {
                    if ([item isSelected]) {
                        [item setQuantity:@""];
                        [item setNote:@""];
                        [item setIsInCart:NO];
                        [item setIsSelected:NO];
                        
                        //remove from tempList
                        [[[tempList listOfCategories] objectForKey:category] removeObjectAtIndex:i];
                        
                    }
                    if ([item isInCart]) {
                        i++;
                    }
                    
                }
            }
            if ([[[[self selectedItemsCount]componentsSeparatedByString:@"/"] objectAtIndex:0] intValue]==0){
                self.navigationItem.leftBarButtonItem=nil;
                //self.navigationItem.leftBarButtonItem.enabled = NO;
                isEmpty=YES;            
            }

            [[rtViewController tableView] reloadData];
            [[self tableView] reloadData];

        }
        //effacer la liste complète
        if (buttonIndex==1) {
            UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:@"Voulez-vous vraiment effacer toute la liste ?"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Annuler"
                                                      destructiveButtonTitle:@"Effacer"
                                                           otherButtonTitles: nil];
            
            [actionSheet showInView:[self tableView]];
            [actionSheet release];

        }
        
    }
    //effacer liste complète
    else if ([[actionSheet title] isEqualToString:@"Voulez-vous vraiment effacer toute la liste ?"]) {
        if (buttonIndex==0) {
            //effacer les produits rayés
            
            for (NSString *category in [[rtViewController completeList] listOfCategories]) {
                for (EPItem *item in [[[rtViewController completeList] listOfCategories] objectForKey:category]) {
                    if ([item isInCart]) {
                        [item setQuantity:@""];
                        [item setNote:@""];
                        [item setIsInCart:NO];
                        [item setIsSelected:NO];
                        
                    }
                }
            }
            self.navigationItem.leftBarButtonItem=nil;
            isEmpty=YES;
            [[rtViewController tableView] reloadData];
            [[self tableView] reloadData];
            
        }    
    
    
    
    }
    
    else{
        if (buttonIndex==0) {
            
            [self showSaveListController];
        }
        else if (buttonIndex==1){
            [self showLoadListController];
        }
        
        else if (buttonIndex==2){
            [self sendEmail];
        }
        
    }


	
}


#pragma mark -
#pragma mark Memory management

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
	[navController release];
	[rtViewController release];
    [detailViewController release];
    [saveListController release];
    [loadListController release];
    //[savedLists release];
    [tempList release];
    [popUp release];
	[categoriesArray release];
	[listHeadersArray release];
    [super dealloc];
}


@end
