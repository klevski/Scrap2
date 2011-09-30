//
//  EventDetail-Proj.m
//  Scrap2
//
//  Created by Kelsey Levine on 4/25/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "EventDetail-Proj.h"
#import "personPopController.h"
#import "DateFollowPopController.h"
#import "RootViewController.h"
#import "ContactPopController.h"
#import "ContactQuickViewController.h"
#import "LegendViewController.h"
#import "DocImageView.h"
#import "ContractView.h"
#import "DocumentsListView.h"
#import "LinksTable.h"
#import "DocumentDisplayView.h"


@implementation EventDetail_Proj

@synthesize backToMasterButton, masterNav, orientation, complete, elementsArray, documentTbl, parent, popoverController;
@synthesize personPopoverBtn, personAssignedLbl, personPopView, dateLbl, dateBtn, datePopView, rootViewController;
@synthesize eventsMode, blueXBtn, notes, notesText, eventTitleLbl, issueTitleLbl, issueName, eventName, contactText;
@synthesize dateText, lastUpdateStr, dateCreatedLbl, dateCreatedStr, eventIDLbl, projectIDLbl, projectIDStr, eventIDStr;
@synthesize currentSwitch, priorityNum, prioritySeg, theRoot, followupPerson, previous, lastUpdateLbl, needPush;
@synthesize ourIndexPath, contactPopView, contactPopoverBtn, contactPerson, contactPersonID, totalString;
@synthesize linkAStr, linkADescrStr, linkBStr, linkBDescrStr, linkABtn, linkBBtn, contactInfoBtn, completeBtn;
@synthesize insertDateBtn, isLoading, taglineStr, nextView, hyperlink, rightRed, leftRed, linksArray, newEvent;
@synthesize isPortrait;

#pragma mark -
#pragma mark Rotation support

//***********************************************ROTATION***************************************************

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        //self.view = portraitView;
        [self changeTheViewToPortrait:YES andDuration:duration];
        
		
    }
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        //self.view = landscapeView;
        [self changeTheViewToPortrait:NO andDuration:duration];
        
    }
}






//push the correct view controller for the new orientation
- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration{
    
    
	[popoverController dismissPopoverAnimated:NO];
	
	if(portrait){
		[parent setLandPortImage:@"port"];
		
		if (!needPush) {
			
			[self.navigationController popViewControllerAnimated:YES];
			
			
		}  else if ([[rootViewController getMode] isEqualToString:@"Projects"]) {
            EventDetail_Proj *event = [[EventDetail_Proj alloc] initWithNibName:@"EventDetail" bundle:nil];
            event.masterNav = self.masterNav;
            event.parent = parent;
            event.title = self.title;
            event.followupPerson = followupPerson;
            event.priorityNum = priorityNum;
            event.dateText = dateText;
            event.eventName = eventName;
            event.dateCreatedStr = dateCreatedStr;
            event.projectIDStr = projectIDStr;
            event.currentSwitch = currentSwitch;
            event.theRoot = theRoot;
            event.eventIDStr = eventIDStr;
            event.issueName = issueName;
            event.lastUpdateStr = lastUpdateStr;
            event.notesText = notes.text;
            event.previous = self;
            event.ourIndexPath = ourIndexPath;
            event.needPush = NO;
            event.contactPerson = contactPerson;
            event.contactPersonID = contactPersonID;
            event.linkAStr = linkAStr;
            event.linkADescrStr = linkADescrStr;
            event.linkBStr = linkBStr;
            event.linkBDescrStr = linkBDescrStr;
            event.totalString = totalString;
            event.rightRed = rightRed;
            event.leftRed = leftRed;
            event.isPortrait = !isPortrait;
            [event setTitle:theTitle];
            [[self navigationController] pushViewController:event animated:YES];
            
        } else {
            
            EventDetail_Proj *event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventPort" bundle:nil];
            event.masterNav = self.masterNav;
            event.parent = parent;
            event.title = self.title;
            event.theRoot = theRoot;
            event.dateText = dateText;
            event.eventName = eventName;
            event.dateCreatedStr = dateCreatedStr;
            event.projectIDStr = projectIDStr;
            event.currentSwitch = currentSwitch;
            event.priorityNum = priorityNum;
            event.eventIDStr = eventIDStr;
            event.followupPerson = followupPerson;
            event.issueName = issueName;
            event.lastUpdateStr = lastUpdateStr;
            event.notesText = notes.text;
            event.needPush = NO;
            event.previous = self;
            event.ourIndexPath = ourIndexPath;
            event.contactPerson = contactPerson;
            event.contactPersonID = contactPersonID;
            event.linkAStr = linkAStr;
            event.linkADescrStr = linkADescrStr;
            event.linkBStr = linkBStr;
            event.linkBDescrStr = linkBDescrStr;
            event.totalString = totalString;
            event.eventsMode = eventsMode;
            event.taglineStr = taglineStr;
            event.rightRed = rightRed;
            event.leftRed = leftRed;
            event.isPortrait = !isPortrait;
             [event setTitle:theTitle];
            [[self navigationController] pushViewController:event animated:YES];
            
        }
        
	}else{   
		
        //this is the position of this event in theRoot (so we can highlight it in sideways list)
        int thisEvent;        
		[parent setLandPortImage:@"land"];
		
        if (!needPush) {
			[self.navigationController popViewControllerAnimated:YES];
		
        } else {
			
			if ([[rootViewController getMode] isEqualToString:@"Projects"]) {
                
               thisEvent = [theRoot getElementsIndexOfStringContaining:eventIDStr:1];
                NSLog(@"this Event: %d", thisEvent);

                
				EventDetail_Proj *event = [[EventDetail_Proj alloc] initWithNibName:@"EventDetailLandGray" bundle:nil];
				event.masterNav = self.masterNav;
				event.parent = parent;
				event.title = self.title;
				event.theRoot = theRoot;
				event.dateText = dateText;
				event.eventName = eventName;
				event.dateCreatedStr = dateCreatedStr;
				event.projectIDStr = projectIDStr;
				event.currentSwitch = currentSwitch;
				event.priorityNum = priorityNum;
				event.eventIDStr = eventIDStr;
				event.followupPerson = followupPerson;
				event.issueName = issueName;
				event.lastUpdateStr = lastUpdateStr;
				event.notesText = notes.text;
				event.needPush = NO;
				event.previous = self;
				event.ourIndexPath = ourIndexPath;
				event.contactPerson = contactPerson;
				event.contactPersonID = contactPersonID;
				event.linkAStr = linkAStr;
				event.linkADescrStr = linkADescrStr;
				event.linkBStr = linkBStr;
				event.linkBDescrStr = linkBDescrStr;
                event.totalString = totalString;
                event.rightRed = rightRed;
                event.leftRed = leftRed;
                event.isPortrait = !isPortrait;
                 [event setTitle:theTitle];
                [theRoot.tableView reloadData];
                theRoot.lastSelectedRow = 9999;
                NSLog(@"thisEvent number: %d", thisEvent);
                
                if (thisEvent<999) {
                    [theRoot selectTableRow:thisEvent];
                   
                    [[self navigationController] pushViewController:event animated:YES];
				}
            }else {
                
               
                NSLog(@"this Event: %d", thisEvent);
                
                EventDetail_Proj *event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventLand" bundle:nil];
                event.masterNav = self.masterNav;
                event.parent = parent;
                event.title = self.title;
                event.theRoot = theRoot;
                event.dateText = dateText;
                event.eventName = eventName;
                event.dateCreatedStr = dateCreatedStr;
                event.projectIDStr = projectIDStr;
                event.currentSwitch = currentSwitch;
                event.priorityNum = priorityNum;
                event.eventIDStr = eventIDStr;
                event.followupPerson = followupPerson;
                event.issueName = issueName;
                event.lastUpdateStr = lastUpdateStr;
                event.notesText = notes.text;
                event.needPush = NO;
                event.previous = self;
                event.ourIndexPath = ourIndexPath;
                event.contactPerson = contactPerson;
                event.contactPersonID = contactPersonID;
                event.linkAStr = linkAStr;
                event.linkADescrStr = linkADescrStr;
                event.linkBStr = linkBStr;
                event.linkBDescrStr = linkBDescrStr;
                event.totalString = totalString;
                event.eventsMode = eventsMode;
                event.rightRed = rightRed;
                event.leftRed = leftRed;
                event.taglineStr = taglineStr;
                event.isPortrait = !isPortrait;
                 [event setTitle:theTitle];
               
                theRoot.lastSelectedRow = 9999;
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMM d, yyyy"];
                
                //also need to delete the entry from the table and eliminate the backbutton.  
                
                
                if ([eventsMode isEqualToString:@"due"]) {
                
                NSDate *dueDate = [format dateFromString:dateLbl.text];
                if ((![[dueDate earlierDate:[NSDate date]] isEqualToDate:dueDate]) ||
                    (currentSwitch==1)) {
                    int test = [theRoot getElementsIndexOfStringContaining:eventIDStr:2];
                    if (test < 999) {
                        [theRoot tableView:theRoot.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
                    }
                    
                }
                }
                
                [theRoot.tableView reloadData];
                 
                thisEvent = [theRoot getElementsIndexOfStringContaining:eventIDStr:2];
                if (thisEvent<999) {
                    [theRoot selectTableRow:thisEvent];
                    
                    [[self navigationController] pushViewController:event animated:YES];
				}
                
            }
            
        }
        
    }
}
//***************************************DONE WITH ROTATION**************************************************
	

- (NSString *)uploadData:(NSURL *)url {
    
    return [NSString stringWithFormat:@"http://%@/CreateNewDocument.php?mUser=%@&mPassword=%@",
                                  [theRoot.serverInfo objectAtIndex:0],
                                  [theRoot.serverInfo objectAtIndex:3],
                                  [theRoot.serverInfo objectAtIndex:4]];
    
}







//Make it so no one is assigned to the event
//so empty the label and remove them from the 
//event in the database
- (IBAction) blueXBtnPushed: (BOOL)first {

    followupPerson = @"";
	personAssignedLbl.text = @"";
	
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    totalString = [theRoot replaceElement:9 :@"" :totalString];
    [totalString retain];
    
	if (previous) {
		[previous blueXBtnPushed:NO];
	}
    
    if (first) {
        
        NSString *updatePersonSite = [NSString stringWithFormat:@"http://%@/UpdatePersonAssigned.php?mUser=%@&mPassword=%@&PersonIDAssigned=null&EventID=%@",
                                      [theRoot.serverInfo objectAtIndex:0], 
                                      [theRoot.serverInfo objectAtIndex:3],
                                      [theRoot.serverInfo objectAtIndex:4], 
                                      eventIDStr];
         NSError *error;
        NSString *updatePerson = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   updatePersonSite]
                          encoding:NSASCIIStringEncoding error:&error];
       
        if ((eventsMode.length > 1) && ([theRoot.mode isEqualToString:@"Events"])) {
            if ([eventsMode isEqualToString:@"active"]) {
               //if it is an active event and the person assigned becomes null, must remove the event from the list
                int test = [theRoot getElementsIndexOfStringContaining:eventIDStr:2];
                if (test<999){
                    //It must be deleted from the list if it is in it.  The Root should delete it from the datase.
                    [theRoot tableView:theRoot.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
                }
            } else {
                [theRoot updatePersonAssigned:@"":@"":eventIDStr];
            }
        } else if ((eventsMode.length < 1) && ([theRoot.mode isEqualToString:@"Projects"])) {
            [theRoot updatePersonAssigned:@"":@"":eventIDStr];
        }

    }
}






