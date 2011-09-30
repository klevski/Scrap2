//
//  FullContactViewController.m
//  Scrap2
//
//  Created by Kelsey Levine on 6/22/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "FullContactViewController.h"
#import "ContactPage.h"

@implementation FullContactViewController

@synthesize theRoot, contactID, selectSection, selectRow, contact, isEmpty;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    isEmpty = NO;
    
    
    [self fillNotepad];

        
    contact = [[ContactPage alloc] init];
    contact.theRoot = theRoot;
    contact.contactID = contactID;
    contact.selectRow = selectRow;
    contact.selectSection = selectSection;
    contact.parent = self;
    contact.titleLbl1 = @"";
    if (selectRow == -1) {
        contact.isTitle = YES;
    } else {
        contact.isTitle = NO;
    }
    contact.view.frame = CGRectMake(70, 0, contact.view.frame.size.width, contact.view.frame.size.height);
    [self.view addSubview:contact.view];
    
}

- (void) editButtonAction:(id)sender {
    [contact editAction];
}

- (void) addTwoPages {
    twoPages.alpha = 1;
    onePage.alpha = 0;
    lotsPages.alpha = 0;
   // image.image = [UIImage imageNamed:@"TwoPagesLeftAddress.png"];
}

- (void) fillNotepad {
    onePage.alpha = 1;
    lotsPages.alpha = 1;
    twoPages.alpha = 0;
     //image.image = [UIImage imageNamed:@"LotsOfPagesLeftAddress.png"];
}

- (void) emptyNotepad {
    onePage.alpha = 0;
    lotsPages.alpha = 0;
    twoPages.alpha = 0;
    image.image = [UIImage imageNamed:@"NoPagesLeftAddress.png"];
}


- (void) setTitle:(NSString *)title {
    theTitle=title;
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Cochin" size:25];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = label;
    label.text = title;
    
    
}


- (void)newContact {
    [contact createNewContact];
}



- (NSString *) getTitle {
    return theTitle;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
