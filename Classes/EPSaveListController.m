//
//  EPSaveListController.m
//  Epicerie
//
//  Created by Pascal Viau on 11-06-03.
//  Copyright 2011 calepin. All rights reserved.
//

#import "EPSaveListController.h"
#import "ListViewController.h"


@implementation EPSaveListController

@synthesize lstViewController, saveDate;

- (id) init{

    [self initWithNibName:@"EPSaveListController" bundle:nil];
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
#pragma mark Selectors

- (IBAction)dismissController: (id)sender
{
    [lstViewController dismissModalViewControllerAnimated:YES];

}

- (IBAction)saveList: (id)sender
{
 
    if (![[textField text] isEqualToString:@""]) {
        [lstViewController saveListWithName:[textField text] date:saveDate];
        [self dismissController:sender];
    }
    
    else{

    }
    
}

- (IBAction)checkIfEmpty: (id) sender{
    if ([[textField text] isEqualToString:@""]) {
        saveButton.alpha=0.5;
    }
    else
        saveButton.alpha=1.0;

}


- (void)dealloc
{
    [lstViewController release];
    [textField release];
    [dateLabel release];
    [saveDate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setSaveDate:[NSDate date]];
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd/MM/yyyy, HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:saveDate];
    [dateLabel setText:dateString];
    saveButton.alpha=0.5;
}

- (void) showAlertWithTitle:(NSString*)title message:(NSString *)mess
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:mess
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [textField setText:@""];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