//change the person who is assigned as the contact in
//both the database and in the label
- (void) changeContact:(NSString *)contact:(BOOL)first {
	if (popoverController != nil) {
		[popoverController dismissPopoverAnimated:YES];
    } 
	
	NSRange plus = [contact rangeOfString:@"~+~"];
	
	contactPerson = [[contact substringToIndex:plus.location] retain];
	contactPersonID = [[contact substringFromIndex:plus.location+plus.length] retain];
	contactText.text = [contact substringToIndex:plus.location];
	contactText.font = [UIFont fontWithName:@"Cochin" size:16];
	
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    totalString = [theRoot replaceElement:4 :contactPersonID :totalString];
    [totalString retain];
    totalString = [theRoot replaceElement:8 :contactPerson :totalString];
    [totalString retain];
    
	if (previous) {
		[previous changeContact:contact:NO];
	}
    
    if (first) {
        //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
        NSString *updateContactSite = [NSString stringWithFormat:@"http://%@/UpdateEventContact.php?mUser=%@&mPassword=%@&ContactID=%@&EventID=%@",
                                       [theRoot.serverInfo objectAtIndex:0], 
                                       [theRoot.serverInfo objectAtIndex:3],
                                       [theRoot.serverInfo objectAtIndex:4], 
                                       contactPersonID, eventIDStr];
        if ((eventsMode.length > 1) && ([theRoot.mode isEqualToString:@"Events"])) {
            [theRoot updateEventContact:contactPersonID:contactPerson:eventIDStr];
        } else if ((eventsMode.length < 1) && ([theRoot.mode isEqualToString:@"Projects"])) {
            [theRoot updateEventContact:contactPersonID:contactPerson:eventIDStr];
        }
        
        NSError *error;
        NSString *updateContacts = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     updateContactSite]
                                                            encoding:NSASCIIStringEncoding error:&error];
    }
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



- (NSString *) getTitle {
    return theTitle;
}




//change the person assigned in both the database
//and in the label (and any previous views)
- (void) changePersonAssigned:(NSString *)person:(BOOL)first {
	
    NSRange separater = [person rangeOfString:@"~+~"];
	
	if (popoverController != nil) {
		[popoverController dismissPopoverAnimated:YES];
    } 
	followupPerson = person;
	personAssignedLbl.text = [person substringToIndex:separater.location];
	personAssignedLbl.textColor = [UIColor blackColor];
    personAssignedLbl.font = [UIFont fontWithName:@"Cochin" size:16];

	
	if (previous) {
		[previous changePersonAssigned:person:NO];
	}
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    totalString = [theRoot replaceElement:9 :[person substringToIndex:separater.location] :totalString];
    [totalString retain];
    totalString = [theRoot replaceElement:10 :[person substringFromIndex:separater.location+3] :totalString];
    [totalString retain];
    
    
    if (first) {
        NSString *updatePersonSite = [NSString stringWithFormat:@"http://%@/UpdatePersonAssigned.php?mUser=%@&mPassword=%@&PersonIDAssigned=%@&EventID=%@",
                                       [theRoot.serverInfo objectAtIndex:0], 
                                       [theRoot.serverInfo objectAtIndex:3],
                                       [theRoot.serverInfo objectAtIndex:4], 
                                       [person substringFromIndex:separater.location+3], eventIDStr];
        
        
        NSError *error;
        NSString *updatePerson = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     updatePersonSite]
                                                            encoding:NSASCIIStringEncoding error:&error];
       
        
        if ((eventsMode.length > 1) && ([theRoot.mode isEqualToString:@"Events"])) {
            
            //remove it from the list if the userid does not match the person assigned
            if ([eventsMode isEqualToString:@"active"]) {
                
                //if it is an active event and the person assigned is not the user, must remove the event from the list
                
                if (![[person substringFromIndex:separater.location+3] isEqualToString:theRoot.userIDNum]) {
                
                    int test = [theRoot getElementsIndexOfStringContaining:eventIDStr:2];
                    if (test<999){
                        //It must be deleted from the list if it is in it.  The Root should delete it from the datase.
                        [theRoot tableView:theRoot.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
                    }
                } else {
                    // and if it is the user and is not in the list, it must be added to it
                    
                    int test = [theRoot getElementsIndexOfStringContaining:eventIDStr:2];
                    if (test>=999){
                        [theRoot addNewEvent:totalString];
                    }
                }
                
            } else {
             [theRoot updatePersonAssigned:[person substringToIndex:separater.location]:[person substringFromIndex:separater.location+3]:eventIDStr];
            }
        } else if ((eventsMode.length < 1) && ([theRoot.mode isEqualToString:@"Projects"])) {
             [theRoot updatePersonAssigned:[person substringToIndex:separater.location]:[person substringFromIndex:separater.location+3]:eventIDStr];
        }

    }
    
}








