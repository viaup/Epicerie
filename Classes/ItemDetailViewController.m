//
//  ItemDetailViewController.m
//  Epicerie
//
//  Created by Pascal Viau on 11-05-11.
//  Copyright 2011 calepin. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ListViewController.h"
#import "EPItem.h"


@implementation ItemDetailViewController

@synthesize lstViewController, item, itemNameLabel, plusBtn, plus_grey, plus_blue, plus_star;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setPlus_grey:[UIImage imageNamed:@"plus_grey.png"]];
        [self setPlus_star:[UIImage imageNamed:@"plus_star.png"]];
        [self setPlus_blue:[UIImage imageNamed:@"plus_blue.png"]];
    }
    return self;
}



#pragma mark -
#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UITextView delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[textView text] length]>0 && [[qtyField text] length]>0){
        [plusBtn setImage:plus_star forState:UIControlStateNormal];
    }
    
    else if ([[qtyField text] length]>0){
        [plusBtn setImage:plus_blue forState:UIControlStateNormal];
    }
    else if ([[textView text] length]>0){
        [plusBtn setImage:plus_star forState:UIControlStateNormal];
    }
    else
        [plusBtn setImage:plus_grey forState:UIControlStateNormal];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if([[textView text]
        length] > 70){

        //if we want to do a backspace
        if ([text length] ==0) {
            return YES;
        }
        
        if ([text isEqualToString:@"\n"]){
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
        }
    
        return NO;
    }
    
    // Any new character added is passed in as the "text" parameter
    else if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }

    else{
        return YES;
    }
    
}

#pragma mark -
#pragma mark Selectors

- (IBAction)dismissController: (id)sender
{
    [lstViewController dismissModalViewControllerAnimated:YES];
    [item setQuantity:[qtyField text]];
    [item setNote:[noteField text]];
}

- (IBAction)emptyQtyField: (id)sender
{
    [qtyField setText:@""];
    [detailLabel setText:[qtyField text]];
    if ([[noteField text] length]>0){
        [plusBtn setImage:plus_star   forState:UIControlStateNormal];
    }
    else
        [plusBtn setImage:plus_grey forState:UIControlStateNormal];
    
}

- (IBAction)emptyNoteField: (id)sender
{
    [noteField setText:@""];
    if ([[qtyField text] length]>0){
        [plusBtn setImage:plus_blue forState:UIControlStateNormal];
    }
    else
        [plusBtn setImage:plus_grey forState:UIControlStateNormal];
    
}

- (IBAction)qtyEditingChanged: (id)sender
{
    [detailLabel setText:[qtyField text]];
    if ([[noteField text] length]>0 && [[qtyField text] length]>0){
        [plusBtn setImage:plus_star forState:UIControlStateNormal];
    }
    else if ([[qtyField text] length]>0){
        [plusBtn setImage:plus_blue forState:UIControlStateNormal];
    }
    else if ([[noteField text] length]>0){
        [plusBtn setImage:plus_star forState:UIControlStateNormal];
    }
    else
        [plusBtn setImage:plus_grey forState:UIControlStateNormal];

}

#pragma mark -
#pragma mark Memory management


- (void)dealloc
{
    
    [lstViewController release];
    [item release];
    [itemNameLabel release];
    [detailLabel release];
    [qtyField release];
    [noteField release];
    [plusBtn release];
    [plus_grey release];
    [plus_blue release];
    [plus_star release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!itemNameLabel) {
        itemNameLabel=[[UILabel alloc] init];
    }
    if (!detailLabel) {
        detailLabel=[[UILabel alloc] init];        
    }
    
    if (!plusBtn) {
        plusBtn =[[UIButton alloc] init] ;
    }
    
    
    if (!qtyField) {
        qtyField=[[UITextField alloc] init];
    }
    if (!noteField) {
        noteField=[[UITextView alloc] init];
    }
    [itemNameLabel setText:[item name]];
    [detailLabel setText:[item quantity]];
    
    [qtyField setText:[item quantity]];
    [noteField setText:[item note]];
    
    if ([[item note] length]>0 && [[item quantity] length]>0){
        [plusBtn setImage:plus_star forState:UIControlStateNormal];
    }
    else if ([[item quantity] length]>0){
        [plusBtn setImage:plus_blue forState:UIControlStateNormal];
    }
    else if ([[item note] length]>0){
        [plusBtn setImage:plus_star forState:UIControlStateNormal];
    }
    else {
        [plusBtn setImage:plus_grey forState:UIControlStateNormal];
    }
    

}


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