#pragma mark -
#pragma mark View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
   // [dateText retain];
    isLoading = YES;
	holderCount = 0;
	
    notes.selectedRange = NSMakeRange(0, 0);
    
    if (newEvent) {
        [notes becomeFirstResponder];
    }
    
    if (rightRed) {
        rightRedLight.alpha = 1;
    } else {
        rightRedLight.alpha = 0;
    }
    
    if (leftRed) {
        leftRedLight.alpha = 1;
    } else {
        leftRedLight.alpha = 0;
    }
	
    
   
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[self.view addGestureRecognizer:swipeLeft];
    
    
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[self.view addGestureRecognizer:swipeRight];
	
    openClosedSeg.frame = CGRectMake(340, 875, 120, 37);
    prioritySeg.frame = CGRectMake(562, 875, 134, 37);
    
    openClosedSeg.alpha = 0;
    prioritySeg.alpha = 0;
	
	self.navigationItem.hidesBackButton = YES;

    taglineLbl.text = taglineStr;
    
    insertDateBtn.alpha = 0;
    insertDateLbl.alpha = 0;
    
   	
    // create a custom navigation bar button and set it to always say "Back"
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = eventName;
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    UIBarButtonItem *returnToSwitchBtn = [[UIBarButtonItem alloc] initWithTitle:@"Return to Switchboard" style:UIBarButtonItemStyleBordered target:self action:@selector(masterPushed:)];
    
    [self.navigationItem setLeftBarButtonItem:returnToSwitchBtn];
    [returnToSwitchBtn release];
    [totalString retain];
    
    if (currentSwitch==1) {
        openClosedSeg.selectedSegmentIndex = 1;
        openClosedSegImage.image = [UIImage imageNamed:@"closedSelected.png"];
        [completeBtn setImage:[UIImage imageNamed:@"CheckedApple.png"] forState:UIControlStateNormal];
    } else {
        openClosedSeg.selectedSegmentIndex = 0;
        openClosedSegImage.image = [UIImage imageNamed:@"openSelected.png"];
        [completeBtn setImage:[UIImage imageNamed:@"UncheckedApple.png"] forState:UIControlStateNormal];
    }
    
    [self changeOpenUISegmentFont:openClosedSeg];
    
    if (currentSwitch==1) {
		[complete setOn:YES];
		
	} else {
		[complete setOn:NO];
	}
	
    if (priorityNum == 1) {
        fakeSeg.image = [UIImage imageNamed:@"Select1Gray.png"];
        prioritySeg.selectedSegmentIndex = 0;
    } else if (priorityNum ==2) {
        fakeSeg.image = [UIImage imageNamed:@"Select2Gray.png"];
        prioritySeg.selectedSegmentIndex = 1;
    } else {
        fakeSeg.image = [UIImage imageNamed:@"Select3Gray.png"];
        prioritySeg.selectedSegmentIndex = 2;
    }
    
	//[self changeUISegmentFont:prioritySeg];
		
	
	contactPopView = [[ContactPopController alloc] initWithNibName:@"ContactPopView" bundle:nil];
	contactPopView.parent = self;
	contactPopView.theRoot = theRoot;
	personPopView = [[personPopController alloc] init];
    personPopView.parent=self;
	datePopView = [[DateFollowPopController alloc] initWithNibName:@"DateFollowPopView" bundle:nil];
	datePopView.parent = self;
	
	personPopView.theRoot = theRoot;
	popoverController = [[UIPopoverController alloc] initWithContentViewController:personPopView];
	[popoverController setDelegate:self];
 
	contactText.text = contactPerson;
	contactText.font = [UIFont fontWithName:@"Cochin" size:16];
	eventTitleLbl.text = eventName;
    eventTitleLbl1.text = eventName;
    eventTitleLbl2.text = eventName;
	issueTitleLbl.text = issueName;
    notes.text = notesText;
	notes.selectedRange = NSMakeRange(0, 0);
    
	NSArray *dateTemp = [dateText componentsSeparatedByString:@"-"];
	
    
	NSArray *months = [NSArray arrayWithObjects:
					   @"Jan", @"Feb",@"Mar", @"Apr", @"May", @"Jun",
					   @"Jul", @"Aug", @"Sep",@"Oct", @"Nov", @"Dec", nil];
	
    NSLog(@"dateTemp: %@", dateTemp);
    
	if ([dateTemp count] > 2) {
        
        if ([[dateTemp objectAtIndex:2] rangeOfString:@" "].location != NSNotFound) {
        
            dateLbl.text = [NSString stringWithFormat:@"%@ %@, %@",
                            [months objectAtIndex: [[dateTemp objectAtIndex:1] intValue]-1],
                            [[dateTemp objectAtIndex:2] substringToIndex:
                             [[dateTemp objectAtIndex:2] rangeOfString:@" "].location],
                            [dateTemp objectAtIndex:0]];
        } else {
            dateLbl.text = [NSString stringWithFormat:@"%@ %@, %@",
                            [months objectAtIndex: [[dateTemp objectAtIndex:1] intValue]-1],
                            [dateTemp objectAtIndex:2],
                            [dateTemp objectAtIndex:0]];
        }
            
		
	} else {
		dateLbl.text = @"";
	}

	NSArray *lastDateTemp = [lastUpdateStr componentsSeparatedByString:@"-"];
	
	
	if ([lastDateTemp count] > 1) {
        if ([[lastDateTemp objectAtIndex:2] rangeOfString:@" "].location != NSNotFound) {
            
            lastUpdateLbl.text = [NSString stringWithFormat:@"%@/%@/%@",
                            [lastDateTemp objectAtIndex:1],
                            [[lastDateTemp objectAtIndex:2] substringToIndex:
                             [[lastDateTemp objectAtIndex:2] rangeOfString:@" "].location],
                            [lastDateTemp objectAtIndex:0]];
        } else {
            lastUpdateLbl.text = [NSString stringWithFormat:@"%@/%@/%@",
                            [lastDateTemp objectAtIndex:1],
                            [lastDateTemp objectAtIndex:2],
                            [lastDateTemp objectAtIndex:0]];
        }
	} else {
		lastUpdateLbl.text = @"";
	}

	
	NSArray *createdDateTemp = [dateCreatedStr componentsSeparatedByString:@"-"];
	if ([createdDateTemp count] > 1) {
        
        if ([[createdDateTemp objectAtIndex:2] rangeOfString:@" "].location != NSNotFound) {
        
            dateCreatedLbl.text = [NSString stringWithFormat:@"%@/%@/%@",
                                   [createdDateTemp objectAtIndex:1],
                                   [[createdDateTemp objectAtIndex:2] substringToIndex:
                                    [[createdDateTemp objectAtIndex:2] rangeOfString:@" "].location],
                                   [createdDateTemp objectAtIndex:0]];
        } else {
            dateCreatedLbl.text = [NSString stringWithFormat:@"%@/%@/%@",
                                   [createdDateTemp objectAtIndex:1],
                                   [createdDateTemp objectAtIndex:2],
                                   [createdDateTemp objectAtIndex:0]];
        }
        
	} else {
		dateCreatedLbl.text = @"";
	}
	
	
	eventIDLbl.text = eventIDStr;
	projectIDLbl.text = projectIDStr;
    
	if (followupPerson.length > 1) {
        if ([followupPerson rangeOfString:@"~+~"].location != NSNotFound) {
        
            personAssignedLbl.text = [followupPerson substringToIndex:[followupPerson rangeOfString:@"~+~"].location];
        } else {
            personAssignedLbl.text = followupPerson;
        }
		personAssignedLbl.textColor = [UIColor blackColor];
		personAssignedLbl.font = [UIFont fontWithName:@"Cochin" size:16];
	}
	
    
    isLoading = NO;
    if (([notes.text rangeOfString:@" - Add Event Details Here"].location != NSNotFound) &&
        (notes.text.length == 35)){
        notes.textColor = [UIColor grayColor];
    }
    if (!nextView) {
        DocImageView *doc = [[DocImageView alloc] initWithNibName:@"DocImageView" bundle:nil];
        doc.imageViewStr = @"FairLand1.jpg";
        [self updateDocumentSelected:@"Steel Frame":doc];
    }
    
    
    
    NSString *linksStrLink = [NSString stringWithFormat:@"http://%@/GetEventLinks.php?mUser=%@&mPassword=%@&EventID=%@",
                              [theRoot.serverInfo objectAtIndex:0],
                              [theRoot.serverInfo objectAtIndex:3],
                              [theRoot.serverInfo objectAtIndex:4],
                              eventIDStr];
        
    NSError *error;
    
    //returns with the Link~+~Description
    NSString *linksStr = [NSString stringWithContentsOfURL: 
                          [NSURL URLWithString:
                           linksStrLink]
                                                  encoding:NSASCIIStringEncoding error:&error];
    
     NSRange lastsquiggle = [linksStr rangeOfString:@"~-~" options:NSBackwardsSearch];
    if (lastsquiggle.location != NSNotFound) {
        linksArray = [[linksStr substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~-~"];
    } else {
        linksArray = [[NSArray alloc] init];
    }
    
    [linksArray retain];
    
    
    
    if (([linksArray count]>0) && !hyperlink) {
        NSArray *temp = [[linksArray objectAtIndex:0] componentsSeparatedByString:@"~+~"];
        hyperlink = [temp objectAtIndex:0];
        hyperlinkTxt.text = [temp objectAtIndex:1];
    }
    [hyperlink retain];

}






- (void) addLink:(NSString *)str {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:linksArray];
    [temp addObject:str];
    [linksArray release];
    linksArray = temp;
}

- (void) turnRightRedLightOn {
    rightRed = YES;
    rightRedLight.alpha = 1;
}

- (void) turnLeftRedLightOn {
    leftRed = YES;
    leftRedLight.alpha = 1;
}

- (void) turnOffBothRed {
    leftRed = NO;
    rightRed = NO;
    rightRedLight.alpha = 0;
    leftRedLight.alpha = 0;
}

- (void) removeLinkatIndex:(int)num {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:linksArray];
    [temp removeObjectAtIndex:num];
    [linksArray release];
    linksArray = temp;
    
    
    if ([linksArray count]==0) {
        hyperlinkTxt.text = 0;
    }
}



- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (([notes.text rangeOfString:@" - Add Event Details Here"].location != NSNotFound) &&
        (notes.text.length == 35)){
        notes.text = @"";
    }
    notes.textColor = [UIColor blackColor];
    insertDateBtn.alpha = 1;
    insertDateLbl.alpha = 1;
    notes.selectedRange = NSMakeRange(0, 0);
    //need to make the textbox shorter when keyboard comes up
    if (isPortrait) {
        notes.frame = CGRectMake(notes.frame.origin.x, notes.frame.origin.y, notes.frame.size.width, 495);
    } else {
        notes.frame = CGRectMake(notes.frame.origin.x, notes.frame.origin.y, notes.frame.size.width, 195);
    }
}


- (IBAction) openBlueBtnPressed:(id)sender {
    openClosedSegImage.image = [UIImage imageNamed:@"openSelected.png"];
    openClosedSeg.selectedSegmentIndex = 0;
}


- (IBAction) closedBlueBtnPressed:(id)sender {
    openClosedSegImage.image = [UIImage imageNamed:@"closedSelected.png"];
    openClosedSeg.selectedSegmentIndex = 1;
}


- (IBAction) blueSegBtnPressed:(id)sender {
    if ([sender isEqual:blue1]) {
        fakeSeg.image = [UIImage imageNamed:@"Select1Gray.png"];
        prioritySeg.selectedSegmentIndex = 0;
    } else if ([sender isEqual:blue2]) {
        fakeSeg.image = [UIImage imageNamed:@"Select2Gray.png"];
        prioritySeg.selectedSegmentIndex = 1;
    } else {
        fakeSeg.image = [UIImage imageNamed:@"Select3Gray.png"];
        prioritySeg.selectedSegmentIndex = 2;
    }
    //[self changeUISegmentFont: prioritySeg];
}


- (IBAction) latestSegmentAction:(id)sender {
    
    if (!isLoading) {
  
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	
	if (priorityNum != [segmentedControl selectedSegmentIndex]+1) {
        
		priorityNum = [segmentedControl selectedSegmentIndex]+1;
    }
        
       
        
    if ((eventsMode.length > 1) && (![eventsMode isEqualToString:@"due"])) {
        
        [totalString retain];
        
        int test = [theRoot getElementsIndexOfStringContaining:eventIDStr:2];
        if ((test<999) && (theRoot.currentPriority < priorityNum)){
            //It must be deleted from the list if it is in it.  The Root should delete it from the datase.
            [theRoot tableView:theRoot.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];

        } else if ((theRoot.currentPriority >= priorityNum) && (test>=999)) {
        
            [totalString retain];
            [theRoot addNewEvent:totalString];
        
        }
    }
        
        //maybe change to regular change font depending of it lbl begins to grow
            
    //Get Followupdate
    NSString *triageInfoSite = [NSString stringWithFormat:@"http://%@/GetTriageInfo.php?mUser=%@&mPassword=%@&Triage=%d",
                                [theRoot.serverInfo objectAtIndex:0],
                                [theRoot.serverInfo objectAtIndex:3],
                                [theRoot.serverInfo objectAtIndex:4],
                                priorityNum];
    
    NSError *error;
    
    //daysFromToday~+~allowWeekends(0 or 1)
    NSString *triageInfo = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             triageInfoSite]
                                                    encoding:NSASCIIStringEncoding error:&error];
    

    
    NSArray *triageArray = [triageInfo componentsSeparatedByString:@"~+~"];
    

    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];
    int daysToAdd = [[triageArray objectAtIndex:0] intValue];
    NSDate *followupDate = [now addTimeInterval:60*60*24*daysToAdd];
    NSDate *finalFollowupDate;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:followupDate];
    
    if ([triageArray objectAtIndex:1]==0) {
        
        
        // 1 = Sunday, 2 = Monday, etc.
        if ([comp weekday]==1) {
            int r = (arc4random() % 2)+1;
            finalFollowupDate = [followupDate addTimeInterval:60*60*24*r];
        } else if ([comp weekday]==7) {
            finalFollowupDate = [followupDate addTimeInterval:-60*60*24];
        } else {
            finalFollowupDate = followupDate;
        }
    } else {
        finalFollowupDate = followupDate;
    }
    
    [self changeReviewDate:finalFollowupDate:YES];
 
    
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString *followupDateStr = [format stringFromDate:finalFollowupDate];
    dateText = followupDateStr;
        [dateText retain];
    
    NSArray *dateTemp = [dateText componentsSeparatedByString:@"-"];
	
	NSArray *months = [NSArray arrayWithObjects:
					   @"Jan", @"Feb",@"Mar", @"Apr", @"May", @"Jun",
					   @"Jul", @"Aug", @"Sep",@"Oct", @"Nov", @"Dec", nil];
	
    
	if ([dateTemp count] > 2) {
        
        if ([[dateTemp objectAtIndex:2] rangeOfString:@" "].location != NSNotFound) {
            
            dateLbl.text = [NSString stringWithFormat:@"%@ %@, %@",
                            [months objectAtIndex: [[dateTemp objectAtIndex:1] intValue]-1],
                            [[dateTemp objectAtIndex:2] substringToIndex:
                             [[dateTemp objectAtIndex:2] rangeOfString:@" "].location],
                            [dateTemp objectAtIndex:0]];
        } else {
            dateLbl.text = [NSString stringWithFormat:@"%@ %@, %@",
                            [months objectAtIndex: [[dateTemp objectAtIndex:1] intValue]-1],
                            [dateTemp objectAtIndex:2],
                            [dateTemp objectAtIndex:0]];
        }
        
		
	} else {
		dateLbl.text = @"";
	}

    }
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    
    [theRoot updateFollowupDate:dateText:eventIDStr];
    [theRoot updateEventTriage:[NSString stringWithFormat:@"%d", priorityNum]:eventIDStr];
    
    totalString = [theRoot replaceElement:6 :dateText :totalString];
    [totalString retain];
    totalString = [theRoot replaceElement:5 :[NSString stringWithFormat:@"%d", priorityNum] :totalString];
    [totalString retain];
    
    
    
    if (previous) {
        
        [previous updateFollowupDateInfo:dateText:priorityNum:dateLbl.text];
    }
     
}





- (void) updateFollowupDateInfo: (NSString *)str: (int)num: (NSString *)dateStr {
    
    dateText = str;
    dateLbl.text = dateStr;
    totalString = [theRoot replaceElement:6 :dateText :totalString];
    [totalString retain];
    totalString = [theRoot replaceElement:5 :[NSString stringWithFormat:@"%d", num] :totalString];
    priorityNum=num;
    [totalString retain];
    isLoading = YES;
    prioritySeg.selectedSegmentIndex = num-1;
    isLoading = NO;
}






- (void) textViewDidEndEditing:(id)sender {
    [notes resignFirstResponder];
    
    [self editDescription:notes.text: NO];
    
    insertDateBtn.alpha = 0;
    insertDateLbl.alpha = 0;
    
    //need to make the textbox shorter when keyboard comes up
    if (isPortrait) {
        notes.frame = CGRectMake(notes.frame.origin.x, notes.frame.origin.y, notes.frame.size.width, 560);
    } else {
        if (eventsMode.length>0) {
            notes.frame = CGRectMake(notes.frame.origin.x, notes.frame.origin.y, notes.frame.size.width, 331);
        } else {
            notes.frame = CGRectMake(notes.frame.origin.x, notes.frame.origin.y, notes.frame.size.width, 356);
        }
    }

    
}

- (IBAction) printDate:(id)sender {
    
    NSLog(@"holdercount: %d", holderCount);
    
    if (holderCount < 2) {
    
    NSLog(@"print date");
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/YYYY"];

    notes.scrollEnabled = NO;
        int lengthMeas;
       
        
    if ([notes.text isEqualToString:@""]){
       notes.text = [NSString stringWithFormat:@"%@ - %@: ", [format stringFromDate:[NSDate date]], theRoot.UserInitials];
        lengthMeas = notes.text.length;
    } else {       
        notes.text = [NSString stringWithFormat:@"%@ - %@: \n\n%@", [format stringFromDate:[NSDate date]], theRoot.UserInitials, notes.text]; 
        NSString *temp = [NSString stringWithFormat:@"%@ - %@: ", [format stringFromDate:[NSDate date]], theRoot.UserInitials];
        lengthMeas = temp.length;
    }
    
    notes.scrollEnabled = YES;
    notes.selectedRange = NSMakeRange(lengthMeas, 0);
    }
    
    holderCount = 0;
}





- (void) editDescription:(NSString *)str :(BOOL)copy {
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
       
    totalString = [theRoot replaceElement:2 :str :totalString];
    [totalString retain];
    
    if (previous) {
		[previous editDescription:str :YES];
	}

    if (copy) {
        notes.text = str;
        [self changeLastUpdateDate:NO];
    } else {
       
        NSString *theNotes = notes.text;
        
       
        
        if ((eventsMode.length > 1) && ([theRoot.mode isEqualToString:@"Events"])) {
      
             [theRoot updateEventDesc:theNotes:eventIDStr];
        } else if ((eventsMode.length < 1) && ([theRoot.mode isEqualToString:@"Projects"])) {
            [theRoot updateEventDesc:theNotes:eventIDStr];
        }
        
       
        
        //taking away % so will go in the db - replaced with %20-like webpages do
        int descLength = [theNotes length];
        NSRange descRange = NSMakeRange(0,descLength);
        NSString *fullDesc = [theNotes stringByReplacingOccurrencesOfString:@"\%" withString:@"~tech18~" options:NSCaseInsensitiveSearch range:descRange];
        
        
        //taking away carriage returns so will go in the db - replaced with tech11, which will be replaced
        //in the PHP file
        int descfinalLength = [fullDesc length];
        NSRange descfinalRange = NSMakeRange(0,descfinalLength);
        NSString *fullfinalDesc = [fullDesc stringByReplacingOccurrencesOfString:@"\n" withString:@"~tech11~" options:NSCaseInsensitiveSearch range:descfinalRange];
        
        
        
        //taking away apostrophes so will go in the db - replaced tech12, which will be replaced
        //in the PHP file
        int descfinalLength1 = [fullfinalDesc length];
        NSRange descfinalRange1 = NSMakeRange(0,descfinalLength1);
        NSString *fullfinalDesc1 = [fullfinalDesc stringByReplacingOccurrencesOfString:@"'" withString:@"~tech12~" options:NSCaseInsensitiveSearch range:descfinalRange1];
        
        //taking away slashes so will go in the db - replaced tech13, which will be replaced
        //in the PHP file
        int descfinalLength2 = [fullfinalDesc1 length];
        NSRange descfinalRange2 = NSMakeRange(0,descfinalLength2);
        NSString *fullfinalDesc2 = [fullfinalDesc1 stringByReplacingOccurrencesOfString:@"/" withString:@"~tech13~" options:NSCaseInsensitiveSearch range:descfinalRange2];
        
        
        //taking away colons so will go in the db - replaced tech14, which will be replaced
        //in the PHP file
        int descfinalLength3 = [fullfinalDesc2 length];
        NSRange descfinalRange3 = NSMakeRange(0,descfinalLength3);
        NSString *fullfinalDesc3 = [fullfinalDesc2 stringByReplacingOccurrencesOfString:@":" withString:@"~tech14~" options:NSCaseInsensitiveSearch range:descfinalRange3];
        
        //taking away $ so will go in the db - replaced tech15, which will be replaced
        //in the PHP file
        int descfinalLength4 = [fullfinalDesc3 length];
        NSRange descfinalRange4 = NSMakeRange(0,descfinalLength4);
        NSString *fullfinalDesc4 = [fullfinalDesc3 stringByReplacingOccurrencesOfString:@"$" withString:@"~tech15~" options:NSCaseInsensitiveSearch range:descfinalRange4];
       
        
        //taking away " so will go in the db - replaced tech16, which will be replaced
        //in the PHP file
        int descfinalLength5 = [fullfinalDesc4 length];
        NSRange descfinalRange5 = NSMakeRange(0,descfinalLength5);
        NSString *fullfinalDesc5 = [fullfinalDesc4 stringByReplacingOccurrencesOfString:@"\"" withString:@"~tech16~" options:NSCaseInsensitiveSearch range:descfinalRange5];
        
        
        //taking away & so will go in the db - replaced tech17, which will be replaced
        //in the PHP file
        int descfinalLength6 = [fullfinalDesc5 length];
        NSRange descfinalRange6 = NSMakeRange(0,descfinalLength6);
        NSString *fullfinalDesc6 = [fullfinalDesc5 stringByReplacingOccurrencesOfString:@"&" withString:@"~tech17~" options:NSCaseInsensitiveSearch range:descfinalRange6];
       
        
        
        //taking away spaces so will go in the db 
        int descfinalLength7 = [fullfinalDesc6 length];
        NSRange descfinalRange7 = NSMakeRange(0,descfinalLength7);
        NSString *fullfinalDesc7 = [fullfinalDesc6 stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:descfinalRange7];
        
        
        //taking away > so will go in the db - replaced tech19, which will be replaced
        //in the PHP file
        int descfinalLength8 = [fullfinalDesc7 length];
        NSRange descfinalRange8 = NSMakeRange(0,descfinalLength8);
        NSString *fullfinalDesc8 = [fullfinalDesc7 stringByReplacingOccurrencesOfString:@">" withString:@"~tech19~" options:NSCaseInsensitiveSearch range:descfinalRange8];
        
        
        //taking away < so will go in the db - replaced tech19, which will be replaced
        //in the PHP file
        int descfinalLength9 = [fullfinalDesc8 length];
        NSRange descfinalRange9 = NSMakeRange(0,descfinalLength9);
        NSString *fullfinalDesc9 = [fullfinalDesc8 stringByReplacingOccurrencesOfString:@"<" withString:@"~tech20~" options:NSCaseInsensitiveSearch range:descfinalRange9];
        
        
        
        //taking away } so will go in the db - replaced tech20, which will be replaced
        //in the PHP file
        int descfinalLength11 = [fullfinalDesc9 length];
        NSRange descfinalRange11 = NSMakeRange(0,descfinalLength11);
        NSString *fullfinalDesc11 = [fullfinalDesc9 stringByReplacingOccurrencesOfString:@"}" withString:@"~tech21~" options:NSCaseInsensitiveSearch range:descfinalRange11];
        
        //taking away { so will go in the db - replaced tech22, which will be replaced
        //in the PHP file
        int descfinalLength12 = [fullfinalDesc11 length];
        NSRange descfinalRange12 = NSMakeRange(0,descfinalLength12);
        NSString *fullfinalDesc12 = [fullfinalDesc11 stringByReplacingOccurrencesOfString:@"{" withString:@"~tech22~" options:NSCaseInsensitiveSearch range:descfinalRange12];
        
        //taking away + so will go in the db - replaced tech23, which will be replaced
        //in the PHP file
        int descfinalLength13 = [fullfinalDesc12 length];
        NSRange descfinalRange13 = NSMakeRange(0,descfinalLength13);
        NSString *fullfinalDesc13 = [fullfinalDesc12 stringByReplacingOccurrencesOfString:@"+" withString:@"~tech23~" options:NSCaseInsensitiveSearch range:descfinalRange13];
        
        
        //taking away # so will go in the db - replaced tech23, which will be replaced
        //in the PHP file
        int descfinalLength14 = [fullfinalDesc13 length];
        NSRange descfinalRange14 = NSMakeRange(0,descfinalLength14);
        NSString *fullfinalDesc14 = [fullfinalDesc13 stringByReplacingOccurrencesOfString:@"#" withString:@"~tech24~" options:NSCaseInsensitiveSearch range:descfinalRange14];
        
        //taking away ^ so will go in the db - replaced tech23, which will be replaced
        //in the PHP file
        int descfinalLength15 = [fullfinalDesc14 length];
        NSRange descfinalRange15 = NSMakeRange(0,descfinalLength15);
        NSString *fullfinalDesc15 = [fullfinalDesc14 stringByReplacingOccurrencesOfString:@"^" withString:@"~tech25~" options:NSCaseInsensitiveSearch range:descfinalRange15];
        
        //taking away  so will go in the db - replaced tech23, which will be replaced
        //in the PHP file
        int descfinalLength16 = [fullfinalDesc15 length];
        NSRange descfinalRange16 = NSMakeRange(0,descfinalLength16);
        NSString *fullfinalDesc16 = [fullfinalDesc15 stringByReplacingOccurrencesOfString:@"%C2%85" withString:@"" options:NSCaseInsensitiveSearch range:descfinalRange16];
        
        //taking away  so will go in the db - replaced tech23, which will be replaced
        //in the PHP file
        int descfinalLength17 = [fullfinalDesc16 length];
        NSRange descfinalRange17 = NSMakeRange(0,descfinalLength17);
        NSString *fullfinalDesc17 = [fullfinalDesc16 stringByReplacingOccurrencesOfString:@"Â" withString:@"" options:NSCaseInsensitiveSearch range:descfinalRange17];
        
        
        NSString *theWords;
        NSString *theSecondWords;
        
        if (fullfinalDesc15.length>8000) {
            theWords = [fullfinalDesc17 substringToIndex:8000];
            theSecondWords = [fullfinalDesc17 substringFromIndex:8000];
        } else {
            theWords = fullfinalDesc17;
            theSecondWords = @"";
        }
        
        
        NSString *editDescSite = [NSString stringWithFormat:@"http://%@/UpdateEventDescription.php?mUser=%@&mPassword=%@&EventDescription=%@&EventID=%@",
                                   [theRoot.serverInfo objectAtIndex:0], 
                                   [theRoot.serverInfo objectAtIndex:3],
                                   [theRoot.serverInfo objectAtIndex:4], 
                                   theWords, eventIDStr];
       

        NSLog(@"editDescSite: %@", editDescSite);
        
        
        NSError *error;
    
        NSString *editDesc = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 editDescSite]
                                  encoding:NSASCIIStringEncoding error:&error];
    
        
        if (theSecondWords.length > 1) {
            [self secondSet:theSecondWords];
        }
        
        //Also, you are going to have to update the table with this new text and perhaps change the order, to put
        //this 'last updated' event at the top.
        
        [self changeLastUpdateDate:YES];
        
        
        //******UPDATE THE FOLLOWUP DATE IN DUE FOR REVIEW IF WRITTEN IN TO NEXT DATE WITH THAT TRIAGE*******
        //***********************************************************************************************
        //************************************************************************************************
       
        if ([eventsMode isEqualToString:@"due"]) {
       
        //Get Followupdate
        NSString *triageInfoSite = [NSString stringWithFormat:@"http://%@/GetTriageInfo.php?mUser=%@&mPassword=%@&Triage=%d",
                                    [theRoot.serverInfo objectAtIndex:0],
                                    [theRoot.serverInfo objectAtIndex:3],
                                    [theRoot.serverInfo objectAtIndex:4],
                                    priorityNum];
        
       
        
        //daysFromToday~+~allowWeekends(0 or 1)
        NSString *triageInfo = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 triageInfoSite]
                                                        encoding:NSASCIIStringEncoding error:&error];
        
        
        
        NSArray *triageArray = [triageInfo componentsSeparatedByString:@"~+~"];
        
        
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        int daysToAdd = [[triageArray objectAtIndex:0] intValue];
        NSDate *followupDate = [now addTimeInterval:60*60*24*daysToAdd];
        NSDate *finalFollowupDate;
        
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:followupDate];
        
        if ([triageArray objectAtIndex:1]==0) {
            
            
            // 1 = Sunday, 2 = Monday, etc.
            if ([comp weekday]==1) {
                int r = (arc4random() % 2)+1;
                finalFollowupDate = [followupDate addTimeInterval:60*60*24*r];
            } else if ([comp weekday]==7) {
                finalFollowupDate = [followupDate addTimeInterval:-60*60*24];
            } else {
                finalFollowupDate = followupDate;
            }
        } else {
            finalFollowupDate = followupDate;
        }
        
        [self changeReviewDate:finalFollowupDate:YES];
        
        
        [format setDateFormat:@"YYYY-MM-dd"];
        NSString *followupDateStr = [format stringFromDate:finalFollowupDate];
        dateText = followupDateStr;
        [dateText retain];
        
        NSArray *dateTemp = [dateText componentsSeparatedByString:@"-"];
        
        NSArray *months = [NSArray arrayWithObjects:
                           @"Jan", @"Feb",@"Mar", @"Apr", @"May", @"Jun",
                           @"Jul", @"Aug", @"Sep",@"Oct", @"Nov", @"Dec", nil];
        
        
        if ([dateTemp count] > 2) {
            
            if ([[dateTemp objectAtIndex:2] rangeOfString:@" "].location != NSNotFound) {
                
                dateLbl.text = [NSString stringWithFormat:@"%@ %@, %@",
                                [months objectAtIndex: [[dateTemp objectAtIndex:1] intValue]-1],
                                [[dateTemp objectAtIndex:2] substringToIndex:
                                 [[dateTemp objectAtIndex:2] rangeOfString:@" "].location],
                                [dateTemp objectAtIndex:0]];
            } else {
                dateLbl.text = [NSString stringWithFormat:@"%@ %@, %@",
                                [months objectAtIndex: [[dateTemp objectAtIndex:1] intValue]-1],
                                [dateTemp objectAtIndex:2],
                                [dateTemp objectAtIndex:0]];
            }
            
            
        } else {
            dateLbl.text = @"";
        }
        
    }
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    
        [theRoot updateFollowupDate:dateText:eventIDStr];
    
    totalString = [theRoot replaceElement:6 :dateText :totalString];
    [totalString retain];
       if (previous) {
        
        [previous updateFollowupDateInfo:dateText:priorityNum:dateLbl.text];
    }
    }

}






//if a post has more than 8000 words, need to break it up and 
//add it to the database in chunks
- (void) secondSet:(NSString *)str {
    
    NSString *theWords;
    
    if (str.length > 8000) {
        theWords = [str substringToIndex:8000];
        [self secondSet:[str substringFromIndex:8000]];
    } else {
        theWords = str;
    }
    
    NSString *editDescSite = [NSString stringWithFormat:@"http://%@/UpdateEventDescriptionPart2.php?mUser=%@&mPassword=%@&EventDescription=%@&EventID=%@",
                              [theRoot.serverInfo objectAtIndex:0], 
                              [theRoot.serverInfo objectAtIndex:3],
                              [theRoot.serverInfo objectAtIndex:4], 
                              theWords, eventIDStr];

    
    NSError *error;
    
    NSString *editDesc = [NSString stringWithContentsOfURL: 
                          [NSURL URLWithString:
                           editDescSite]
                                                  encoding:NSASCIIStringEncoding error:&error];
    
}





- (IBAction) backgroundClicked:(id)sender {
    [notes resignFirstResponder];
}




- (IBAction) linkBtnClicked:(id)sender {
    if (hyperlinkTxt.text.length > 1) {
        NSURL *url = [[ NSURL alloc] initWithString: hyperlink];
        [[UIApplication sharedApplication] openURL:url];
        [url release];
    }
}





- (IBAction) completeBtnPushed:(id)sender {
  
    if (!isLoading) {
    
    [self changeUISegmentFont:openClosedSeg];
    
    //***********************Need to check to see if the event has been updated in the last day*****
    // if not, present a box that asks them to please write about how the event came to a close.
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSString *testString;
    if ([lastUpdateStr rangeOfString:@" "].location!=NSNotFound) {
        testString = [lastUpdateStr substringToIndex:[lastUpdateStr rangeOfString:@" "].location];
    } else {
        testString = lastUpdateStr;
    }
    if ((![testString isEqualToString:[format stringFromDate:[NSDate date]]]) &&
        openClosedSeg.selectedSegmentIndex==1){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete Event" 
                                                        message:[NSString stringWithFormat:@"Please write a few notes about how %@ came to a close.", eventName]
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles: nil];	
        [alert show];
        [alert release];
    } 
        
        if (currentSwitch==0) {
            currentSwitch = 1;
        } else {
          currentSwitch = 0;
        }
        int test = [theRoot getElementsIndexOfStringContaining:eventIDStr:1];
      
        if (test<999) {
            
            
           
            //It must be deleted from the list if it is in it.  The Root should delete it from the datase.
            [theRoot tableView:theRoot.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
            //*************************************************************end of updating in DB***
            //**********now update in the root************
            
        } else if (theRoot.depth == 3) {
            
            //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
            //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
            //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
            
            [theRoot addNewEvent: totalString];
        }
        
            NSString *UpdateIsComplete;
            
            if (openClosedSeg.selectedSegmentIndex == 0) {
                
                
                
                UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateEventComplete.php?mUser=%@&mPassword=%@&EventID=%@&EventComplete=%d",
                                    [theRoot.serverInfo objectAtIndex:0],
                                    [theRoot.serverInfo objectAtIndex:3],
                                    [theRoot.serverInfo objectAtIndex:4],
                                    eventIDStr, 0];
                
            } else {
                
               
                
                UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateEventComplete.php?mUser=%@&mPassword=%@&EventID=%@&EventComplete=%d",
                                    [theRoot.serverInfo objectAtIndex:0],
                                    [theRoot.serverInfo objectAtIndex:3],
                                    [theRoot.serverInfo objectAtIndex:4],
                                    eventIDStr, 1];
                
            }
            
            NSError *error;
            
            NSString *isComplete = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     UpdateIsComplete]
                                                            encoding:NSASCIIStringEncoding error:&error];
          
    }
}





- (void) updateDocumentSelected:(NSString *)name:(UIViewController *)view{
    [popoverController dismissPopoverAnimated:YES];
    documentsTxt.text = name;
    nextView = view;
}




- (IBAction)showDocPushed:(id)sender {
    if (documentsTxt.text.length >1) {
        nextView.title = documentsTxt.text;
        [self.navigationController pushViewController:nextView animated:YES];
    }
}






- (IBAction) linksTextPushed:(id)sender {
    
    LinksTable *links = [[LinksTable alloc] initWithNibName:@"LinksTable" bundle:nil];
    
    links.elements = linksArray;
                     
    links.parent = self;
    links.theRoot = theRoot;
    links.eventIDStr = eventIDStr;
    
	[popoverController setContentViewController:links];
	[popoverController setPopoverContentSize:CGSizeMake(241, 302)];
	[popoverController presentPopoverFromRect:hyperlinkTxt.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}






- (void)updateLink:(NSString *)str:(BOOL)first {
    [popoverController dismissPopoverAnimated:YES];
    if (first) {
        NSArray *temp = [str componentsSeparatedByString:@"~+~"];
        hyperlink = [temp objectAtIndex:0];
        hyperlinkTxt.text = [temp objectAtIndex:1];
    }
    [hyperlink retain];
}







- (IBAction) contactBtnPushed:(id)sender {
    
    if (contactText.text.length > 1) {
    
        ContactQuickViewController *contactView = [[ContactQuickViewController alloc] initWithNibName:@"ContactQuickView" bundle:nil];
    
        contactView.needPush = YES;
        contactView.contactID = contactPersonID;
        contactView.theRoot = theRoot;
    
        [popoverController setContentViewController:contactView];
        [popoverController setPopoverContentSize:CGSizeMake(297, 176)];
        [popoverController presentPopoverFromRect:contactText.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}






- (IBAction) documentsBtnPushed:(id)sender {
    
    /*
    
    //here we need to fetch the blob from the database... somehow
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSString *url = [NSString stringWithFormat:@"http://%@/GetDocument.php?mUser=%@&mPassword=%@",
                     [theRoot.serverInfo objectAtIndex:0],
                     [theRoot.serverInfo objectAtIndex:3],
                     [theRoot.serverInfo objectAtIndex:4]];
	
    [request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (response) {
        NSLog(@"response is not nil");
        NSString *description = [response description];
        NSLog(@"description: %@", description);
    } else {
        NSLog(@"response is nil");
    }
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES); 
    
    NSString *filename = @"Test1.pdf"; 
    
    NSString *dirPath = [dirs objectAtIndex:0]; 
    
    NSError *error = nil;
    NSString *path=[dirPath stringByAppendingPathComponent:filename];
    [response writeToFile:path atomically:YES];
   
    NSLog(@"Write returned error: %@", [error localizedDescription]);
    [appDelegate.allFiles addObject:path];
     NSLog(@"allFiles: %@", appDelegate.allFiles);
    
	
    	
    NSURL *theGreaturl = [NSURL fileURLWithPath: path];
    
    DocumentDisplayView *docDisplay = [[DocumentDisplayView alloc] init];
    docDisplay.pdfUrl = theGreaturl;
    [self.navigationController pushViewController:docDisplay animated:YES];
    
     */
    
    //this presents the list of documents - its fake so you are going to need to comment this 
    //out a bit later
    
    DocumentsListView *docView = [[DocumentsListView alloc] initWithNibName:@"DocumentsListView" bundle:nil];
    docView.parent = self;
    
	[popoverController setContentViewController:docView];
	[popoverController setPopoverContentSize:CGSizeMake(270, 382)];
	[popoverController presentPopoverFromRect:documentsTxt.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     
     
}







- (void)swipeLeftAction:(UISwipeGestureRecognizer *)gestureRecognizer {
	[theRoot leftSwipe: ourIndexPath:NO];
}






- (void)swipeRightAction:(UISwipeGestureRecognizer *)gestureRecognizer {
	[theRoot rightSwipe: ourIndexPath:NO];
}



//present email options
-(IBAction)emailTxtPressed:(id)sender {
    
}



//this will send an email using email options choice
-(IBAction)sendEmail:(id)sender {
    if (emailText.text.length > 1) {
        //do some stuff
    }
}


- (IBAction) switchValueChanged {
	
	if (complete.on) { 
		currentSwitch=1;
		if (previous) {
			[previous.complete setOn:YES];
			[previous switchValueChanged];
		}
		
	} else { 
		currentSwitch = 0;
		if (previous) {
			[previous switchValueChanged];
			[previous.complete setOn:NO];
		}
    }
}





- (IBAction) segValueChanged {
    //set date to match
    if (previous) {
		//set previous seg value to match
		[previous segValueChanged];
	}
}






- (IBAction) masterPushed: (id)sender {
	
	[rootViewController changeDetailTitle:@""];
    [theRoot turnOffDetailSwipe];
	[masterNav popToViewController:[[masterNav viewControllers] objectAtIndex:0] animated:YES];
	[self.navigationController popToViewController:[[self.navigationController viewControllers]
													objectAtIndex:0] animated:YES];
}






- (IBAction) personPopoverBtnPushed:(id)sender {
     
    [popoverController setContentViewController:personPopView];
    [popoverController setPopoverContentSize:CGSizeMake(237, 221)];
	[popoverController presentPopoverFromRect:personPopoverBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}





- (IBAction) changeLastUpdateDate: (BOOL)first {
    //NEED TO ADD A BOOL First variable to this method so don't update database all the time but should update in most 
    //PREVIOUS instances.
   
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MM/dd/YYYY"];
    lastUpdateLbl.text = [format stringFromDate:[NSDate date]];
    [format setDateFormat:@"YYYY-MM-dd"];
    lastUpdateStr = [format stringFromDate:[NSDate date]];
    [lastUpdateStr retain];
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    totalString = [theRoot replaceElement:7 :lastUpdateStr :totalString];
    [totalString retain];
   
    if (first) {
    
       
        [theRoot updateLastUpdateDate:[format stringFromDate:[NSDate date]]:eventIDStr];
        
  
    
        NSString *setDateSite = [NSString stringWithFormat:@"http://%@/UpdateLastUpdateDate.php?mUser=%@&mPassword=%@&EventID=%@&date=%@",
                        [theRoot.serverInfo objectAtIndex:0],
                        [theRoot.serverInfo objectAtIndex:3],
                        [theRoot.serverInfo objectAtIndex:4],
                        eventIDStr, [format stringFromDate:[NSDate date]]];
        [format release];
        NSError *error;
    
        NSString *setDate = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             setDateSite]
                         encoding:NSASCIIStringEncoding error:&error];
    }
}






- (IBAction) contactPersonPushed:(id)sender {
	[contactPopView doneSearching_Clicked:nil];
	[popoverController setContentViewController:contactPopView];
	[popoverController setPopoverContentSize:CGSizeMake(300, 400)];
	[popoverController presentPopoverFromRect:contactPopoverBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
	
}




- (IBAction) dateBtnPushed:(id)sender {
    datePopView.forPrint = NO;
    [datePopView updateView:nil];
	[popoverController setContentViewController:datePopView];
	[popoverController setPopoverContentSize:CGSizeMake(320, 248)];
	//[popoverController presentPopoverFromRect:CGRectMake(185,650,950,30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
	[popoverController presentPopoverFromRect:dateBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}


- (void) changeUISegmentFont:(UIView *) aView {
    
    if ([aView isKindOfClass:[UILabel class]]) {
		UILabel* label = (UILabel*)aView;
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont fontWithName:@"Cochin-Bold" size:13]];
	}
	NSArray* subs = [aView subviews];
	NSEnumerator* iter = [subs objectEnumerator];
	UIView* subView;
	while ((subView = [iter nextObject])) {
        [self changeUISegmentFont:subView];
	}
}


- (void) changeOpenUISegmentFont:(UIView *) aView {

    
    if ([aView isKindOfClass:[UILabel class]]) {
		UILabel* label = (UILabel*)aView;
        CGRect temp = label.frame;
        label.frame = CGRectMake(CGRectGetMinX(temp) , CGRectGetMinY(temp), CGRectGetWidth(temp)+2, CGRectGetHeight(temp));
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont fontWithName:@"Cochin-Bold" size:13]];
	}
	NSArray* subs = [aView subviews];
	NSEnumerator* iter = [subs objectEnumerator];
	UIView* subView;
	while ((subView = [iter nextObject])) {
        [self changeOpenUISegmentFont:subView];
	}
}



- (void) changeReviewDate:(NSDate *)date:(BOOL)first {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy"];
	dateLbl.text =  [format stringFromDate:date];
	dateLbl.textColor = [UIColor blackColor];
    dateLbl.font = [UIFont fontWithName:@"Cochin" size:16];
	
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    totalString = [theRoot replaceElement:6 :[format stringFromDate:date] :totalString];
    [totalString retain];
    
   if (previous) {
		[previous changeReviewDate:date:NO];
	}
    
    if (first) {
        
        //send to php to update the review date.
        [format setDateFormat:@"YYYY-MM-dd"];
        
        NSString *changeDateSite = [NSString stringWithFormat:@"http://%@/UpdateFollowupDate.php?mUser=%@&mPassword=%@&EventID=%@&FollowupDate=%@&Triage=%d",
                                    [theRoot.serverInfo objectAtIndex:0],
                                    [theRoot.serverInfo objectAtIndex:3],
                                    [theRoot.serverInfo objectAtIndex:4],
                                    eventIDStr,[format stringFromDate:date], priorityNum];
        
        NSError *error;
        
        NSString *changeDate = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 changeDateSite]
                                                        encoding:NSASCIIStringEncoding error:&error];
        
        if ((eventsMode.length < 1) && ([theRoot.mode isEqualToString:@"Projects"])) {
            [theRoot updateReviewDate:[format stringFromDate:date]:priorityNum:eventIDStr];
       
        } else if ((theRoot.currentPriority >= priorityNum) && ([theRoot.elementsArray containsObject:totalString])) {
            
            if ((eventsMode.length > 1) && ([theRoot.mode isEqualToString:@"Events"])) {
                [theRoot updateReviewDate:[format stringFromDate:date]:priorityNum:eventIDStr];
            }
        }
    }
}
	



//******** HOLD DOWN DATE KEY ***********

-(IBAction) startAction: (id)sender
{
    NSLog(@"startAction");

    holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(actionToRepeat:) userInfo:nil repeats:YES];
    [holdTimer retain];
}

-(IBAction) stopAction: (id)sender
{
   
    [holdTimer invalidate];
    [holdTimer release];
    holdTimer = nil;
    
}

-(void) actionToRepeat:(NSTimer *)timer
{
    ++holderCount;
    if (holderCount==2) {
        //display the datewheel
        datePopView.forPrint = YES;
        datePopView.lastDate = theRoot.lastPrintDate;
        [datePopView updateView:theRoot.lastPrintDate];
        [popoverController setContentViewController:datePopView];
        [popoverController setPopoverContentSize:CGSizeMake(320, 248)];
        //[popoverController presentPopoverFromRect:CGRectMake(185,650,950,30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [popoverController presentPopoverFromRect:insertDateBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        datePopView.forPrint = NO;
    }
}
       
- (void)changeForPrint:(NSDate *)printDate {
    [popoverController dismissPopoverAnimated:YES];
    [theRoot updateLastPrintDate:printDate];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/YYYY"];
    
    notes.scrollEnabled = NO;
    int lengthMeas;
    
    if ([notes.text isEqualToString:@""]){
        notes.text = [NSString stringWithFormat:@"%@ - %@: ", [format stringFromDate:printDate], theRoot.UserInitials];
        lengthMeas = notes.text.length;
    } else {       
        notes.text = [NSString stringWithFormat:@"%@ - %@: \n\n%@", [format stringFromDate:printDate], theRoot.UserInitials, notes.text]; 
        NSString *temp = [NSString stringWithFormat:@"%@ - %@: ", [format stringFromDate:printDate], theRoot.UserInitials];
        lengthMeas = temp.length;
    }
    
    notes.scrollEnabled = YES;
    notes.selectedRange = NSMakeRange(lengthMeas, 0);

    [format release];
}

////*************************************



- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
  
}





- (void)dealloc {
	
    [super dealloc];
}

@end
