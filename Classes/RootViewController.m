//
//  RootViewController.m
//  Scrap2
//
//  Created by Kelsey Levine on 4/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "Scrap2AppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "EventDetail-Proj.h"
#include <stdlib.h>
#import "WorkGroupTblView.h"
#import "FullContactViewController.h"



@implementation RootViewController

@synthesize detailViewController, elementsArray, mode, eventMode, serverInfoStr;
@synthesize usernameTxt, passwordTxt, userIDNum, serverInfo;
@synthesize LoginName, UserPassword, UserName, UserInitials, isManager, isFollowup;
@synthesize issueName, issueID, projectName, projectID, newEventTxt, currentSeg, fromSwipe, swipeCount;
@synthesize isRightSwipe, lastView, titleStr, lastSelectedRow, depth, eventController, PMIdTxt,currentPriority;
@synthesize allProjects, finalProjectsStr, workGroupsArray, popoverController, workGroupID;
@synthesize finalEventsProjectsStr, allEventsProjects, workGroupStr, newEvent, openedUrl, indexArray;
@synthesize copyList, searching, lastPrintDate, parent;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    ////************************************
    
    NSLog(@"elementsarray: %@", elementsArray);
    appDelegate = (Scrap2AppDelegate *)[[UIApplication sharedApplication] delegate];
    //this is the file we are opening
    //openedUrl = appDelegate.openedUrl;
    letUserSelectRow = YES;
    newEvent = NO;
   
    
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	if (elementsArray == nil) {
		 self.title = @"Switchboard";
        self.titleStr = @"Switchboard";
		elementsArray = [[NSMutableArray alloc] initWithObjects: @"Events", @"Projects", @"Master Database", nil];
		mode = @"";
		depth = 0;
        lastSelectedRow = INFINITY;
		[self showLoginAlert];
        [titleStr retain];
		detailViewController.enableDueLSwipe = NO;
        detailViewController.enableDueRSwipe = NO;
	} 
	
    
    
    if (([mode isEqualToString:@"Projects"] && depth==3) || ([mode isEqualToString:@"Events"] && depth==2)) {
         self.tableView.separatorColor = [UIColor lightGrayColor];
    }
    
    if ([mode isEqualToString:@"Projects"]) {
        self.tableView.backgroundColor = [UIColor colorWithRed:.93 green:.93 blue:1 alpha:1];
    } else if ([mode isEqualToString:@"Events"] && (![eventMode isEqualToString:@"active"])) {
        if (depth == 2) {
            [allEventsProjects retain];
            workGroupStr = [[workGroupsArray objectAtIndex:0] substringFromIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location+3];
            [workGroupStr retain];
            
            
        }
        self.tableView.backgroundColor = [UIColor colorWithRed:1 green:.93 blue:.93 alpha:1];
    } else if ([mode isEqualToString:@""] || !mode){
        self.tableView.backgroundColor = [UIColor whiteColor];
    } else {
        
         self.tableView.backgroundColor = [UIColor colorWithRed:.93 green:1 blue:.93 alpha:1];
    }

    
    if ((!workGroupID)&&[mode isEqualToString:@"Events"] && (![eventMode isEqualToString:@"active"])) {
     
        workGroupID = [[[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location] retain];
    }
    
    if (!indexArray && [mode isEqualToString:@"Master"]) {
        indexArray = [[NSMutableArray alloc] init];
    }
    // create a custom navigation bar button and set it to always say "Back"
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = titleStr;
   // temporaryBarButtonItem.title = @" ";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
   
    if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"] || [mode isEqualToString:@"Projects-Master"]) {
       
        
        searching = NO;
        copyList = [[NSMutableArray alloc] init];
        if ([mode isEqualToString:@"Projects-Master"]) {
           
            self.title = @"Projects";
        } else {
            self.title = mode;
        }
        searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        searchBar.barStyle=UIBarStyleDefault;
        searchBar.showsCancelButton=NO;
        searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
        searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
        searchBar.delegate=self;
        
        if ([mode isEqualToString:@"Projects-Master"]) {
            self.tableView.tableHeaderView=searchBar;
        }
        
        if ([mode isEqualToString:@"Contacts"]) {
            UINavigationController *tempNav2 = [appDelegate.splitViewController.viewControllers objectAtIndex:1];
            
            FullContactViewController *contactView =[tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1]; 
            
            contactView.contact.theRoot = self;
        }
        
    }

    
    contactOpen = NO;
    
    if ([eventMode isEqualToString:@"active"]) {
        currentPriority = 1;
    } else {
        currentPriority = 3;
    }
	fromSwipe = NO;
	swipeCount = 0;
	
    // Make it look isManager up from the database so 
    // if it changes, we adjust for that - also change
    // it for the green part of the projects

    if (![mode isEqualToString:@""]) {
    
    NSError *error;
       
    
    NSString *getIsManager = [NSString stringWithFormat:@"http://%@/GetIsManager.php?mUser=%@&mPassword=%@&userIdNum=%@",
                               [serverInfo objectAtIndex:0],
                               [serverInfo objectAtIndex:3],
                               [serverInfo objectAtIndex:4],
                               userIDNum];
    
    
    isManager = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             getIsManager] encoding:NSASCIIStringEncoding error:&error];
    

	if (([mode isEqualToString:@"Projects"] && (![isManager isEqualToString:@"0"])) || [mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Projects-Master"] || [mode isEqualToString:@"Companies"]) {
		
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddButtonAction:)];
		
		[self.navigationItem setRightBarButtonItem:addButton];
		[addButton release];
		
		currentSeg = 0;
		
	}
    }
   
	
    detailViewController.theRoot = self;
       
    WorkGroupTblView *wgTble = [[WorkGroupTblView alloc] init];
   
    wgTble.theRoot = self;
   
}


- (void)turnOffDetailSwipe {
    detailViewController.enableDueLSwipe = NO;
    detailViewController.enableDueRSwipe = NO;
}

- (void) updateLastPrintDate:(NSDate *)aDate {
    lastPrintDate = aDate;
    
    if (parent) {
        [parent updateLastPrintDate:aDate];
    }
}


//the user presses a different priority on the top of the list
- (IBAction) changePrioritySeg:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [self changeUISegmentFont:segmentedControl];
    if (currentPriority != [segmentedControl selectedSegmentIndex]+1) {
        currentPriority = [segmentedControl selectedSegmentIndex]+1; 
    }
   
    [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers] objectAtIndex:0] animated:YES];
    
    detailViewController.enableDueRSwipe = NO;
    detailViewController.enableDueLSwipe = YES;
/*
    NSError *error;
    
  
        //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
        NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                               [serverInfo objectAtIndex:0],
                               [serverInfo objectAtIndex:3],
                               [serverInfo objectAtIndex:4],
                               userIDNum];
    
    
    
        NSString *workGroups = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             getWorkGroups]
                                                    encoding:NSASCIIStringEncoding error:&error];
    
    
        NSRange lastsquiggle1 = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
        
        if (lastsquiggle1.location != NSNotFound) {
            
            workGroupsArray = [[workGroups substringToIndex:lastsquiggle1.location] componentsSeparatedByString:@"~+~"];

        } else {
            workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
        }
       
    
    
    //separate projects into an array and each project into a little array with name and PMID
    
    
    //get ProjectName AND PMID FROM tblProjects WHERE isClosed==0;
    //~+~ between small and ~-~ between projects

    
            //Get the projects for the array
            NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetPMIDProjects.php?mUser=%@&mPassword=%@&PMID=%@",
                                     [serverInfo objectAtIndex:0], 
                                     [serverInfo objectAtIndex:3],
                                     [serverInfo objectAtIndex:4],
                                     workGroupID];    
    
    NSLog(@"getProjectsSite: %@", getProjectsSite);
            
            NSString *projects = [NSString stringWithContentsOfURL: 
                          [NSURL URLWithString:
                           getProjectsSite]
                                                  encoding:NSASCIIStringEncoding error:&error];
    
    
    
            NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
    
    if (lastsquiggle.location != NSNotFound) {
    
            allEventsProjects = [[projects substringToIndex:
                        lastsquiggle.location]
                       componentsSeparatedByString:@"~-~"];
    } else {
        allEventsProjects = [projects componentsSeparatedByString:@"~-~"];
    }
        
        [allEventsProjects retain];
   */
    
    
    
    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];
    int daysToAdd = -2;
    NSDate *afterDate = [now addTimeInterval:60*60*24*daysToAdd];
    NSDate *finalAfterDate;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:afterDate];
    
    //take out the weekends - get the last 48 hours from the week
    
    // 1 = Sunday, 2 = Monday, etc.
    if (([comp weekday]==1)||([comp weekday]==7)) {
        finalAfterDate = [afterDate addTimeInterval:-60*60*24*3];
        
    } else {
        finalAfterDate = afterDate;
    }
    
    
    
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString *afterDateStr = [format stringFromDate:finalAfterDate];

    
    
    NSString *eventsString;
    NSString *titleDetail;
    if ([eventMode isEqualToString:@"due"]) {
        eventsString = [self getDueEvents:[format stringFromDate:[NSDate date]]:currentPriority+1];
        titleDetail = @"Due for Review";
    } else if ([eventMode isEqualToString:@"active"]) {
        eventsString = [self getActiveEvents: currentPriority+1];
        titleDetail = @"Active Events";
    } else {
        
        NSError *error;
        
        NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&Triage=%d&DateAfter=%@&UserID=%@&WorkGroupID=%@",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   currentPriority+1,
                                   afterDateStr,userIDNum, workGroupID];   
        
        eventsString = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   getEventsSite] encoding:NSASCIIStringEncoding error:&error];
        

        titleDetail = @"Recent Events";
    }
    
    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
        elementsArray = [[eventsString substringToIndex:
                         eventsString.length-3]
                        componentsSeparatedByString:@"~-~"];
    } else {
        elementsArray = [eventsString componentsSeparatedByString:@"~-~"];
    }
  
   
    
    if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        self.title = [NSString stringWithFormat:@"%@ (0)",
                    titleDetail];
    } else {
        self.title = [NSString stringWithFormat:@"%@ (%d)",
                    titleDetail,
                    [elementsArray count]];
        
    }
    [elementsArray retain];
    [format release];
    [self.tableView reloadData];
    
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyList removeAllObjects];
      
	if([searchText length] > 0) {
		searching = YES;
		letUserSelectRow = YES;
		//self.tableView.scrollEnabled = YES;
		[self searchTableView];
       
	
    } else {
               
        for (NSMutableArray *array in elementsArray)
        {
            [copyList addObjectsFromArray:array];
        }
       
		[self.view.superview addSubview:black.view];
	}

    if ([copyList count] > 0) {
        [self.tableView reloadData];
    } else {
        searchBar.text = [searchText substringToIndex:searchText.length-1];
    }
    
}





- (void) searchTableView {
	
    
	searching = YES;
	
    
    NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];

	for (NSMutableArray *array in elementsArray)
	{
      
		[searchArray addObjectsFromArray:array];
	}
    
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0) {
			[copyList addObject:sTemp];
            
        }
	}

	[searchArray release];
	searchArray = nil;
}




- (void)searchBarCancelButtonClicked:(UISearchBar *)sBar {
	
    
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	searchBar.showsCancelButton=NO;
   	searching = NO;
	//self.tableView.scrollEnabled = YES;
	
    [black.view removeFromSuperview];
    [black release];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddButtonAction:)];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    [addButton release];
	
	[self.tableView reloadData];
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
    
        theSearchBar.superview.userInteractionEnabled = YES;
        
	
        searching = YES;
        for (NSMutableArray *array in elementsArray)
        {
            [copyList addObjectsFromArray:array];
        }
        
    
        //[searchBar becomeFirstResponder];
        letUserSelectRow = YES;
        self.tableView.scrollEnabled =YES;
        self.view.userInteractionEnabled = YES;
  
    if (!searching) {
        [self.tableView reloadData];
    }
	
    //Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(searchBarCancelButtonClicked:)] autorelease];
    
}


- (IBAction) latestSegmentAction:(id)sender {
    
    
    [self changeUISegmentFont:sender];
    
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	
	if (currentSeg != [segmentedControl selectedSegmentIndex]) {
        
		currentSeg = [segmentedControl selectedSegmentIndex];
        
    }
    
      
		NSString *geteventsSite;
		
        //If the user wants to see the closed events
		if (currentSeg==1) {
			self.navigationItem.rightBarButtonItem.enabled = NO;
            
            if (depth==3) {
                
                
                //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                geteventsSite = [NSString stringWithFormat:@"http://%@/GetClosedIssueEvents.php?mUser=%@&mPassword=%@&issueID=%@",
                                 [serverInfo objectAtIndex:0], 
                                 [serverInfo objectAtIndex:3],
                                 [serverInfo objectAtIndex:4],
                                 issueID];
                
                //getting closed issues
            } else if (depth==2) {
                
                //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                geteventsSite = [NSString stringWithFormat:@"http://%@/GetClosedProjectIssues.php?mUser=%@&mPassword=%@&ProjectID=%@",
                                 [serverInfo objectAtIndex:0], 
                                 [serverInfo objectAtIndex:3],
                                 [serverInfo objectAtIndex:4],
                                 projectID];
                
             //getting closed Projects
            } else if (depth==1) {
                
                NSError *error;
                //Get the projects for the array
                NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetClosedProjectsTest.php?mUser=%@&mPassword=%@&UserID=%@",
                                             [serverInfo objectAtIndex:0], 
                                             [serverInfo objectAtIndex:3],
                                             [serverInfo objectAtIndex:4],
                                             userIDNum];
                
                
                NSString *projects = [NSString stringWithContentsOfURL: 
                                      [NSURL URLWithString:
                                       getProjectsSite] encoding:
                                      NSASCIIStringEncoding error:&error];
                
                
                
                NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];              
                
                //ASSIGN NEXTELEMENTS
                elementsArray = [[projects substringToIndex:
                                  lastsquiggle.location]
                                 componentsSeparatedByString:@"~-~"];            }
			
            
            //else if the user wants to see all open things
		} else {
          
            
			self.navigationItem.rightBarButtonItem.enabled = YES;
			
            
            //open events
            if (depth == 3) {
                
                //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                geteventsSite = [NSString stringWithFormat:@"http://%@/GetIssueEvents.php?mUser=%@&mPassword=%@&issueID=%@",
                                 [serverInfo objectAtIndex:0], 
                                 [serverInfo objectAtIndex:3],
                                 [serverInfo objectAtIndex:4],
                                 issueID, 
                                 [segmentedControl selectedSegmentIndex]];
           //open issues
            } else if (depth == 2) {
                //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                geteventsSite = [NSString stringWithFormat:@"http://%@/GetProjectIssues.php?mUser=%@&mPassword=%@&ProjectID=%@",
                                 [serverInfo objectAtIndex:0], 
                                 [serverInfo objectAtIndex:3],
                                 [serverInfo objectAtIndex:4],
                                 projectID];
                
                
                
             //open projects
            } else {
                
                NSError *error;
                //Get the projects for the array
                NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetProjectsTest.php?mUser=%@&mPassword=%@&UserID=%@",
                                             [serverInfo objectAtIndex:0], 
                                             [serverInfo objectAtIndex:3],
                                             [serverInfo objectAtIndex:4],
                                             userIDNum];
                
                
                NSString *projects = [NSString stringWithContentsOfURL: 
                                      [NSURL URLWithString:
                                       getProjectsSite] encoding:
                                      NSASCIIStringEncoding error:&error];
                
                
                
                NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];              
                
                //ASSIGN NEXTELEMENTS
                elementsArray = [[projects substringToIndex:
                                  lastsquiggle.location]
                                 componentsSeparatedByString:@"~-~"];
                
                
            }
            
		}
        
		
        if (depth != 1) {
            
            NSError *error;
            
            
            
            //EventName~+~EventID~+~EventDescription
            NSString *events = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 geteventsSite]
                                                        encoding:NSASCIIStringEncoding error:&error];
            
            NSRange lastsquiggle = [events rangeOfString:@"~-~" options:NSBackwardsSearch];
            
            if (lastsquiggle.location != NSNotFound) {
                elementsArray = [[events substringToIndex:
                                  lastsquiggle.location]
                                 componentsSeparatedByString:@"~-~"];
                
            } else {
                elementsArray = [events componentsSeparatedByString:@"~-~"];
                
				
            }
        }
	
        
    
		if ([[elementsArray objectAtIndex:0] isEqualToString:@""]) {
			titleStr = [NSString stringWithFormat:@"%@(0)",
                        [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
		} else {
			titleStr = [NSString stringWithFormat:@"%@(%d)",
                        [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                        [elementsArray count]];
			
		}
        
        [titleStr retain];
		[elementsArray retain];
		
        
		[self.tableView reloadData];
	
}

- (void)updateFollowupDate:(NSString *)followupDate:(NSString *)eventID {
    
    //if in events, the event id is 3rd because we put the project id first.
    
        //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
        //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
        //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
        
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
        
        NSString *dateReplaced;
        
        if ([mode isEqualToString:@"Projects"]) {
        
            dateReplaced = [self replaceElement:6:followupDate:[elementsArray objectAtIndex:theIndex]];
        } else {
            dateReplaced = [self replaceElement:7:followupDate:[elementsArray objectAtIndex:theIndex]];
        }
        NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
        [tempMute replaceObjectAtIndex:theIndex withObject:dateReplaced];
        elementsArray = tempMute;
        [elementsArray retain];
        [tempMute release];

    }
}

- (void)updateEventTriage:(NSString *)triage:(NSString *)eventID {
        
    //if in events, the event id is 3rd because we put the project id first.
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
        NSString *triageReplaced;
        
        if ([mode isEqualToString:@"Projects"]) {
        
            triageReplaced = [self replaceElement:5:triage:[elementsArray objectAtIndex:theIndex]];
           
        }else{
            triageReplaced = [self replaceElement:6:triage:[elementsArray objectAtIndex:theIndex]];
        }
        
        NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
        [tempMute replaceObjectAtIndex:theIndex withObject:triageReplaced];
        elementsArray = tempMute;
        [elementsArray retain];
        [tempMute release];
    }
    
}


- (void)updateEventContact: (NSString *)contactPersonID: (NSString *)contactPerson: (NSString *)eventID{
    
    //if in events, the event id is 3rd because we put the project id first.
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
        
        NSString *personReplaced;
        
        if ([mode isEqualToString:@"Projects"]) {
     
            NSString *IDReplaced = [self replaceElement:4:contactPersonID:[elementsArray objectAtIndex:theIndex]];
            personReplaced = [self replaceElement:8:contactPerson:IDReplaced];
            
          
        } else {
            NSString *IDReplaced = [self replaceElement:5:contactPersonID:[elementsArray objectAtIndex:theIndex]];
            personReplaced = [self replaceElement:9:contactPerson:IDReplaced];
        }
            
        NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
        [tempMute replaceObjectAtIndex:theIndex withObject:personReplaced];
        elementsArray = tempMute;
        [elementsArray retain];
        [tempMute release];
    }
}



- (void) updatePersonAssigned:(NSString *)personName:(NSString *)IDnum: (NSString *)eventID {
        
        //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
        //eventFollowupDate~+~LastUpdate~+~contactName+_+UserNameassigned~+~Respons01~+~Hyperlink01~+~
        //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
        
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
        
        NSString *IDReplaced;
        
        if ([mode isEqualToString:@"Projects"]) {
            NSString *personReplaced = [self replaceElement:9:personName:[elementsArray objectAtIndex:theIndex]];
            IDReplaced = [self replaceElement:10:IDnum:personReplaced];
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
      
            [tempMute replaceObjectAtIndex:theIndex withObject:IDReplaced];
            elementsArray = tempMute;
        } else if ([mode isEqualToString:@"Events"]) {
            
            NSString *personReplaced = [self replaceElement:10:personName:[elementsArray objectAtIndex:theIndex]];
            IDReplaced = [self replaceElement:11:IDnum:personReplaced];
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
            [tempMute replaceObjectAtIndex:theIndex withObject:IDReplaced];
            elementsArray = tempMute;
            [elementsArray retain];
            [tempMute release];
        }
    }
}



- (void) updateLastUpdateDate:(NSString *)dateStr:(NSString *)eventID {
    
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
        
        NSString *replaceDate;
        
        if ([mode isEqualToString:@"Projects"]) {
            replaceDate = [self replaceElement:7:dateStr:[elementsArray objectAtIndex:theIndex]];
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
            
            [tempMute replaceObjectAtIndex:theIndex withObject:replaceDate];
            elementsArray = tempMute;
        } else if  ([mode isEqualToString:@"Events"]){
            
                replaceDate = [self replaceElement:8:dateStr:[elementsArray objectAtIndex:theIndex]];
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
    
            [tempMute replaceObjectAtIndex:theIndex withObject:replaceDate];
            elementsArray = tempMute;
            [elementsArray retain];
            [tempMute release];
        }
    }
}




- (void) updateReviewDate:(NSString *)dateStr:(int)priority:(NSString *)eventID {
    
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
            
            NSString *priorityReplaced;
            
            if ([mode isEqualToString:@"Projects"]) { 
                
                NSString *dateReplaced=[self replaceElement:6:dateStr:[elementsArray objectAtIndex:theIndex]];
                priorityReplaced = [self replaceElement:5:[NSString stringWithFormat:@"%d",priority]:dateReplaced];
                
            } else if ([mode isEqualToString:@"Events"]){
                
                NSString *dateReplaced=[self replaceElement:7:dateStr:[elementsArray objectAtIndex:theIndex]];
                priorityReplaced = [self replaceElement:6:[NSString stringWithFormat:@"%d",priority]:dateReplaced];
            }
            
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
            
            [tempMute replaceObjectAtIndex:theIndex withObject:priorityReplaced];
            elementsArray = tempMute;
        [elementsArray retain];
        [tempMute release];
    }
}



- (void) updateEventDesc:(NSString *)str :(NSString *)eventID {
   
    int theIndex;
    
    if ([mode isEqualToString:@"Projects"]) {
        theIndex = [self getElementsIndexOfStringContaining:eventID :1];
    } else {
        theIndex = [self getElementsIndexOfStringContaining:eventID :2];
    }
    
    if (theIndex < 999) {
        
        NSString *notesReplaced;
        
            if ([mode isEqualToString:@"Projects"]) {
                notesReplaced = [self replaceElement:2:str:[elementsArray objectAtIndex:theIndex]];
            } else if ([mode isEqualToString:@"Events"]){
                notesReplaced = [self replaceElement:3:str:[elementsArray objectAtIndex:theIndex]];
            }
       
        
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elementsArray];
            [tempMute replaceObjectAtIndex:theIndex withObject:notesReplaced];
            elementsArray = tempMute;
        [elementsArray retain];
        [tempMute release];
        
            [self.tableView reloadData];
    }
}




-(NSString *) replaceElement:(int)num:(NSString *)new:(NSString *)old{
        
    NSArray *temp = [old componentsSeparatedByString:@"~+~"];
    NSString *str = [[[NSString alloc] init] autorelease];
    
        for (int i=0; i<[temp count]; ++i) {
            if (i==num) {
                if (i==0) {
                    str=new;
                } else {
                    str=[NSString stringWithFormat:@"%@~+~%@", str,new];
                }
            } else {
                if (i==0) {
                    str=[temp objectAtIndex:i];
                } else {
                    str=[NSString stringWithFormat:@"%@~+~%@", str, [temp objectAtIndex:i]];
                }
            }
        }
    return str;
}


- (int)getElementsIndexOfStringContaining:(NSString *)str:(int)place {
    
    int num = 999;
    
    for (int i=0; i<[elementsArray count]; ++i) {
        NSArray *temp = [[elementsArray objectAtIndex:i] componentsSeparatedByString:@"~+~"];
        if ([temp count] > 1) {
        if ([[temp objectAtIndex:place] isEqualToString:str]) {
            num = i;
        }
        }
    }
    return num;
}


//returns an array with the row, section as strings
- (NSIndexPath *)getElementsDividedIndexOfStringContaining:(NSString *)str:(int)place {
    
    NSIndexPath *path;
    
        for (int i=0; i<[elementsArray count]; ++i) {
            for (int j=0; j<[[elementsArray objectAtIndex:i] count]; ++j) {
        
            NSArray *temp = [[[elementsArray objectAtIndex:i] objectAtIndex:j] componentsSeparatedByString:@"~+~"];
            if ([temp count] > 1) {
                if ([[temp objectAtIndex:place] isEqualToString:str]) {
                    path = [NSIndexPath indexPathForRow:j inSection:i+1];
                }
            }
        }
    }
    return path;
}




//to add to the table when an event gets opened or closed
- (void)addNewEvent:(NSString *)str {
    
    
    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
    //eventFollowupDate~+~LastUpdate~+~contactName'UserName~+~Respons01~+~Hyperlink01~+~
    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
    NSArray *temp = [str componentsSeparatedByString:@"~+~"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *newDate = [dateFormat dateFromString: [temp objectAtIndex:7]];
    
    NSMutableArray *mutable = [NSMutableArray arrayWithArray:elementsArray];
    
    int track;
    
    if ([elementsArray count] == 0) {  
        [mutable addObject:str];
        track = 0;
        
    } else if ([[elementsArray objectAtIndex:0] isEqualToString:@""]) {
        [mutable removeAllObjects];
        
        elementsArray = mutable;
        [elementsArray retain];
        NSMutableArray* paths = [[NSMutableArray alloc] init];
        [paths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:NO];
        [mutable addObject:str];
        track = 0;
         
    } else {
    
    for (int i=0; i<[elementsArray count]; ++i) {
        
        
        NSArray *tempElement = [[mutable objectAtIndex:i] componentsSeparatedByString:@"~+~"];
        
         
        
        NSDate *elementDate = [dateFormat dateFromString:[tempElement objectAtIndex:7]];
        
        if ([newDate isEqualToDate:elementDate] || (newDate==[elementDate laterDate:newDate])) {
            [mutable insertObject:str atIndex:i];
            track = i;
            i = [elementsArray count];
            
        } else if (i == [mutable count]-1) {
            
            [mutable addObject:str];
            track = i+1;
        }
        
    }
        
    }
        
    elementsArray = mutable;
    [elementsArray retain];
        
        
        
       
        NSMutableArray* paths = [[NSMutableArray alloc] init];
        [paths addObject:[NSIndexPath indexPathForRow:track+1 inSection:0]];
   
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortraitUpsideDown) {
    
        EventDetail_Proj *tempEvent = [detailViewController.navigationController.viewControllers objectAtIndex:
                                       [detailViewController.navigationController.viewControllers count]-1];
        
        NSIndexPath *insertedIndexPath = [paths objectAtIndex:0];
        
        if (track == 0) {
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
            //also want to make the light red
            [tempEvent turnLeftRedLightOn];
            
            //and if there is only one item, both lights need to be on
            if ([elementsArray count] == 1) {
                [tempEvent turnRightRedLightOn];
            }
            
        } else if (track == [elementsArray count]-1) {
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
            [tempEvent turnRightRedLightOn];
        } else {
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationMiddle];
            [tempEvent turnOffBothRed];
        }
        
        
        [self.tableView selectRowAtIndexPath:insertedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        lastSelectedRow = insertedIndexPath.row;
        swipeCount = 0;
       
        tempEvent.ourIndexPath = insertedIndexPath;
       
    }
        
        if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
            titleStr = [NSString stringWithFormat:@"%@(0)",
                        [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
        } else {
            titleStr = [NSString stringWithFormat:@"%@(%d)",
                        [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                        [elementsArray count]];
            
        }
        
        
        [titleStr retain];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *lblTemp1;
        
        lblTemp1 = (UILabel *)[cell viewWithTag:5];
        lblTemp1.text = titleStr;
        [lblTemp1 setText:titleStr];
        
    
}


- (void) changeUISegmentFont:(UIView *) aView {
    
    if ([aView isKindOfClass:[UILabel class]]) {
		UILabel* label = (UILabel*)aView;
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont fontWithName:@"Cochin-Bold" size:15]];
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
        label.frame = CGRectMake(CGRectGetMinX(temp) , CGRectGetMinY(temp), CGRectGetWidth(temp)+8, CGRectGetHeight(temp));
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont:[UIFont fontWithName:@"Cochin-Bold" size:15]];
	}
	NSArray* subs = [aView subviews];
	NSEnumerator* iter = [subs objectEnumerator];
	UIView* subView;
	while ((subView = [iter nextObject])) {
        [self changeOpenUISegmentFont:subView];
	}
}


	
- (IBAction)AddButtonAction:(id)sender{
    
    UIAlertView *alert;
    
    NSLog(@"mode: %@", mode);
    
    if ([mode isEqualToString:@"Contacts"]) {
        
        NSLog(@"we will add a new contact");
        //get the fullContact
        UINavigationController *tempNav2 = [appDelegate.splitViewController.viewControllers objectAtIndex:1];
        
        
        FullContactViewController *contactView =[tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1]; 
        
        [contactView newContact];
        //get the current contact page
        //set the hidden window to edit mode
        //with a bool that says if it is in NEW CONTACT MODE
            //to blank out all the text boxes
            //and to allow it to save only if the user has entered a contact name
        
        
    } else if ([mode isEqualToString:@"Companies"]) {
        
        NSLog(@"we will add a new company");
        
        
    } else if ([mode isEqualToString:@"Projects-Master"]) {
        
        NSLog(@"We will add a new project");
    
    } else {
        
        if (depth==3) {
 
        alert = [[UIAlertView alloc] initWithTitle:@"New Event" 
													message:@"Please Enter the name of the new event."
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"Enter", nil];	
	
        [alert addTextFieldWithValue: @"" label: @"Event Name"];
	
	
    } else if (depth==2) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"New Issue" 
                                           message:@"Please Enter the name of the new issue."
                                          delegate:self 
                                 cancelButtonTitle:@"Cancel" 
                                 otherButtonTitles: @"Enter", nil];	
        
        [alert addTextFieldWithValue: @"" label: @"Issue Name"];
    } else {
        
        alert = [[UIAlertView alloc] initWithTitle:@"New Project" 
                                           message:@"Please Enter the name of the new project."
                                          delegate:self 
                                 cancelButtonTitle:@"Cancel" 
                                 otherButtonTitles: @"Enter", nil];	
        
        [alert addTextFieldWithValue: @"" label: @"Project Name"];
        [alert addTextFieldWithValue: @"" label: @"Work Group Name"];
        
        PMIdTxt = [alert textFieldAtIndex:1];
        
        PMIdTxt.keyboardType = UIKeyboardTypeAlphabet;
        PMIdTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
        PMIdTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
	newEventTxt = [alert textFieldAtIndex:0];
	
	newEventTxt.keyboardType = UIKeyboardTypeAlphabet;
	newEventTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
	newEventTxt.autocorrectionType = UITextAutocorrectionTypeNo;
	
	
	
	[alert show];
	[alert release];
	}
	
	
}


- (void) getUserData {
	
	NSString *getUserDataSite = [NSString stringWithFormat:
								 @"http://%@/GetUserData.php?mUser=%@&mPassword=%@&loginName=%@&userPassword=%@",
								 [serverInfo objectAtIndex:0], 
								 [serverInfo objectAtIndex:3],
								 [serverInfo objectAtIndex:4],
								 LoginName, UserPassword];
	
	
	NSError *error;
	
	//UserID~-~UserName~-~UserInitials~-~IsManager~-~IsFollowup
	NSString *userDataStr = [NSString stringWithContentsOfURL: 
					 [NSURL URLWithString:
					  getUserDataSite]
					encoding:NSASCIIStringEncoding error:&error];
	
	NSArray *userDataArray = [userDataStr componentsSeparatedByString:@"~-~"];
	
		
	userIDNum		= [[userDataArray objectAtIndex:0] retain];
	UserName		= [[userDataArray objectAtIndex:1] retain];
	UserInitials	= [[userDataArray objectAtIndex:2] retain];
	isManager		= [[userDataArray objectAtIndex:3] retain];
	isFollowup		= [[userDataArray objectAtIndex:4] retain];
	
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Table view data source



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    if (([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"] || 
         [mode isEqualToString:@"Projects-Master"]) && (!searching)) {
        
         NSString *sectionTitle;
        
        if ((section==0) && ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"])) {
            sectionTitle = @" ";
        } else if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"]) {
            sectionTitle = [[[[elementsArray objectAtIndex:section-1] objectAtIndex:0] substringToIndex:1] capitalizedString];
        } else {
            sectionTitle = [[[[elementsArray objectAtIndex:section] objectAtIndex:0] substringToIndex:1] capitalizedString];
        }
        
        // Create label with section title
        UILabel *label = [[[UILabel alloc] init] autorelease];
        label.frame = CGRectMake(19, 0, 284, 23);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Cochin" size:22];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.text = sectionTitle;
        label.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeaderBG.png"]];
        
        // Create header view and add label as a subview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
        view.backgroundColor = [UIColor blackColor];
        [view autorelease];
        [view addSubview:imageView];
        [view addSubview:label];
        
        return view;
       
	} else {
        return nil;
    }

   
}
 

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"] || 
         [mode isEqualToString:@"Projects-Master"]) && (!searching)) {
        if (section==0) {
            return @" ";
        } else {
            return [[[[elementsArray objectAtIndex:section-1] objectAtIndex:0] substringToIndex:1] capitalizedString];
        }
	} else {
        return nil;
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if(([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"] || [mode isEqualToString:@"Projects-Master"]) && (!searching) && ([self numberOfRowsInTable]>8)) {
        return indexArray;
	} else {
		return nil;
	}
    
}


- (int) numberOfRowsInTable {
    int i = 0;
    for (int k = 0; k < [elementsArray count]; ++k) {
        i = i + [[elementsArray objectAtIndex:k] count];
    }
    return i;
}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	//[self doneSearching_Clicked:nil];
	
    if(((![mode isEqualToString:@"Contacts"]) && (![mode isEqualToString:@"Companies"]) && (![mode isEqualToString:@"Projects-Master"])) || searching) {
		return -1;
	} else {
        
        if (index == 0) {
            [tableView setContentOffset:CGPointZero animated:NO];
            return NSNotFound;
        } else {
            if ([mode isEqualToString:@"Projects-Master"]) {
                return index-1;
            } else {
                return  index;
            }
        }
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    if (([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"])  && (!searching)) {
        return [elementsArray count]+1;
               
    } else if ([mode isEqualToString:@"Projects-Master"] && (!searching)) {
        return [elementsArray count];
    } else {
       
        return 1;
    }
}


- (void) selectTableRow:(int)row {
   
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row+1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}




- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (([mode isEqualToString:@"Projects"]) || ([mode isEqualToString:@"Events"] && depth==2)) {
            return [elementsArray count]+1;
        
	 } else if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"]) {
        if (searching) {
           
            return [copyList count]+1;
        } else {
            if (section == 0) {
            
                return 1;
            } else {
                return [[elementsArray objectAtIndex:section-1] count];
            }
        }
        
        
    } else if([mode isEqualToString:@"Projects-Master"]) {
        if (searching) {
            
            return [copyList count];
        } else {
            if (section == 0) {
                return 1;
            } else {
                return [[elementsArray objectAtIndex:section] count];
            }
        }

    } else {
		return [elementsArray count];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    for(UIView *view in [tableView subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            
            [view setBackgroundColor:[UIColor clearColor]];
            [view setFont:[UIFont fontWithName:@"Cochin" size:14]];
        }
    }
    
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		if  ([mode isEqualToString:@"Projects"] && depth == 3) {
			cell = [self getCellContentView:CellIdentifier]; 
            
        } else if ([mode isEqualToString:@"Events"] && depth == 2) {
            if ([eventMode isEqualToString:@"active"]) {
                cell = [self getActiveCellContent:CellIdentifier];
            } else {
                cell = [self getEventCellContent:CellIdentifier];
            }
        } else if ([mode isEqualToString:@"Projects"] && (depth == 2 || depth == 1)) {
            
                cell=[self getTitleCellContent:CellIdentifier];
       
        } else if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"]){
        
            cell = [self getGreenCellContent:CellIdentifier];
        } else {
		
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
       }
		cell.accessoryType = UITableViewCellAccessoryNone;
		
    }

	
    if ([elementsArray count]!=0) {
  
        if ((![mode isEqualToString:@"Contacts"]) &&
              (![mode isEqualToString:@"Companies"]) &&
            (![mode isEqualToString:@"Projects-Master"])) {
            
                if ([[elementsArray objectAtIndex:0] isEqualToString:@""]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }

    
	if ([mode isEqualToString:@"Events"] && depth == 2) {
			
		UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];	
		UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
		UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
		UISegmentedControl *segCont = (UISegmentedControl *)[cell viewWithTag:4];
		UITextField *textField = (UITextField *)[cell viewWithTag:5];
        UIImageView *image = (UIImageView *)[cell viewWithTag:6];
        UIButton *tempBtn = (UIButton *)[cell viewWithTag:7];
		UIImageView *segImage = (UIImageView *)[cell viewWithTag:8];
        UIButton *oneBtn = (UIButton *)[cell viewWithTag:9];
        UIButton *twoBtn = (UIButton *)[cell viewWithTag:10];
        UIButton *threeBtn = (UIButton *)[cell viewWithTag:11];
        
                                
        cell.userInteractionEnabled = YES;
        
        //EventName~+~EventID~+~EventDescription
        if (indexPath.row != 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            image.alpha = 0;
            if (([elementsArray count]!=0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
            	NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                
                lblTemp1.text = [temp objectAtIndex:0];
                lblTemp1.alpha = 1;
                lblTemp2.text = [temp objectAtIndex:1];
                lblTemp2.alpha = 1;
                lblTemp3.text = [temp objectAtIndex:3];
                lblTemp3.alpha = 1;
            } else {
                lblTemp1.text = @"";
                lblTemp1.alpha = 0;
                lblTemp2.text = @"";
                lblTemp2.alpha = 0;
                lblTemp3.text = @"";
                lblTemp3.alpha = 0;

            }
			tempBtn.alpha = 0;	
            textField.alpha = 0;
            image.alpha = 0;
            segCont.alpha = 0;
            segImage.alpha = 0;
            oneBtn.enabled = NO;
            twoBtn.enabled = NO;
            threeBtn.enabled = NO;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            textField.text = workGroupStr;
            textField.alpha = 1;
            lblTemp1.text = @"";
            lblTemp1.alpha = 0;
            lblTemp2.text = @"";
            lblTemp2.alpha = 0;
            lblTemp3.text = @"";
            lblTemp3.alpha = 0;
            segCont.alpha = 1;
            image.alpha = 1;
            tempBtn.alpha = 1;
            [segCont retain];
            currentPrioritySeg = segCont;
            oneBtn.enabled = YES;
            twoBtn.enabled = YES;
            threeBtn.enabled = YES;
            segImage.alpha = 1;
            [segCont addTarget:self action:@selector(changePrioritySeg:) 
              forControlEvents:UIControlEventValueChanged];
            segCont.selectedSegmentIndex = currentPriority-1;
        }
        
    } else if ([mode isEqualToString:@"Projects"] && depth == 3) {
        
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];	
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
        UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
        UISegmentedControl *segCont = (UISegmentedControl *)[cell viewWithTag:4];
        UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:5];
        UIImageView *image = (UIImageView *)[cell viewWithTag:6];
        UIButton *leftBlueBtn = (UIButton *)[cell viewWithTag:7];
        UIButton *rightBlueBtn = (UIButton *)[cell viewWithTag:8];
        UIImageView *barImage = (UIImageView *)[cell viewWithTag:9];
				
				if (indexPath.row!=0) {
                                      
					lblTemp4.alpha = 0;
                    image.alpha = 0;
					if (([elementsArray count] > 0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])
                        && (indexPath.row-1 < [elementsArray count])) {
						cell.userInteractionEnabled = YES;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
						//EventName~+~EventID~+~EventDescription
                        NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                        segCont.alpha = 0;
						lblTemp2.text = [temp objectAtIndex:0];
						lblTemp3.text = [temp objectAtIndex:2];
                        leftBlueBtn.enabled = NO;
                        rightBlueBtn.enabled = NO;
                        barImage.alpha = 0;
					} else {
						cell.userInteractionEnabled = YES;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
						segCont.alpha = 0;
						lblTemp2.text = @"";
						lblTemp3.text = @"";
                        leftBlueBtn.enabled = NO;
                        rightBlueBtn.enabled = NO;
                        barImage.alpha = 0;
                        
					}

					
				} else {
                    
                    lblTemp4.alpha = 1;
                    image.alpha = 1;
                    lblTemp4.text = titleStr;
                    self.navigationItem.titleView = nil;
					cell.userInteractionEnabled = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
					segCont.alpha = 1;
                    currentOpenCloseSeg = segCont;
					[segCont retain];
					[segCont addTarget:self action:@selector(latestSegmentAction:) 
					  forControlEvents:UIControlEventValueChanged];
					segCont.selectedSegmentIndex = currentSeg;
					lblTemp2.text = @"";
					lblTemp3.text = @"";
                    leftBlueBtn.enabled = YES;
                    rightBlueBtn.enabled = YES;
                    barImage.alpha = 1;
				}

			

        
    } else if ([mode isEqualToString:@"Projects"] && (depth == 2 || depth == 1)) {
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
        UISegmentedControl *segCont = (UISegmentedControl *)[cell viewWithTag:2];
        UIImageView *image = (UIImageView *)[cell viewWithTag:3];
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:4];
        UIButton *leftBtn = (UIButton *)[cell viewWithTag:5];
        UIButton *rightBtn = (UIButton *)[cell viewWithTag:6];
        UIImageView *barImage = (UIImageView *)[cell viewWithTag:7];
        
        if (indexPath.row==0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            lblTemp1.text = titleStr;
            lblTemp1.alpha = 1;
            [segCont retain];
            currentOpenCloseSeg = segCont;
            [segCont addTarget:self action:@selector(latestSegmentAction:) 
              forControlEvents:UIControlEventValueChanged];
            segCont.selectedSegmentIndex = currentSeg;
            segCont.alpha = 1;
            image.alpha = 1;
            lblTemp2.alpha = 0;
            leftBtn.enabled = YES;
            rightBtn.enabled = YES;
            barImage.alpha = 1;
            
        } else {
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if ([[elementsArray objectAtIndex:indexPath.row-1] rangeOfString: @"~+~"].location!=NSNotFound) {
                lblTemp2.text = [[elementsArray objectAtIndex:indexPath.row-1] 
                                 substringToIndex: [[elementsArray objectAtIndex:indexPath.row-1]
                                                    rangeOfString:@"~+~"].location];
            } else {
                lblTemp2.text = [elementsArray objectAtIndex:indexPath.row-1];
            }
            lblTemp1.alpha = 0;
            lblTemp2.alpha = 1;
            segCont.alpha = 0;
            image.alpha = 0;
            leftBtn.enabled = NO;
            rightBtn.enabled = NO;
            barImage.alpha = 0;
            
        }
        
	} else if([mode isEqualToString:@"Contacts"]||[mode isEqualToString:@"Companies"]){
        
        cell.userInteractionEnabled = YES;
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];	
        UITextField *textField = (UITextField *)[cell viewWithTag:3];
        UIImageView *image = (UIImageView *)[cell viewWithTag:2];
        UIButton *tempBtn = (UIButton *)[cell viewWithTag:4];
        UISearchBar *theSearchbar = (UISearchBar *)[cell viewWithTag:5];

        
        if (searching) {
            cell.userInteractionEnabled = YES;
            
                       
            if (indexPath.row!=0) {
                              
                lblTemp1.alpha = 1;
                lblTemp1.font = [UIFont fontWithName:@"Cochin" size:17];
                textField.alpha = 0;
                image.alpha = 0;
                tempBtn.alpha = 0;
                theSearchbar.alpha = 0;
                //cell.alpha = .5;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                lblTemp1.text = [[copyList objectAtIndex:indexPath.row-1] substringToIndex:
                                    [[copyList objectAtIndex:indexPath.row-1] rangeOfString:@"~+~"].location];

            } else {
             
                
                UITextField *textField2 = [[theSearchbar subviews] objectAtIndex:1];
              
                if ([textField2 isKindOfClass:[UITextField class]]) {
                     [textField2 setFont:[UIFont fontWithName:@"Cochin" size:18]];
                }
               
                if ([workGroupStr isEqualToString:@""] || (!workGroupStr)) {
                    textField.text = nil;
                    textField.placeholder = @"search by company";
                } else {
                    textField.text = workGroupStr;
                }
                
                lblTemp1.alpha = 0;
                image.alpha = 1;
                tempBtn.alpha = 1;
                theSearchbar.alpha = 1;
                textField.alpha = 1;
                
                [theSearchbar becomeFirstResponder];
                
                theSearchbar.delegate = self;
            }

            
        } else {
                
           
            if ((indexPath.row == 0) && (indexPath.section ==0)) {
                searchBar = theSearchbar;
                searchBar.delegate = self;
                searchBar.alpha = 1;
                UITextField *textField2 = [[searchBar subviews] objectAtIndex:1];
                
                if ([textField2 isKindOfClass:[UITextField class]]) {
                    [textField2 setFont:[UIFont fontWithName:@"Cochin" size:18]];
                }
                lblTemp1.alpha = 0;
                textField.alpha = 1;
                if([mode isEqualToString:@"Contacts"]) {
                    
                    if ([workGroupStr isEqualToString:@""]|| (!workGroupStr)) {
                        textField.text = nil;
                        textField.placeholder = @"search by company";
                    } else {
                        textField.text = workGroupStr;
                    }
                    textField.font = [UIFont fontWithName:@"Cochin" size:18];
                } else {
                    
                    
                    if ([workGroupStr isEqualToString:@""]|| (!workGroupStr)) {
                        textField.text = nil;
                        textField.placeholder = @"search by category";
                    } else {
                        textField.text = workGroupStr;
                    }
                    
                    
                    textField.font = [UIFont fontWithName:@"Cochin" size:18];
                }
                image.alpha = 1;
                tempBtn.alpha = 1;
                cell.selectionStyle = UITableViewCellEditingStyleNone;
           
            } else {
                NSArray *temp = [elementsArray objectAtIndex:indexPath.section-1];
                lblTemp1.text = [[temp objectAtIndex:indexPath.row] substringToIndex:
                                 [[temp objectAtIndex:indexPath.row] rangeOfString:@"~+~"].location];
                lblTemp1.alpha = 1;
                lblTemp1.font = [UIFont fontWithName:@"Cochin" size:17];
                textField.alpha = 0;
                image.alpha = 0;
                tempBtn.alpha = 0;
                theSearchbar.alpha = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                
               
            }
        }
        
    }else if([mode isEqualToString:@"Projects-Master"]) {
        if (searching) {
        
           cell.textLabel.text = [[copyList objectAtIndex:indexPath.row] substringToIndex:
             [[copyList objectAtIndex:indexPath.row] rangeOfString:@"~+~"].location];
        } else {
            NSArray *temp = [elementsArray objectAtIndex:indexPath.section];
          
            cell.textLabel.text = [[temp objectAtIndex:indexPath.row] substringToIndex:
                         [[temp objectAtIndex:indexPath.row] rangeOfString:@"~+~"].location];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    } else {
		cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		if ([[elementsArray objectAtIndex:indexPath.row] rangeOfString: @"~+~"].location!=NSNotFound) {
			cell.textLabel.text = [[elementsArray objectAtIndex:indexPath.row] 
								   substringToIndex: [[elementsArray objectAtIndex:indexPath.row]
													  rangeOfString:@"~+~"].location];
		} else {
			cell.textLabel.text = [elementsArray objectAtIndex:indexPath.row];
		}
		cell.textLabel.textColor = [UIColor whiteColor];
	}
    
    if ((![mode isEqualToString:@"Contacts"] && ![mode isEqualToString:@"Companies"] && ![mode isEqualToString:@"Projects-Master"])&&([elementsArray count] > 0) && ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
	if ([mode isEqualToString:@"Projects"] && depth == 3) {
		if ((indexPath.row == 0)&& [mode isEqualToString:@"Projects"]) {
			return 87;
		} else {
			return 70;
		}
  
    }else if ([mode isEqualToString:@"Events"] && depth == 2) {
      
        if (([eventMode isEqualToString:@"active"]) && (indexPath.row == 0)) {
            
            return 41;
        } else {
            
            return 78;
        }
    }else if ([mode isEqualToString:@"Projects"] && (depth == 2 || depth == 1)) {
        if (indexPath.row == 0) {
			return 87;
		} else {
			return 50;
		}
    } else if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"]) {
        if (indexPath.row == 0 && indexPath.section == 0) {
            return 86;
        } else {
            return 50;
        }
    } else {
		return 50;
	}

	
}

//the content of the cells in the Active Event List
- (UITableViewCell *) getActiveCellContent:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(10, 5, 270, 15);
	CGRect Label2Frame = CGRectMake(10, 20, 270, 20);
	CGRect Label3Frame = CGRectMake(20, 26, 270, 60);
	CGRect SegFrame = CGRectMake(-3.0f, -2, 326.0f, 44.0f);
	UILabel *lblTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
    //Project label
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:16];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //event name label
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 2;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:16];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //descriptor label
	//Initialize seg with tag 3.
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 3;
	lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	lblTemp.numberOfLines = 2;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:14];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    //Initialize Label with tag 4;
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] 
											initWithItems:
											[NSArray arrayWithObjects:
											 @"1", @"2",@"3", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.tag = 4;
	segmentedControl.alpha = 0;
	segmentedControl.selectedSegmentIndex = 2;
	segmentedControl.frame = SegFrame;
    [self changeOpenUISegmentFont:segmentedControl];
	[cell.contentView addSubview:segmentedControl];
    
    return cell;
}




- (UITableViewCell *) getEventCellContent:(NSString *)cellIdentifier {
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(10, 5, 270, 15);
	CGRect Label2Frame = CGRectMake(10, 20, 270, 20);
	CGRect Label3Frame = CGRectMake(20, 26, 270, 60);
	CGRect SegFrame = CGRectMake(-3.0f, 41, 326.0f, 38.0f);
    CGRect fakeSegFrame = CGRectMake(0, 41, 320, 36);
    CGRect TextFrame = CGRectMake(60, 6, 200, 28);
    CGRect ImageFrame = CGRectMake(0, -3, 321, 46);
    CGRect OneBlueFrame = CGRectMake(0, 42, 105, 34);
    CGRect TwoBlueFrame = CGRectMake(106, 42, 108, 34);
    CGRect ThreeBlueFrame = CGRectMake(215, 42, 105, 34);
    
	UILabel *lblTemp;
    UIImageView *image;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
    //Project label
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:16];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //event name label
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 2;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:16];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //descriptor label
	//Initialize seg with tag 3.
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 3;
	lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	lblTemp.numberOfLines = 2;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:14];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    //Initialize Label with tag 4;
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] 
											initWithItems:
											[NSArray arrayWithObjects:
											 @"1", @"2",@"3", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tag = 4;
	segmentedControl.alpha = 0;
	segmentedControl.selectedSegmentIndex = 2;
	segmentedControl.frame = SegFrame;
    [self changeOpenUISegmentFont:segmentedControl];
	[cell.contentView addSubview:segmentedControl];
    
    //This is the little grey bar across the top
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleBar"]];
    image.frame = ImageFrame;
	image.tag = 6;
    [cell.contentView addSubview:image];
	[image release];
    
    
    //so the user can select which work group's events they would like to see
    //Initialize Label with tag 5;
    UITextField *textField = [[UITextField alloc] initWithFrame:TextFrame];

    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor]; //text color
    textField.font = [UIFont fontWithName:@"Cochin" size:18];  //font size
    
    textField.backgroundColor = [UIColor clearColor]; //background color
    textField.tag = 5;
    textField.textAlignment = UITextAlignmentCenter;
	[cell.contentView addSubview:textField];
	[textField release];
	
    //The button to bring up a table to choose the work group.
    //need to give it a tag too so that user cannot press it when not
    //in the top row.  Tag will be 7
    UIButton *wgButton = [[UIButton alloc] initWithFrame:TextFrame];
    wgButton.backgroundColor = [UIColor clearColor];
    wgButton.tag = 7;
    [wgButton addTarget:self action:@selector(displayWorkGroupTbl:) 
      forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:wgButton];
    
    //the image of the segmented control
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ThreeSelectedRoot.png"]];
    image.frame = fakeSegFrame;
    image.tag = 8;
    [cell.contentView addSubview:image];
    [image release];
    
   
    //bluecoverbuttonleft:
    UIButton *oneCoverBtn = [[UIButton alloc] initWithFrame:OneBlueFrame];
    oneCoverBtn.backgroundColor = [UIColor clearColor];
    [oneCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [oneCoverBtn addTarget:self action:@selector(pressOneSeg:) forControlEvents:UIControlEventTouchUpInside];
    oneCoverBtn.clipsToBounds = YES;
    oneCoverBtn.alpha = .58;
    oneCoverBtn.tag = 9;
    [cell.contentView addSubview:oneCoverBtn];
    [oneCoverBtn release];
    
    //bluecoverbuttonright:
    UIButton *twoCoverBtn = [[UIButton alloc] initWithFrame:TwoBlueFrame];
    twoCoverBtn.backgroundColor = [UIColor clearColor];
    [twoCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [twoCoverBtn addTarget:self action:@selector(pressTwoSeg:) forControlEvents:UIControlEventTouchUpInside];
    twoCoverBtn.clipsToBounds=YES;
    twoCoverBtn.alpha = .58;
    twoCoverBtn.tag = 10;
    [cell.contentView addSubview:twoCoverBtn];
    [twoCoverBtn release];

    
    //bluecoverbuttonright:
    UIButton *threeCoverBtn = [[UIButton alloc] initWithFrame:ThreeBlueFrame];
    threeCoverBtn.backgroundColor = [UIColor clearColor];
    [threeCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [threeCoverBtn addTarget:self action:@selector(pressThreeSeg:) forControlEvents:UIControlEventTouchUpInside];
    threeCoverBtn.clipsToBounds=YES;
    threeCoverBtn.alpha = .58;
    threeCoverBtn.tag = 11;
    [cell.contentView addSubview:threeCoverBtn];
    [threeCoverBtn release];

    return cell;

}


//For the green section, we will need a text box for 
//the categories in the top cell
- (UITableViewCell *) getGreenCellContent:(NSString *)cellIdentifier {
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(18, 15, 285, 25);
    CGRect TextFrame = CGRectMake(60, 52, 200, 28);
    CGRect ImageFrame = CGRectMake(0, 41, 321, 46);

    
	UILabel *lblTemp;
    UIImageView *image;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
    //Project label
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
	lblTemp.font = [UIFont fontWithName:@"Cochin" size:18];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
		
    //This is the little grey bar across the top
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleBar"]];
    image.frame = ImageFrame;
	image.tag = 2;
    [cell.contentView addSubview:image];
	[image release];
    
    
    //so the user can select which work group's events they would like to see
    //Initialize Label with tag 5;
    UITextField *textField = [[UITextField alloc] initWithFrame:TextFrame];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor]; //text color
    textField.font = [UIFont fontWithName:@"Cochin" size:18];   //font size
    
    textField.backgroundColor = [UIColor clearColor]; //background color
    textField.tag = 3;
    textField.textAlignment = UITextAlignmentCenter;
	[cell.contentView addSubview:textField];
	[textField release];
	
    //The button to bring up a table to choose the work group.
    //need to give it a tag too so that user cannot press it when not
    //in the top row.  Tag will be 7
    UIButton *wgButton = [[UIButton alloc] initWithFrame:TextFrame];
    wgButton.backgroundColor = [UIColor clearColor];
    wgButton.tag = 4;
    [wgButton addTarget:self action:@selector(displayWorkGroupTbl:) 
       forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:wgButton];
    [wgButton release];
    
    UISearchBar *thesearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    thesearchBar.barStyle=UIBarStyleDefault;
    thesearchBar.showsCancelButton=NO;
    thesearchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    thesearchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    thesearchBar.tag = 5;
    UISearchDisplayController *sdController = [[UISearchDisplayController alloc] initWithSearchBar:thesearchBar contentsController:self];
    [cell.contentView addSubview:sdController.searchBar];
    [thesearchBar release];
    [sdController release];
    
       
    return cell;
    
}



- (void) displayWorkGroupTbl:(id)sender {
    
    if(!popoverController) {
        WorkGroupTblView *wgTble = [[WorkGroupTblView alloc] init];
        wgTble.theRoot = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:wgTble];
        [wgTble release];
    }
    
   if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"]) {
       [popoverController setPopoverContentSize:CGSizeMake(243, 426)];
       [popoverController presentPopoverFromRect:CGRectMake(self.tableView.frame.size.width/2, 100, 1, 1) 
                                          inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
   } else {
    
    [popoverController setPopoverContentSize:CGSizeMake(243, 426)];
	[popoverController presentPopoverFromRect:CGRectMake(self.tableView.frame.size.width/2, 50, 1, 1) 
                                       inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
   }
    
    

}

- (void) updateWorkGroupSelected:(NSString *)str:(BOOL)fromUpdate {
    
    [popoverController dismissPopoverAnimated:YES];
   
    
    if ([mode isEqualToString:@"Contacts"]) {
        
        UINavigationController *tempNav2 = [appDelegate.splitViewController.viewControllers objectAtIndex:1];
        
        FullContactViewController *contactView =[tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1]; 
        
        contactView.contact.selectSection = 0;
        contactView.contact.selectRow = -1;
        
        
        
        NSError *error;
        
        NSRange separater = [str rangeOfString:@"~+~"];
        NSString *compID = [str substringFromIndex:separater.location+3];
       
        NSString *getContactsSite;
        
        if ([compID isEqualToString:@"0000"]) {
            workGroupStr = @"";
            
            //Get Contacts for Specified Company
            getContactsSite = [NSString stringWithFormat:@"http://%@/GetContacts.php?mUser=%@&mPassword=%@",
                               [serverInfo objectAtIndex:0], 
                               [serverInfo objectAtIndex:3],
                               [serverInfo objectAtIndex:4]];    
            
          
            if (!fromUpdate) {
                [contactView.contact goUpTitlePage: @"": @"Contacts"];
            }
            
        } else {
            
             if (!fromUpdate) {
            
            NSComparisonResult result = [workGroupStr compare: [str substringToIndex:separater.location]];
            
            if (result == NSOrderedAscending) { // stringOne < stringTwo
                workGroupStr = [str substringToIndex:separater.location];
                [contactView.contact goDownTitlePage: workGroupStr: @"Contacts"];
            } else if (result == NSOrderedDescending){ // stringOne > stringTwo
                workGroupStr = [str substringToIndex:separater.location];
                [contactView.contact goUpTitlePage: workGroupStr: @"Contacts"];
            
            } else {
                if (![workGroupStr isEqualToString:[str substringToIndex:separater.location]]) {
                    workGroupStr = [str substringToIndex:separater.location];
                    [contactView.contact goDownTitlePage: workGroupStr: @"Contacts"];

                }
            }
             }
            contactView.contact.isTitle = YES;         
            //Get Contacts for Specified Company
            getContactsSite = [NSString stringWithFormat:@"http://%@/GetCompanyContacts.php?mUser=%@&mPassword=%@&compID=%@",
                                         [serverInfo objectAtIndex:0], 
                                         [serverInfo objectAtIndex:3],
                                         [serverInfo objectAtIndex:4],
                                         compID];    
            
            
            

        }
        
        [workGroupStr retain];
        
        
        NSString *contacts = [NSString stringWithContentsOfURL: 
                              [NSURL URLWithString:
                               getContactsSite]
                                                      encoding:NSASCIIStringEncoding error:&error];
        
        
        
        NSRange lastsquiggle = [contacts rangeOfString:@"~-~" options:NSBackwardsSearch];
        
        NSArray *tempElArray;
        
        if (lastsquiggle.location != NSNotFound) {
            tempElArray = [[contacts substringToIndex:
                              lastsquiggle.location]
                             componentsSeparatedByString:@"~-~"];
        } else {
            tempElArray = [contacts componentsSeparatedByString:@"~-~"];

            
        }
        
        [elementsArray retain];
        
        [indexArray removeAllObjects];
        [indexArray addObject:@"{search}"];
        
        if (([tempElArray count] > 0) && (![[tempElArray objectAtIndex:0] isEqualToString:@""])) {
        
            elementsArray = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[tempElArray count]:[[tempElArray objectAtIndex:0] substringToIndex:1]:tempElArray];
        } else {
            elementsArray = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@" ~+~0000", nil], nil];
        }

        
        [self.tableView reloadData];

        
        
    } else if ([mode isEqualToString:@"Companies"]) {
            NSError *error;
            
            NSRange separater = [str rangeOfString:@"~+~"];
            NSString *catID = [str substringFromIndex:separater.location+3];
            
            NSString *getContactsSite;
            
            if ([catID isEqualToString:@"0000"]) {
                workGroupStr = @"";
                
                //Get Contacts for Specified Company
                getContactsSite = [NSString stringWithFormat:@"http://%@/GetCompanies.php?mUser=%@&mPassword=%@",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4]];    
                
                
                
            } else {
                workGroupStr = [str substringToIndex:separater.location];
                
                //Get Contacts for Specified Company
                getContactsSite = [NSString stringWithFormat:@"http://%@/GetCategoryCompanies.php?mUser=%@&mPassword=%@&catID=%@",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   catID];    
                
                
            }
            
            [workGroupStr retain];
            
            
            
            NSString *contacts = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   getContactsSite]
                                                          encoding:NSASCIIStringEncoding error:&error];
            
            
            
            NSRange lastsquiggle = [contacts rangeOfString:@"~-~" options:NSBackwardsSearch];
            
            NSArray *tempElArray;
            
            if (lastsquiggle.location != NSNotFound) {
                tempElArray = [[contacts substringToIndex:
                                lastsquiggle.location]
                               componentsSeparatedByString:@"~-~"];
            } else {
                tempElArray = [contacts componentsSeparatedByString:@"~-~"];
                
                
            }
            
            [elementsArray retain];
            
            [indexArray removeAllObjects];
            [indexArray addObject:@"{search}"];
            
            if (([tempElArray count] > 0) && (![[tempElArray objectAtIndex:0] isEqualToString:@""])) {
                
                elementsArray = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[tempElArray count]:[[tempElArray objectAtIndex:0] substringToIndex:1]:tempElArray];
            } else {
                elementsArray = [[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@" ~+~0000", nil], nil];
            }
            
            
            [self.tableView reloadData];
        
    } else {
    
    [popoverController dismissPopoverAnimated:YES];
        
        [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers]
                                                        objectAtIndex:0] animated:YES];
        
    //first, change the text in the textbox to the new work group
    workGroupStr = [str substringFromIndex:[str rangeOfString:@"~-~"].location+3];
    workGroupID = [str substringToIndex:[str rangeOfString:@"~-~"].location];
        
          
    [workGroupStr retain];
    [workGroupID retain];
    
    NSError *error;
    
    //get the relevant projects from the new work group that was selected.
        
            
            //Get the projects for the array
            NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetPMIDProjects.php?mUser=%@&mPassword=%@&PMID=%@",
                                         [serverInfo objectAtIndex:0], 
                                         [serverInfo objectAtIndex:3],
                                         [serverInfo objectAtIndex:4],
                                         workGroupID];    
            
            
            
            NSString *projects = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   getProjectsSite]
                                                          encoding:NSASCIIStringEncoding error:&error];
            
           
            
            NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
            
            
            allEventsProjects = [[projects substringToIndex:
                                  lastsquiggle.location]
                                 componentsSeparatedByString:@"~-~"];
    
        [allEventsProjects retain];
   
    
    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
   
    
    NSString *eventsString;
    NSString *titleDetail;
    if ([eventMode isEqualToString:@"due"]) {
        eventsString = [self getDueEvents:[format stringFromDate:[NSDate date]]:currentPriority+1];
        titleDetail = @"Due for Review";
    } else if ([eventMode isEqualToString:@"active"]) {
        eventsString = [self getActiveEvents:currentPriority+1];
        titleDetail = @"Active Events";
    } else {
        //if we are in recent events, find the day that qualifies it as recent
        NSDate *now = [NSDate date];
        int daysToAdd = -1;
        NSDate *afterDate = [now addTimeInterval:60*60*24*daysToAdd];
        NSDate *finalAfterDate;
        
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:afterDate];
        
        //take out the weekends - get the last 48 hours from the week
        
        // 1 = Sunday, 2 = Monday, etc.
        if (([comp weekday]==1)||([comp weekday]==7)) {
            finalAfterDate = [afterDate addTimeInterval:-60*60*24*3];
            
        } else {
            finalAfterDate = afterDate;
        }
        
        
        NSString *afterDateStr = [format stringFromDate:finalAfterDate];
        
        NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&Triage=%d&DateAfter=%@&UserID=%@&WorkGroupID=%@",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   currentPriority+1,
                                   afterDateStr,userIDNum, workGroupID];    
        
        eventsString = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:
                         getEventsSite] encoding:NSASCIIStringEncoding error:&error];
        
        titleDetail = @"Recent Events";
    }
    
    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
        elementsArray = [[eventsString substringToIndex:
                          eventsString.length-3]
                         componentsSeparatedByString:@"~-~"];
    } else {
        elementsArray = [eventsString componentsSeparatedByString:@"~-~"];
    }
    
        
              
    if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        self.title = [NSString stringWithFormat:@"%@ (0)",
                      titleDetail];
    } else {
        self.title = [NSString stringWithFormat:@"%@ (%d)",
                      titleDetail,
                      [elementsArray count]];
        
    }
    }
    [elementsArray retain];
    [self.tableView reloadData];
}

- (UITableViewCell *) getTitleCellContent:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
    CGRect SegFrame = CGRectMake(-3.0f, 41, 326.0f, 46.0f);
    CGRect Label1Frame = CGRectMake(0, -7, 322, 53);
    CGRect Label2Frame = CGRectMake(10, 10, 290, 30);
    CGRect ImageFrame = CGRectMake(0, -3, 321, 44);
    CGRect openBlueFrame = CGRectMake(0, 42.5f, 160, 42);
    CGRect closedBlueFrame = CGRectMake(161, 42.5f, 160, 42);
    CGRect segPictureFrame = CGRectMake(0, 41, 320, 44);
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
    
    UILabel *lblTemp;
    UIImageView *image;
    
    //Initialize Label with tag 4;
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] 
											initWithItems:
											[NSArray arrayWithObjects:
											 @"Open", @"Closed", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tag = 2;
	segmentedControl.alpha = 1;
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.frame = SegFrame;
    [self changeOpenUISegmentFont:segmentedControl];
	[cell.contentView addSubview:segmentedControl];
    
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"OpenSelectedRoot.png"]];
    image.frame = segPictureFrame;
    image.tag = 7;
    [cell.contentView addSubview:image];
    [image release];
    
    
    //bluecoverbuttonleft:
    UIButton *leftCoverBtn = [[UIButton alloc] initWithFrame:openBlueFrame];
    leftCoverBtn.backgroundColor = [UIColor clearColor];
    [leftCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [leftCoverBtn addTarget:self action:@selector(openSegment:) forControlEvents:UIControlEventTouchUpInside];
    leftCoverBtn.clipsToBounds = YES;
    leftCoverBtn.alpha = .58;
    leftCoverBtn.tag = 5;
    [cell.contentView addSubview:leftCoverBtn];
    [leftCoverBtn release];
    
    //bluecoverbuttonright:
    UIButton *rightCoverBtn = [[UIButton alloc] initWithFrame:closedBlueFrame];
    rightCoverBtn.backgroundColor = [UIColor clearColor];
    [rightCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [rightCoverBtn addTarget:self action:@selector(closeSegment:) forControlEvents:UIControlEventTouchUpInside];
    rightCoverBtn.clipsToBounds=YES;
    rightCoverBtn.alpha = .58;
    rightCoverBtn.tag = 6;
    [cell.contentView addSubview:rightCoverBtn];
    [rightCoverBtn release];

    
    
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleBar"]];
    image.frame = ImageFrame;
	image.tag = 3;
    [cell.contentView addSubview:image];
	[image release];
    
    //Initialize Label with tag 5;
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.shadowColor = [UIColor whiteColor];
    lblTemp.shadowOffset = CGSizeMake(0, 1);
	lblTemp.tag = 1;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:22];
    lblTemp.minimumFontSize = 12;
    lblTemp.textAlignment = UITextAlignmentCenter;
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];

    //Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 4;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:20];
	lblTemp.textColor = [UIColor whiteColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
    
    return cell;
}


- (IBAction) openSegment:(id)sender {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageView;
    if (depth == 3) {
        imageView = (UIImageView *)[cell viewWithTag:9];
    } else {
        imageView = (UIImageView *)[cell viewWithTag:7];
    }
    [imageView setImage:[UIImage imageNamed:@"OpenSelectedRoot.png"]];
    
    currentOpenCloseSeg.selectedSegmentIndex = 0;
}

- (IBAction) closeSegment:(id)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIImageView *imageView;
    if (depth == 3) {
        imageView = (UIImageView *)[cell viewWithTag:9];
    } else {
        imageView = (UIImageView *)[cell viewWithTag:7];
    }
    
    [imageView setImage:[UIImage imageNamed:@"ClosedSelectedRoot.png"]];
    
    currentOpenCloseSeg.selectedSegmentIndex = 1;
}

//Makeing the segment image 
//have the correct one pressed

- (IBAction) pressOneSeg:(id)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:8];
    
    [imageView setImage:[UIImage imageNamed:@"OneSelectedRoot.png"]];
    currentPrioritySeg.selectedSegmentIndex = 0;
}

- (IBAction) pressTwoSeg:(id)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:8];
    
    [imageView setImage:[UIImage imageNamed:@"TwoSelectedRoot.png"]];
    currentPrioritySeg.selectedSegmentIndex = 1;
}

- (IBAction) pressThreeSeg:(id)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:8];
    
    [imageView setImage:[UIImage imageNamed:@"ThreeSelectedRoot.png"]];
    currentPrioritySeg.selectedSegmentIndex = 2;
}


//for custom cells for the Event Lists
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(10, 5, 270, 15);
	CGRect Label2Frame = CGRectMake(10, 8, 270, 20);
	CGRect Label3Frame = CGRectMake(20, 15, 270, 60);
	CGRect SegFrame = CGRectMake(-3.0f, 41, 326.0f, 47.0f);
    CGRect Label5Frame = CGRectMake(0, -7, 322, 53);
    CGRect ImageFrame = CGRectMake(0, -3, 321, 44);
    CGRect openBlueFrame = CGRectMake(0, 42.5f, 160, 42);
    CGRect closedBlueFrame = CGRectMake(161, 42.5f, 160, 42);
    CGRect segPictureFrame = CGRectMake(0, 41, 320, 44);
       
    
    UILabel *lblTemp;
    UIImageView *image;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:18];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 2;
	//lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	//lblTemp.numberOfLines = 3;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:16];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
	//Initialize seg with tag 3.
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 3;
	lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	lblTemp.numberOfLines = 2;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:14];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    //Initialize Label with tag 4;
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] 
											initWithItems:
											[NSArray arrayWithObjects:
											 @"Open", @"Closed", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tag = 4;
	segmentedControl.alpha = 0;
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.frame = SegFrame;
    [self changeOpenUISegmentFont:segmentedControl];
	[cell.contentView addSubview:segmentedControl];
    
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleBar"]];
    image.frame = ImageFrame;
	image.tag = 6;
    [cell.contentView addSubview:image];
	[image release];
    
    //Initialize Label with tag 5;
	lblTemp = [[UILabel alloc] initWithFrame:Label5Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.shadowColor = [UIColor whiteColor];
    
    lblTemp.shadowOffset = CGSizeMake(0, 1);
    //[UIColor colorWithRed:.885 green:.885 blue:.885 alpha:1];
	lblTemp.tag = 5;
    lblTemp.font = [UIFont fontWithName:@"Cochin" size:22];
    lblTemp.minimumFontSize = 12;
    lblTemp.textAlignment = UITextAlignmentCenter;
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"OpenSelectedRoot.png"]];
    image.frame = segPictureFrame;
    image.tag = 9;
    [cell.contentView addSubview:image];
    [image release];
    
    
    //bluecoverbuttonleft:
    UIButton *leftCoverBtn = [[UIButton alloc] initWithFrame:openBlueFrame];
    leftCoverBtn.backgroundColor = [UIColor clearColor];
    [leftCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [leftCoverBtn addTarget:self action:@selector(openSegment:) forControlEvents:UIControlEventTouchUpInside];
    leftCoverBtn.clipsToBounds = YES;
    leftCoverBtn.alpha = .58;
    leftCoverBtn.tag = 7;
    [cell.contentView addSubview:leftCoverBtn];
    [leftCoverBtn release];
    
    //bluecoverbuttonright:
    UIButton *rightCoverBtn = [[UIButton alloc] initWithFrame:closedBlueFrame];
    rightCoverBtn.backgroundColor = [UIColor clearColor];
    [rightCoverBtn setImage:[UIImage imageNamed:@"ButtonCover.png"] forState:UIControlStateHighlighted];
    [rightCoverBtn addTarget:self action:@selector(closeSegment:) forControlEvents:UIControlEventTouchUpInside];
    rightCoverBtn.clipsToBounds=YES;
    rightCoverBtn.alpha = .58;
    rightCoverBtn.tag = 8;
    [cell.contentView addSubview:rightCoverBtn];
    [rightCoverBtn release];

  
		
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
/*
	if (indexPath.row % 2)
	{
        [cell setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:1 alpha:1]];
	}
	else [cell setBackgroundColor:[UIColor clearColor]];
 */
	
	if (depth == 0) {
		cell.textLabel.font = [UIFont fontWithName:@"Cochin" size:22];
		if (indexPath.row == 0) {
			[cell setBackgroundColor:[UIColor colorWithRed:.75 green:.1 blue:.1 alpha:1]];
		} else if (indexPath.row == 1) {
			[cell setBackgroundColor:[UIColor colorWithRed:.2 green:.3 blue:.6 alpha:1]];
		}else {
			[cell setBackgroundColor:[UIColor colorWithRed:.1 green:.5 blue:.1 alpha:1]];
		}
		
	} else if (depth == 1) {
		if ([mode isEqualToString:@"Events"]) {
            cell.textLabel.font = [UIFont fontWithName:@"Cochin" size:22];
			[cell setBackgroundColor:[UIColor colorWithRed:.97 green:.47 blue:.52 alpha:1]];
		} else if ([mode isEqualToString:@"Projects"]) {
            if (indexPath.row==0) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                
                if (([elementsArray count] > 0)&&(![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
			[cell setBackgroundColor:[UIColor colorWithRed:.34 green:.48 blue:.75 alpha:1]];
                } else {
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
            }
		} else {
            cell.textLabel.font = [UIFont fontWithName:@"Cochin" size:22];
			[cell setBackgroundColor:[UIColor colorWithRed:.53 green:.73 blue:.53 alpha:1]];
		}
	} else if (depth == 2) {
		if ([mode isEqualToString:@"Events"]) {
            if (([elementsArray count] > 0)&&(indexPath.row==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                [cell setBackgroundColor:[UIColor colorWithRed:1 green:.8 blue:.85 alpha:1]];
            }
		} else if ([mode isEqualToString:@"Projects"]) {
            if (indexPath.row==0) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                if (([elementsArray count] > 0)&&(![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                    
                    [cell setBackgroundColor:[UIColor colorWithRed:.48 green:.63 blue:.88 alpha:1]];
                } else {
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
            }
		} else {
            UILabel *tempLbl = (UILabel *)[cell viewWithTag:1];
            tempLbl.font = [UIFont fontWithName:@"Cochin" size:17];
           
            
            if (([elementsArray count] > 0) && (![[[elementsArray objectAtIndex:0] objectAtIndex:0] isEqualToString:@" ~+~0000"])) {
                [cell setBackgroundColor:[UIColor colorWithRed:.73 green:.88 blue:.73 alpha:1]];
            }
		}
	} else {
		if ([mode isEqualToString:@"Events"]) {
			[cell setBackgroundColor:[UIColor colorWithRed:.75 green:.1 blue:.1 alpha:1]];
		} else if ([mode isEqualToString:@"Projects"]) {
			if (indexPath.row==0) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
            
                if (indexPath.row > [elementsArray count]) {
                    [cell setBackgroundColor: [UIColor colorWithRed:.93 green:.93 blue:1 alpha:1]];
                }else if (([elementsArray count] > 0)&&([elementsArray count] > 0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                    [cell setBackgroundColor:[UIColor colorWithRed:.7 green:.8 blue:.95 alpha:1]];
                } else {
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
            }
            
        } else {
           
			[cell setBackgroundColor:[UIColor colorWithRed:.1 green:.5 blue:.1 alpha:1]];
		}
	}

}





////////////////////////////
- (void) showLoginAlert {
	
	//alert will popup to ask for username and password
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication" 
													message:@""
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"Submit", nil];	
	
	[alert addTextFieldWithValue: @"" label: @"Email Address"];
	[alert addTextFieldWithValue: @"" label: @"Password"];
	
	
	usernameTxt = [alert textFieldAtIndex:0];
	//usernameTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
	usernameTxt.keyboardType = UIKeyboardTypeAlphabet;
	usernameTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
	usernameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
	
	passwordTxt = [alert textFieldAtIndex:1];
    [passwordTxt setSecureTextEntry:YES];
	//passwordTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordTxt.keyboardType = UIKeyboardTypeAlphabet;
	passwordTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
	passwordTxt.autocorrectionType = UITextAutocorrectionTypeNo;
	
	//alert.transform = CGAffineTransformMakeTranslation(0, 100);
    
	[alert show];
	[alert release];
	
	
	
}

//to update the table with the 
//last query it made to find
//updated information
- (void)updateTableWithLU {
  
    if (!workGroupID) {
        [self updateWorkGroupSelected:[NSString stringWithFormat:@"something~+~0000"]:YES];
   
    } else {
    
        [self updateWorkGroupSelected:[NSString stringWithFormat:@"%@~+~%@", workGroupStr, workGroupID]:YES];
    }
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//****TODO****
    //ADD BEGIN DATES TO MOST OF THE VALUES ADDED TO DATABASE THAT ARE TODAY
    
    
     NSError *error;
    
    if ([actionSheet.title rangeOfString:@"Invalid Work Group"].location != NSNotFound) {
    
    } else if ([actionSheet.title rangeOfString:@"New"].location != NSNotFound) {
		
		NSMutableArray *temp;
		
		if (buttonIndex==1) {
			
            if (depth==1) {
                
                //taking away spaces so will go in the db - replaced with %20-like webpages do
                int nameLength = [newEventTxt.text length];
                NSRange nameRange = NSMakeRange(0,nameLength);
                NSString *fullProjectName = [newEventTxt.text stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:nameRange];
                            
                //take away spaces in work group name
                int workgroupLength = [PMIdTxt.text length];
                NSRange workgroupRange = NSMakeRange(0, workgroupLength);
                NSString *fullWorkGroupName = [PMIdTxt.text stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:workgroupRange];
                
                
                               
                NSString *checkWGValidSite = [NSString stringWithFormat:@"http://%@/GetWGPMID.php?mUser=%@&mPassword=%@&PMId=%@",
                                              [serverInfo objectAtIndex:0],
                                              [serverInfo objectAtIndex:3],
                                              [serverInfo objectAtIndex:4],
                                              fullWorkGroupName];
                
                
                NSString *wgPMID = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     checkWGValidSite]
                             encoding:NSASCIIStringEncoding error:&error];
                
                NSLog(@"pmid: %@", wgPMID);
                

                if (wgPMID.length > 1) {
                
                    NSString *addNewProject = [NSString stringWithFormat:@"http://%@/CreateNewProject.php?mUser=%@&mPassword=%@&ProjectName=%@&SortNumber=100&PMId=%@&IsClosed=0",
                                    [serverInfo objectAtIndex:0],
                                    [serverInfo objectAtIndex:3],
                                    [serverInfo objectAtIndex:4],
                                    fullProjectName, wgPMID];
                
                
                    NSString *newProjectID = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         addNewProject]
                                                                encoding:NSASCIIStringEncoding error:&error];
               

                    temp = [NSMutableArray arrayWithArray:elementsArray];
                    [temp addObject:[NSString stringWithFormat:@"%@~+~%@", newEventTxt.text, newProjectID]];
                
                    [temp retain];
                    elementsArray = temp;
                    
                    NSMutableArray* paths = [[NSMutableArray alloc] init];
                    [paths addObject:[NSIndexPath indexPathForRow:[elementsArray count] inSection:0]];
                
                    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
                
                    if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                        titleStr = [NSString stringWithFormat:@"%@(0)",
                                [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
                    } else {
                        titleStr = [NSString stringWithFormat:@"%@(%d)",
                                [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                                [elementsArray count]];
                    
                    }
                    UITableViewCell *cell = [self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    UILabel *lblTemp1;
                    lblTemp1 = (UILabel *)[cell viewWithTag:1];
                    lblTemp1.text = titleStr;
                    [lblTemp1 setText:titleStr];
                
                } else { 
                    //If the work group does not exist, alert the user.
                    UIAlertView *alert;
                    
                    alert = [[UIAlertView alloc] initWithTitle:@"Invalid Work Group" 
                                                       message:@"The Work Group Name you have entered is invalid.  The New Project could not be created."
                                                      delegate:self 
                                             cancelButtonTitle:@"Okay" 
                                             otherButtonTitles:nil];	
                    [alert show];
                    [alert release];
                    
                }
            } else if (depth==2) {
                
               //taking away spaces so will go in the db - replaced with %20-like webpages do
                int nameLength = [newEventTxt.text length];
                NSRange nameRange = NSMakeRange(0,nameLength);
                NSString *fullIssueName = [newEventTxt.text stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:nameRange];
                
                NSString *addNewIssue = [NSString stringWithFormat:@"http://%@/CreateNewIssue.php?mUser=%@&mPassword=%@&ProjectIssueName=%@&SortNumber=100&ProjectID=%@&IssueComplete=0",
                                           [serverInfo objectAtIndex:0],
                                           [serverInfo objectAtIndex:3],
                                           [serverInfo objectAtIndex:4],
                                           fullIssueName, projectID];
                
                
                NSString *newIssueID = [NSString stringWithContentsOfURL: 
                                          [NSURL URLWithString:
                                           addNewIssue]
                                          encoding:NSASCIIStringEncoding error:&error];
                
                
                temp = [NSMutableArray arrayWithArray:elementsArray];
                [temp addObject:[NSString stringWithFormat:@"%@~+~%@", newEventTxt.text, newIssueID]];
                
                [temp retain];
                elementsArray = temp;
                
                NSMutableArray* paths = [[NSMutableArray alloc] init];
                [paths addObject:[NSIndexPath indexPathForRow:[elementsArray count] inSection:0]];
                
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
                
                if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                    titleStr = [NSString stringWithFormat:@"%@(0)",
                                [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
                } else {
                    titleStr = [NSString stringWithFormat:@"%@(%d)",
                                [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                                [elementsArray count]];
                    
                }
                UITableViewCell *cell = [self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                UILabel *lblTemp1;
                lblTemp1 = (UILabel *)[cell viewWithTag:1];
                lblTemp1.text = titleStr;
                [lblTemp1 setText:titleStr];

                
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"YYYY-MM-dd"];
                NSString *todayStr =  [format stringFromDate:[NSDate date]];
                [format setDateFormat:@"MM/dd/YYY"];
                NSString *todayStr1 = [format stringFromDate:[NSDate date]];
                NSString *todayStr2 = [format stringFromDate:[NSDate date]];
                [format setDateFormat:@"YYYY-MM-dd"];
               
                
                //**********TODO************
                //make date today and followup day based on triage=2, and change date today and event description say something from today!
                
                //Get Followupdate
                NSString *triageInfoSite = [NSString stringWithFormat:@"http://%@/GetTriageInfo.php?mUser=%@&mPassword=%@&Triage=2",
                                         [serverInfo objectAtIndex:0],
                                         [serverInfo objectAtIndex:3],
                                         [serverInfo objectAtIndex:4]];
             
                //daysFromToday~+~allowWeekends(0 or 1)
                NSString *triageInfo = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         triageInfoSite]
                                     encoding:NSASCIIStringEncoding error:&error];
               
                NSArray *triageArray = [triageInfo componentsSeparatedByString:@"~+~"];
                
                
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
                
                [format setDateFormat:@"YYYY-MM-dd"];
                NSString *followupDateStr = [format stringFromDate:finalFollowupDate];
                
           
                
                //taking away spaces so will go in the db - replaced with %20-like webpages do
                int nameLength = [newEventTxt.text length];
                NSRange nameRange = NSMakeRange(0,nameLength);
                NSString *fullEventName = [newEventTxt.text stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:nameRange];
                
                NSString *thedesc = [NSString stringWithFormat: @"%@ - Add Event Details Here", todayStr1];
                
               
                //taking away spaces so will go in the db - replaced with %20-like webpages do
                int descLength = 35;
                NSRange descRange = NSMakeRange(0,descLength);
                NSString *fulldescName = [thedesc stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:descRange];
                
                
                NSString *addNewEvent = [NSString stringWithFormat:@"http://%@/CreateNewEvent.php?mUser=%@&mPassword=%@&EventName=%@&ProjectIssueID=%@&EventComplete=0&TriageID=2&EventFollowupDate=%@&EventDescription=%@",
                                         [serverInfo objectAtIndex:0],
                                         [serverInfo objectAtIndex:3],
                                         [serverInfo objectAtIndex:4],
                                         fullEventName, 
                                         issueID, followupDateStr,fulldescName];
                
             
                
                NSString *newEventID = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         addNewEvent]
                                                                encoding:NSASCIIStringEncoding error:&error];

                
                
                
            
            //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID
            //eventFollowupDate~+~LastUpdate~+~contactNameUserName~+~followupName~+~FollowupID~+~Hyperlink01~+~
            //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
				if ([[elementsArray objectAtIndex:0] isEqualToString:@""]) {
					temp = [NSMutableArray arrayWithObjects:
                            [NSString stringWithFormat: @"%@~+~%@~+~%@~+~%@~+~ContactID~+~2~+~%@ ~+~%@~+~Press to Assign Contact~+~Press to Assign~+~FollowupID~+~~+~~+~~+~~+~~+~~+~", newEventTxt.text,newEventID,thedesc,todayStr,followupDateStr, todayStr], nil];
                    
                    
				} else {
					temp = [NSMutableArray arrayWithArray:elementsArray];
					[temp insertObject:[NSString stringWithFormat: @"%@~+~%@~+~%@~+~%@~+~ContactID~+~2~+~%@~+~%@~+~Press to Assign Contact~+~Press to Assign~+~FollowupID~+~~+~~+~~+~~+~~+~~+~", newEventTxt.text,newEventID,thedesc,todayStr,followupDateStr, todayStr] atIndex:0];
				}
				
               
                
                [temp retain];
                elementsArray = temp;
                
                
                if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                    titleStr = [NSString stringWithFormat:@"%@(0)",
                                [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
                } else {
                    titleStr = [NSString stringWithFormat:@"%@(%d)",
                                [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                                [elementsArray count]];
                }
                [titleStr retain];
                
                [self.tableView reloadData];
                newEvent = YES;
               
                [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                 [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
	
		}
	
	} else  if (buttonIndex==1) {
		//send in username and password collect server/user information
		
		NSString *loginSite = [NSString stringWithFormat:@"http://173.203.89.60/UserLogin.php?UserName=%@&UserPassword=%@",
							   usernameTxt.text, passwordTxt.text];
	
		
		NSError *error;
		NSString *serverNum = [NSString stringWithContentsOfURL: 
							  [NSURL URLWithString:
							   loginSite]
						encoding:NSASCIIStringEncoding error:&error];

		NSLog(@"serverNum: %@", serverNum);
        
		if (serverNum.length<1) {
			
			[self performSelector:@selector(showInvalidAlert) withObject:nil afterDelay:0.1];
			
			
		} else {
			
			LoginName = usernameTxt.text;
			[LoginName retain];
			UserPassword = passwordTxt.text;
			[UserPassword retain];
			
			NSString *getServerSite = [NSString stringWithFormat:@"http://173.203.89.60/GetServerInfo.php?ServerId=%@",
				serverNum];
            
            NSLog(@"getServerSite: http://173.203.89.60/GetServerInfo.php?ServerId=%@",
                  serverNum);
			
			NSError *error;
			
			//$ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
			serverInfoStr = [NSString stringWithContentsOfURL: 
						  [NSURL URLWithString:
						   getServerSite]
												  encoding:NSASCIIStringEncoding error:&error];
			
            NSLog(@"serverInfoStr: %@", serverInfoStr);
            
			[serverInfoStr retain];
			
			serverInfo = [[serverInfoStr componentsSeparatedByString:@"~-~"] retain];
			
			[self getUserData];
			
		}
		
	} else {
		//Close application
		exit(1);
	}
	
	
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (currentSeg == 0) {
        return @"Close";
    } else {
        return @"Open";
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((depth == 0) || (![mode isEqualToString:@"Projects"])){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    
}


//called when user swipes across row
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // UITableViewCell *cell = [self.view cellForRowAtIndexPath: indexPath];
    
 
}



//This is where you tell it what you want to have happen when push close button
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    NSMutableArray *tempMute=[NSMutableArray arrayWithArray:elementsArray];
    
    
    //need to get this in order to provide the project that was chosen so you can update isComplete
    NSArray *deletedInfo = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
    
    
    
    [tempMute removeObjectAtIndex:indexPath.row-1];
    
    elementsArray = tempMute;
    
    [elementsArray retain];
    
       if ([mode isEqualToString:@"Projects"]) {
        if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
            titleStr = [NSString stringWithFormat:@"%@(0)",
                        [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
        } else {
            titleStr = [NSString stringWithFormat:@"%@(%d)",
                        [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                        [elementsArray count]];
            
        }
    } else {
       
        
        NSString *titlebit;
        if ([eventMode isEqualToString:@"due"]) {
            titlebit = @"Due for Review";
        } else if ([eventMode isEqualToString:@"recent"]) {
            titlebit = @"Recent Events";
        } else if ([eventMode isEqualToString:@"active"]) {
            titlebit = @"Active Events";
        }
        
        if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
            self.title = [NSString stringWithFormat:@"%@(0)", titlebit];
        } else {
            self.title = [NSString stringWithFormat:@"%@(%d)",
                        titlebit,
                        [elementsArray count]];
            
        }
    }
    
    
       
    [titleStr retain];
    
    UITableViewCell *cell = [self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *lblTemp1;
    
 
    
    NSArray *temp = [NSArray arrayWithObject:indexPath];
   
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortraitUpsideDown) {
       
        [self.view deleteRowsAtIndexPaths:temp withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Open or close a project
    NSString *UpdateIsComplete;
    
    if ((depth==1)&& [mode isEqualToString:@"Projects"]) {
    
        lblTemp1 = (UILabel *)[cell viewWithTag:1];

        if (currentSeg == 0) {
    
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateProjectComplete.php?mUser=%@&mPassword=%@&ProjectID=%@&ProjectComplete=%d",
                        [serverInfo objectAtIndex:0],
                        [serverInfo objectAtIndex:3],
                        [serverInfo objectAtIndex:4],
                        [deletedInfo objectAtIndex:1], 1];
        } else {
            
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateProjectComplete.php?mUser=%@&mPassword=%@&ProjectID=%@&ProjectComplete=%d",
                                [serverInfo objectAtIndex:0],
                                [serverInfo objectAtIndex:3],
                                [serverInfo objectAtIndex:4],
                                [deletedInfo objectAtIndex:1], 0];
        }
    
    }  else if ((depth == 2) && [mode isEqualToString:@"Projects"]) {
        
        lblTemp1 = (UILabel *)[cell viewWithTag:1];
        
        if (currentSeg == 0) {
            
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateIssueComplete.php?mUser=%@&mPassword=%@&IssueID=%@&IssueComplete=%d",
                                [serverInfo objectAtIndex:0],
                                [serverInfo objectAtIndex:3],
                                [serverInfo objectAtIndex:4],
                                [deletedInfo objectAtIndex:1], 1];
            
        } else {
            
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateIssueComplete.php?mUser=%@&mPassword=%@&IssueID=%@&IssueComplete=%d",
                                [serverInfo objectAtIndex:0],
                                [serverInfo objectAtIndex:3],
                                [serverInfo objectAtIndex:4],
                                [deletedInfo objectAtIndex:1], 0];
        }
        
    } else if (((depth == 3) && [mode isEqualToString:@"Projects"]) || ((depth == 2) && [mode isEqualToString:@"Events"])) {
        
        
        lblTemp1 = (UILabel *)[cell viewWithTag:5];
        
        if (depth == 2) {
            
            if (eventController.currentSwitch!=0) {
            
            //the array for events is one displaced from the projects array (stupid...)
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateEventComplete.php?mUser=%@&mPassword=%@&EventID=%@&EventComplete=%d",
                                [serverInfo objectAtIndex:0],
                                [serverInfo objectAtIndex:3],
                                [serverInfo objectAtIndex:4],
                                [deletedInfo objectAtIndex:2], 1];
              
            }
            
        } else if (currentSeg == 0) {
            
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateEventComplete.php?mUser=%@&mPassword=%@&EventID=%@&EventComplete=%d",
                                [serverInfo objectAtIndex:0],
                                [serverInfo objectAtIndex:3],
                                [serverInfo objectAtIndex:4],
                                [deletedInfo objectAtIndex:1], 1];
          

        } else {
            
            UpdateIsComplete = [NSString stringWithFormat:@"http://%@/UpdateEventComplete.php?mUser=%@&mPassword=%@&EventID=%@&EventComplete=%d",
                                [serverInfo objectAtIndex:0],
                                [serverInfo objectAtIndex:3],
                                [serverInfo objectAtIndex:4],
                                [deletedInfo objectAtIndex:1], 0];
        
        }
        
        
        
    }
   
    
    if (![mode isEqualToString:@"Events"]) {
    
         lblTemp1.text = titleStr;
        
    NSError *error;
    
    NSString *isComplete = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             UpdateIsComplete]
                              encoding:NSASCIIStringEncoding error:&error];
        

    if (![eventController isEqual:nil]) {
     
        if (currentSeg==0) {
            eventController.currentSwitch = 1;
           
        
        } else {
            eventController.currentSwitch = 0;
           
        }
    }
    }
  
}




- (void) showInvalidAlert {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Information" 
													message:@""
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"Submit", nil];	
	
	[alert addTextFieldWithValue: @"" label: @"Email Address"];
	[alert addTextFieldWithValue: @"" label: @"Password"];
	
	
	usernameTxt = [alert textFieldAtIndex:0];
	//usernameTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
	usernameTxt.keyboardType = UIKeyboardTypeAlphabet;
	usernameTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
	usernameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
	
	passwordTxt = [alert textFieldAtIndex:1];
	//passwordTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordTxt setSecureTextEntry:YES];
	passwordTxt.keyboardType = UIKeyboardTypeAlphabet;
	passwordTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
	passwordTxt.autocorrectionType = UITextAutocorrectionTypeNo;
	
	
	[alert show];
	[alert release];
}


//to get projects just from the selected work group

- (NSString *)getFinalSelectedProjects: (NSArray *)allProj: (NSString *)str: (int)x {
    
    if ((x==[allProj count]) || [[allProj objectAtIndex:0] isEqualToString:@""]) {
        return str;
    } else {
        
        NSArray *temp = [[allProj objectAtIndex:x] componentsSeparatedByString:@"~+~"];
        if ([[temp objectAtIndex:2] isEqualToString:workGroupID]) {
            if (str.length > 2) {
                return [self getFinalSelectedProjects:allProj:
                        [NSString stringWithFormat:@"%@~-~%@~+~%@", 
                         str, [temp objectAtIndex:0],[temp objectAtIndex:1]]:x+1];
            } else {
                return [self getFinalSelectedProjects:allProj:
                        [NSString stringWithFormat:@"%@~+~%@", 
                         [temp objectAtIndex:0],[temp objectAtIndex:1]]:x+1];
            }
        } else {
            return [self getFinalSelectedProjects:allProj :str :x+1];
        }
    }
}








////////////////////////////


- (NSString *) getFinalProjects: (NSArray *)allProj: (NSString *)str: (NSArray *) wgArray: (int)x{
    
    BOOL found = NO;
    
	if ((x==[allProj count]) || [[allProj objectAtIndex:0] isEqualToString:@""]) {
		return str;
	} else {
		NSArray *temp = [[allProj objectAtIndex:x] componentsSeparatedByString:@"~+~"];
		
        
        
        for (int i=0; i< [wgArray count]; ++i) {
            NSArray *wgTemp = [[wgArray objectAtIndex:i] componentsSeparatedByString:@"~-~"];
            
            if ([[wgTemp objectAtIndex:0] isEqualToString:[temp objectAtIndex:2]]) {
                
                
                if (str.length > 2) {
                    found = YES;
                    return [self getFinalProjects:allProj
                                                 :[NSString stringWithFormat:@"%@~-~%@~+~%@", 
                                                   str, [temp objectAtIndex:0], [temp objectAtIndex:1]]
                                                 :workGroupsArray
                                                 :x+1];
                } else {
                    found = YES;
                    return [self getFinalProjects:allProj
                                                 :[NSString stringWithFormat:@"%@~+~%@", 
                                                   [temp objectAtIndex:0], [temp objectAtIndex:1]]
                                                 :workGroupsArray
                                                 :x+1];
                }
				
            }
            
        }
    
        
        if (!found) {
            
			return [self getFinalProjects:allProj :str :wgArray :x+1];
		}
    }
}


- (void) prepareNextView: (RootViewController *)rv {
	rv.userIDNum = userIDNum;
	rv.LoginName = LoginName;
	rv.UserPassword = UserPassword;
	rv.UserName = UserName;
	rv.UserInitials = UserInitials;
	rv.isManager = isManager;
	rv.isFollowup = isFollowup;
	rv.serverInfo = serverInfo;
	rv.detailViewController = detailViewController;
	
}


- (void) leftSwipe:(NSIndexPath *) index:(BOOL)fromDet {

    if (fromDet) {
    
        //select the first one
        swipeCount = 0;
        fromSwipe = YES;
        isRightSwipe = NO;
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    } else if (index.row+swipeCount+1 <= [elementsArray count]) {
       
    
            //else select the one after it
             swipeCount = swipeCount+1;
            fromSwipe = YES;
            isRightSwipe = NO;
            [self tableView:self.tableView didSelectRowAtIndexPath:index];
        
		
    } else if ([eventMode isEqualToString:@"due"]) {
        
        if (![[[detailViewController.navigationController.viewControllers objectAtIndex:
                [detailViewController.navigationController.viewControllers count]-1] title] isEqualToString: @""]) {
            EventDetail_Proj *temp = [detailViewController.navigationController.viewControllers objectAtIndex:
                                      [detailViewController.navigationController.viewControllers count]-1];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM d, yyyy"];
            
            //also need to delete the entry from the table and eliminate the backbutton.  
            
         
            
            NSDate *dueDate = [format dateFromString:temp.dateLbl.text];
            if ((![[dueDate earlierDate:[NSDate date]] isEqualToDate:dueDate]) ||
                (temp.currentSwitch==1)) {
                int test = [self getElementsIndexOfStringContaining:temp.eventIDStr:2];
                if (test < 999) {
                    [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
                }
            }
            DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
            detail.enableDueLSwipe = NO;
            detail.enableDueRSwipe = YES;
            detail.theRoot = self;
            swipeCount = swipeCount-1;
            detail.navigationItem.hidesBackButton = YES;
            [detailViewController.navigationController pushViewController:detail animated:YES];
            
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
    }
}



- (void) rightSwipe:(NSIndexPath *) index:(BOOL)fromDet {
	
    
    if (fromDet) {
      
        //select the last one
        swipeCount = 0;
        fromSwipe = YES;
        isRightSwipe = YES;
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[elementsArray count] inSection:0]];

    } else if (index.row+swipeCount > 1 ) {
        swipeCount = swipeCount-1;
        fromSwipe = YES;
		isRightSwipe = YES;
		[self tableView:self.tableView didSelectRowAtIndexPath:index];
    } else if ([eventMode isEqualToString:@"due"]) {
        
        if (![[[detailViewController.navigationController.viewControllers objectAtIndex:
                [detailViewController.navigationController.viewControllers count]-1] title] isEqualToString: @""]) {
            EventDetail_Proj *temp = [detailViewController.navigationController.viewControllers objectAtIndex:
                                      [detailViewController.navigationController.viewControllers count]-1];
            
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM d, yyyy"];
            
            //also need to delete the entry from the table and eliminate the backbutton.  Enable rightswipe so can go 
            //backwards up the list.
            NSDate *dueDate = [format dateFromString:temp.dateLbl.text];
            if ((![[dueDate earlierDate:[NSDate date]] isEqualToDate:dueDate]) ||
                (temp.currentSwitch==1)) {
                int test = [self getElementsIndexOfStringContaining:temp.eventIDStr:2];
                if (test < 999) {
                    [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
                }
            }
            [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers] objectAtIndex:0] animated:YES];
            detailViewController.enableDueRSwipe = NO;
            detailViewController.enableDueLSwipe = YES;
            detailViewController.title = @"";
            swipeCount = swipeCount+1;
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    [userIDNum retain];
    [serverInfo retain];
    
    if (letUserSelectRow) {
   
    
	//unhighlight the selection
    //detailViewController.detailDescriptionLabel.text = [elementsArray objectAtIndex:indexPath.row];
    
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
	
	//check to see if the username and other info is not yet set.  If not, fetch the info and store it
	
    if ([mode isEqualToString:@"Contacts"] || [mode isEqualToString:@"Companies"] ||
        [mode isEqualToString:@"Projects-Master"] || (![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        
        NSArray *nextElements;
        NSString *nextTitle;
        NSString *nextMode;
        NSError *error;
        if (!fromSwipe) {
            swipeCount = 0;
        }
        
        //******************IF DUE FOR REVIEW, WILL DELETE EVENT FROM TABLE********************
        //*******************AS LONG AS THE REVIEW DATE IS NOT TODAY, ONCE THE USER ************
        //*******************NAVIGATES FROM THE EVENT************
        

        if (([eventMode isEqualToString:@"due"]) && (indexPath.row+swipeCount != lastSelectedRow)) {
         
            if (![[[detailViewController.navigationController.viewControllers objectAtIndex:
                   [detailViewController.navigationController.viewControllers count]-1] getTitle] isEqualToString: @""]) {
              
                EventDetail_Proj *temp = [detailViewController.navigationController.viewControllers objectAtIndex:
                                      [detailViewController.navigationController.viewControllers count]-1];
            
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMM d, yyyy"];
                NSDate *dueDate = [format dateFromString:temp.dateLbl.text];
                if ((![[dueDate earlierDate:[NSDate date]] isEqualToDate:dueDate]) || (temp.currentSwitch==1)) {
                    
                 
                    
                    int test = [self getElementsIndexOfStringContaining:temp.eventIDStr:2];
                    if (test < 999) {
                        
                        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:test+1 inSection:0]];
                        if (fromSwipe&&isRightSwipe==NO) {
                            swipeCount = swipeCount-1;
                           
                        }
                    }
                }
            }
        }
        lastSelectedRow = indexPath.row+swipeCount;
        
        //***********************************************************************************
        //*********************************************************************************
        
        
        
        //$ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
        //NSArray *userInfo = [serverInfoStr componentsSeparatedByString:@"~-~"];
        
        
        
        if ([mode isEqualToString:@""]) {
            [aTableView deselectRowAtIndexPath:indexPath animated:YES];
            //if not in any mode yet and the user selects "events" present the Events options
            if ([[elementsArray objectAtIndex:indexPath.row] isEqualToString:@"Events"]) {
                nextElements = [[NSMutableArray alloc] initWithObjects:@"Recent Events", @"Due for Review", @"Active Followup", nil];
                nextTitle = @"Events";
                nextMode = @"Events";
           
            
           
            
            } else if ([[elementsArray objectAtIndex:indexPath.row] isEqualToString:@"Projects"]) {
                
                NSError *error;
                //Get the projects for the array
                NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetProjectsTest.php?mUser=%@&mPassword=%@&UserID=%@",
                                             [serverInfo objectAtIndex:0], 
                                             [serverInfo objectAtIndex:3],
                                             [serverInfo objectAtIndex:4],
                                                 userIDNum];
            
                
                    NSString *projects = [NSString stringWithContentsOfURL: 
                                      [NSURL URLWithString:
                                       getProjectsSite] encoding:
                                          NSASCIIStringEncoding error:&error];
                
                
                NSLog(@"projects: %@", projects);
                
                    NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
                
                
                if ([projects rangeOfString:@"~-~"].location != NSNotFound) {
                    NSLog(@"here");
                    nextElements = [[projects substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~-~"];  
                } else {
                    nextElements = [[NSArray alloc] init];
                    NSLog(@"here2");
                }
           
                
                
                if (([nextElements count] < 1) || [[nextElements objectAtIndex:0] isEqualToString:@""]) {
                    nextTitle = @"Projects (0)";
                } else {
                    nextTitle = [NSString stringWithFormat:@"Projects (%d)", 
                                 [nextElements count]];
                }
                
                nextMode = @"Projects";
            
            } else {
                
                //First check to see if user is a project leader
                NSError *error;
                
                NSString *getIsManager = [NSString stringWithFormat:@"http://%@/GetIsManager.php?mUser=%@&mPassword=%@&userIDNum=%@",
                                          [serverInfo objectAtIndex:0],
                                          [serverInfo objectAtIndex:3],
                                          [serverInfo objectAtIndex:4],
                                          userIDNum];
                
                
                
                isManager = [NSString stringWithContentsOfURL: 
                             [NSURL URLWithString:
                              getIsManager] encoding:NSASCIIStringEncoding error:&error];

                //if they are, they get three options:
                if (![isManager isEqualToString:@"0"]) {
                    nextElements = [[NSArray alloc] initWithObjects:@"Contacts", @"Companies", @"Projects", nil];
                } else {
                    //if they are not, they get two options:
                    nextElements = [[NSArray alloc] initWithObjects:@"Contacts", @"Companies", nil];
                }
                nextTitle = @"Master Database";
                nextMode = @"Master";
                
                
            }
            
            RootViewController *listView = [[RootViewController alloc] init];
           
            listView.elementsArray = nextElements;
            NSLog(@"nextElements: %@", nextElements);
            listView.finalProjectsStr = finalProjectsStr;
            listView.workGroupsArray = workGroupsArray;
            listView.allProjects = allProjects;
            [self prepareNextView: listView];
            listView.titleStr = nextTitle;
            if ([nextTitle isEqualToString:@"Master Database"]) {
                listView.title = nextTitle;
            }
            listView.mode = nextMode;
            [listView setDepth:depth+1];
            listView.lastPrintDate = lastPrintDate;
            listView.parent = self;
            [self.navigationController pushViewController:listView animated:YES];
            //[[Scrap2AppDelegate splitViewController] presentModalViewController:listView animated:YES];
            detailViewController.detailItem = [elementsArray objectAtIndex:indexPath.row];
            
            
            
        } else if ([mode isEqualToString:@"Projects"]) {
            if (depth == 1) {
                
                [aTableView deselectRowAtIndexPath:indexPath animated:YES];
                
                //make array out of row of elements array.  Use the first part as the title for next view
                //and second part has the idea so we can fetch the issues.
                NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                
                
                //get the open issues that go with the specific project
                
                //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                NSString *getIssuesSite = [NSString stringWithFormat:@"http://%@/GetProjectIssues.php?mUser=%@&mPassword=%@&ProjectID=%@",
                                           [serverInfo objectAtIndex:0], 
                                           [serverInfo objectAtIndex:3],
                                           [serverInfo objectAtIndex:4],
                                           [temp objectAtIndex:1]];
                
                NSString *issues = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     getIssuesSite]
                                                            encoding:NSASCIIStringEncoding error:&error];
                
                NSRange lastsquiggle = [issues rangeOfString:@"~-~" options:NSBackwardsSearch];
                
                
                if (lastsquiggle.location != NSNotFound) {
                    
                    nextElements = [[issues substringToIndex:
                                     lastsquiggle.location]
                                    componentsSeparatedByString:@"~-~"];
                } else {
                    nextElements = [issues componentsSeparatedByString:@"~-~"];
                }
                
                if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                 [temp objectAtIndex:0],
                                 0];
                } else {
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                 [temp objectAtIndex:0],
                                 [nextElements count]];
                }
                
                nextMode = @"Projects";
                
                RootViewController *listView = [[RootViewController alloc] init];
                listView.elementsArray = nextElements;
                listView.projectName = [temp objectAtIndex:0];
                listView.projectID = [temp objectAtIndex:1];
                listView.titleStr = nextTitle;
                listView.mode = nextMode;
                listView.lastPrintDate = lastPrintDate;
                listView.parent = self;
                [self prepareNextView: listView];
                [listView setDepth:depth+1];
                [self.navigationController pushViewController:listView animated:YES];
                //[[Scrap2AppDelegate splitViewController] presentModalViewController:listView animated:YES];
                detailViewController.detailItem = [elementsArray objectAtIndex:indexPath.row-1];
                
            }else if (depth == 2) {
                if (indexPath.row != 0) {
                    
                    
                    [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers]
                                                                                    objectAtIndex:0] animated:YES];
                     detailViewController.title = @"";
                    
                    eventController=nil;
                    
                    NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                    
                    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                    NSString *geteventsSite = [NSString stringWithFormat:@"http://%@/GetIssueEvents.php?mUser=%@&mPassword=%@&issueID=%@",
                                               [serverInfo objectAtIndex:0], 
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               [temp objectAtIndex:1], 0];
                    
                    
                    
                    //EventName~+~EventID~+~EventDescription
                    NSString *events = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         geteventsSite]
                                                                encoding:NSASCIIStringEncoding error:&error];
                    
                    
                    NSRange lastsquiggle = [events rangeOfString:@"~-~" options:NSBackwardsSearch];
                    
                    if (lastsquiggle.location != NSNotFound) {
                        nextElements = [[events substringToIndex:
                                         lastsquiggle.location]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [events componentsSeparatedByString:@"~-~"];
                    }
                    
                    
                    
                    if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                        
                        nextTitle = [NSString stringWithFormat:@"%@ (0)", 
                                     [temp objectAtIndex:0]];			
                    } else {
                        nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                     [temp objectAtIndex:0],
                                     [nextElements count]];	
                    }
                    
                    
                    
                    nextMode = @"Projects";
                    
                    RootViewController *listView = [[RootViewController alloc] init];
                    listView.elementsArray = nextElements;
                    listView.allProjects = allProjects;
                    listView.finalProjectsStr = finalProjectsStr;
                    listView.workGroupsArray = workGroupsArray;
                    listView.titleStr = nextTitle;
                    listView.projectName = projectName;
                    listView.projectID = projectID;
                    listView.issueName = [temp objectAtIndex:0];
                    listView.issueID = [temp objectAtIndex:1];
                    listView.mode = nextMode;
                    listView.lastPrintDate = lastPrintDate;
                    listView.parent = self;
                    [self prepareNextView: listView];
                    detailViewController.title = [titleStr substringToIndex:[titleStr rangeOfString:@"("].location];
                    [listView setDepth:depth+1];
                    [self.navigationController pushViewController:listView animated:YES];
                    //[[Scrap2AppDelegate splitViewController] presentModalViewController:listView animated:YES];
                    detailViewController.detailItem = [elementsArray objectAtIndex:indexPath.row-1];
                    
                }
            } else if (depth == 3) {
                
                if (indexPath.row != 0) {
                    
                    if ([[detailViewController.navigationController viewControllers] count] > 3 ) {
                        
                        [detailViewController.navigationController popViewControllerAnimated:NO];
                    }
                    
                    
                    EventDetail_Proj *event;
                    BOOL isPort = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
                                   [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown);
                    
                    
                    if (isPort) {
                        
                        event = [[EventDetail_Proj alloc] initWithNibName:@"EventDetail" bundle:nil];
                        event.isPortrait = YES;
                    } else {
                        
                        event = [[EventDetail_Proj alloc] initWithNibName:@"EventDetailLandGray" bundle:nil];
                        event.isPortrait = NO;
                    }
                    
                    
                    
                    //'EventName~+~EventID~+~EventDescription~+~EventDate~+~ContactID~+~TriageID'];
                    //eventFollowupDate~+~LastUpdate~+~contactName'+~+folluppersonname~+~Respons01~+~Hyperlink01~+~
                    //Hyperlink01Desc~+~Hyperlink02~+~Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc
                    
                    NSArray *temp;
                    BOOL red;
                    BOOL leftRed;
                    
                    if (fromSwipe) {
                        
                        if (indexPath.row+swipeCount == [elementsArray count]) {
                            red = YES;
                        } else {
                            red  = NO;
                        }
                        
                        
                        
                        int temprow = indexPath.row-2+swipeCount;
                        
                        if (temprow < 0) {
                            leftRed = YES;
                        } else {
                            leftRed = NO;
                        }
                        
                        temp = [[elementsArray objectAtIndex:indexPath.row-1+swipeCount] componentsSeparatedByString:@"~+~"];
                        [aTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+swipeCount inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                        
                        event.totalString=[elementsArray objectAtIndex:indexPath.row-1+swipeCount];
                    } else {
                        if (indexPath.row == [elementsArray count]) {
                            red = YES;
                        } else {
                            red  = NO;
                        }
                        
                        int temprow = indexPath.row-2;
                        
                        if (temprow < 0) {
                            leftRed = YES;
                        } else {
                            leftRed = NO;
                        }
                        
                        temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                        event.totalString=[elementsArray objectAtIndex:indexPath.row-1];
                    }
                    
                    event.rightRed = red;
                    event.leftRed = leftRed;
                    event.linkAStr = [temp objectAtIndex:11];
                    event.linkADescrStr = [temp objectAtIndex:12];
                    event.linkBStr = [temp objectAtIndex:13];
                    event.linkBDescrStr = [temp objectAtIndex:14];
                    event.title = [detailViewController getTitle];
                    event.masterNav = self.navigationController;
                    event.parent = detailViewController;
                    event.theRoot = self;
                    event.contactPerson = [temp objectAtIndex:8];
                    event.contactPersonID = [temp objectAtIndex:4];
                    event.followupPerson = [temp objectAtIndex:9];
                    event.dateText = [temp objectAtIndex:6];
                    event.eventName = [temp objectAtIndex:0];
                    event.dateCreatedStr = [temp objectAtIndex:3];
                    event.projectIDStr = projectID;
                    event.currentSwitch = currentSeg;
                    event.eventIDStr = [temp objectAtIndex:1];
                    event.issueName = issueName;
                    event.lastUpdateStr = [temp objectAtIndex:7];
                    event.notesText = [temp objectAtIndex:2];
                    event.rootViewController = self;
                    event.priorityNum = [[temp objectAtIndex:5] intValue];
                    event.needPush = YES;
                    event.ourIndexPath = indexPath;
                    event.newEvent = newEvent;
                    lastView = event;
                    eventController = event;
                    newEvent = NO;
                    if (fromSwipe) {
                        if (isRightSwipe) {
                            
                            
                            
                            
                            //[[detailViewController navigationController] pushViewController:event animated:NO];
                            
                            
                            NSMutableArray *vcs =  [NSMutableArray arrayWithArray:detailViewController.navigationController.viewControllers];
                            [vcs retain];
                            [vcs insertObject:event atIndex:[vcs count]-1];
                            [detailViewController.navigationController setViewControllers:vcs animated:NO];
                            [detailViewController.navigationController popViewControllerAnimated:YES];
                            
                            
                        } else {
                            [[detailViewController navigationController] pushViewController:event animated:YES];
                        }
                    } else {
                        [[detailViewController navigationController] pushViewController:event animated:NO];
                    }
                    fromSwipe = NO;
                }
            }
            
        } else if ([mode isEqualToString:@"Events"]) {
            
            NSString *nextEventMode;
            
            if (depth == 1) {
                [aTableView deselectRowAtIndexPath:indexPath animated:YES];
                nextMode = @"Events";
                
                if (indexPath.row == 2) {
                    //assigned to you and you can pick priority level
                    [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers] objectAtIndex:0] animated:YES];
                    detailViewController.title = @"";
                    NSString *eventsString = [self getActiveEvents:2];
                    
                    
                    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
                        nextElements = [[eventsString substringToIndex:
                                         eventsString.length-3]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [eventsString componentsSeparatedByString:@"~-~"];
                    }
                    
                    nextEventMode = @"active";
                    
                    
                    if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                        nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                     [elementsArray objectAtIndex:indexPath.row],
                                     0];
                    } else {
                        nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                     [elementsArray objectAtIndex:indexPath.row],
                                     [nextElements count]];
                    }
              
                } else if (indexPath.row == 1) {
                    //*********************************DUE FOR REVIEW**********************************
                    //This is followup day is today or older and work group.
                    //You can select which priority you want to look at
                    
                    [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers]
                                                                                    objectAtIndex:0] animated:YES];
                     detailViewController.title = @"";
                    
              
                    
                    NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                               [serverInfo objectAtIndex:0],
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               userIDNum];
                    
                    
                    
                    NSString *workGroups = [NSString stringWithContentsOfURL: 
                                            [NSURL URLWithString:
                                             getWorkGroups]
                                                                    encoding:NSASCIIStringEncoding error:&error];
                    
                    
                    NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
                        
                    if (lastsquiggle.location != NSNotFound) {
                            
                        workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
                            
                    } else {
                        workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
                    }

                    workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];
                    
                                        
                    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"YYYY-MM-dd"];
                    NSString *today = [format stringFromDate:[NSDate date]];
                    NSString *eventsString = [self getDueEvents:today:4];
                    
                    
                    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
                        nextElements = [[eventsString substringToIndex:
                                         eventsString.length-3]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [eventsString componentsSeparatedByString:@"~-~"];
                    }
                    
                    
                    nextEventMode = @"due";
                    if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                        nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                     [elementsArray objectAtIndex:indexPath.row],
                                     0];
                    } else {
                        nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                     [elementsArray objectAtIndex:indexPath.row],
                                     [nextElements count]];
                    }
                    
                    
                } else {
                    //********************************RECENT EVENTS*********************************
                    //created in last 48 hours/take out weekends - look at work group and date created
                    //also allow for choice of priority
                    //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
                    
                    [detailViewController.navigationController popToViewController:[[detailViewController.navigationController viewControllers]
                                                                                    objectAtIndex:0] animated:YES];
                     detailViewController.title = @"";
                    
                   
                    
                    
                        NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                               [serverInfo objectAtIndex:0],
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               userIDNum];
                    
                    
                    
                        NSString *workGroups = [NSString stringWithContentsOfURL: 
                                            [NSURL URLWithString:
                                             getWorkGroups]
                                                                    encoding:NSASCIIStringEncoding error:&error];
                    
                    
                        NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
                        
                        if (lastsquiggle.location != NSNotFound) {
                            
                            workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
                            
                        } else {
                            workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
                        }
                        
                        workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];

                    
                    
                
                    
                    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    NSDate *now = [NSDate date];
                    int daysToAdd = -2;
                    
                    //other one is deprecated so switch to this
                   // NSDate *afterDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
                    NSDate *afterDate = [now addTimeInterval:60*60*24*daysToAdd];
                    NSDate *finalAfterDate;
                    
                    NSCalendar* cal = [NSCalendar currentCalendar];
                    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:afterDate];
                    
                    //take out the weekends - get the last 48 hours from the week
                    
                    // 1 = Sunday, 2 = Monday, etc.
                    if (([comp weekday]==1)||([comp weekday]==7)) {
                        finalAfterDate = [afterDate addTimeInterval:-60*60*24*3];
                        
                    } else {
                        finalAfterDate = afterDate;
                    }
                    
                    
                    
                    [format setDateFormat:@"YYYY-MM-dd"];
                    NSString *afterDateStr = [format stringFromDate:finalAfterDate];
               
           
                    NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&Triage=%d&DateAfter=%@&UserID=%@&WorkGroupID=%@",
                                               [serverInfo objectAtIndex:0], 
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               currentPriority+1,
                                               afterDateStr,userIDNum, workGroupID];    
                    
                    NSString *eventsString = [NSString stringWithContentsOfURL: 
                                          [NSURL URLWithString:
                                           getEventsSite] encoding:NSASCIIStringEncoding error:&error];
            
                    
                    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
                        nextElements = [[eventsString substringToIndex:
                                         eventsString.length-3]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [eventsString componentsSeparatedByString:@"~-~"];
                    }
                    
                    
                    nextEventMode = @"recent";
                    
                    if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                        nextTitle = [NSString stringWithFormat:@"%@ (0)",
                                     [elementsArray objectAtIndex:indexPath.row]];
                    } else {
                    
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)",
                                 [elementsArray objectAtIndex:indexPath.row],
                                 [nextElements count]];
                    }
                }
                
                RootViewController *listView = [[RootViewController alloc] init];
                listView.workGroupsArray = workGroupsArray;
                listView.finalProjectsStr = finalProjectsStr;
                listView.allProjects = allProjects;
                listView.elementsArray = nextElements;
                listView.title = nextTitle;
                listView.mode = nextMode;
                [self prepareNextView:listView];
                listView.eventMode = nextEventMode;
                listView.detailViewController = detailViewController;
                [listView setDepth:depth+1];
                listView.lastPrintDate = lastPrintDate;
                listView.parent = self;
                [self.navigationController pushViewController:listView animated:YES];
                //[[Scrap2AppDelegate splitViewController] presentModalViewController:listView animated:YES];
                detailViewController.detailItem = [elementsArray objectAtIndex:indexPath.row];
            }else {
                
                if (indexPath.row != 0) {
                    
                    
                    if ([[detailViewController.navigationController viewControllers] count] > 3 ) {
                        [detailViewController.navigationController popViewControllerAnimated:NO];
                    }
                    
                    EventDetail_Proj *event;
                    BOOL isPort = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
                                   [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown);
                    NSString *tagline;
                    
                    if ([eventMode isEqualToString:@"recent"]) {
                        
                        if (isPort) {
                            event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventPort" bundle:nil];
                            event.isPortrait = YES;
                        } else {
                            
                            event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventLand" bundle:nil];
                            event.isPortrait = NO;
                        }
                        tagline = @"REVISE ONLY AS NEEDED";
                        event.eventsMode = @"recent";
                    } else if ([eventMode isEqualToString:@"active"]) {
                        
                        if (isPort) {
                            event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventPort" bundle:nil];
                            event.isPortrait = YES;
                        } else {
                            event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventLand" bundle:nil];
                            event.isPortrait = NO;
                        }
                        tagline = @"";
                        event.eventsMode = @"active";
                    } else {
                        if (isPort) {
                            event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventPort" bundle:nil];
                            event.isPortrait = YES;
                        } else {
                            event = [[EventDetail_Proj alloc] initWithNibName:@"RecentEventLand" bundle:nil];
                            event.isPortrait = NO;
                        }
                        
                        event.eventsMode = @"due";
                        tagline = @"ACTION REQUIRED";
                    }
                    
                    NSArray *temp;
                    
                    BOOL rightRed;
                    BOOL leftRed;
                    
                    if (fromSwipe) {
                        
                        if (indexPath.row+swipeCount==[elementsArray count]) {
                            rightRed = YES;
                        } else {
                            rightRed = NO;
                        }
                        
                        int tempAmount=indexPath.row-2+swipeCount;
                        
                        if (tempAmount<0) {
                            leftRed = YES;
                        } else {
                            leftRed = NO;
                        }
                        
                        temp = [[elementsArray objectAtIndex:indexPath.row-1+swipeCount] componentsSeparatedByString:@"~+~"];
                        [aTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+swipeCount inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                        
                        event.totalString=[elementsArray objectAtIndex:indexPath.row-1+swipeCount];
                    } else {
                        
                        if (indexPath.row==[elementsArray count]) {
                            rightRed = YES;
                        } else {
                            rightRed = NO;
                        }
                        
                        int tempAmount=indexPath.row-2;
                        
                        if (tempAmount<0) {
                            leftRed = YES;
                        } else {
                            leftRed = NO;
                        }
                        
                        temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                        event.totalString=[elementsArray objectAtIndex:indexPath.row-1];
                    }
                    
                    /*
                     Project Name~+~EventName~+~EventID~+~$eventRealDescription~+~EventDate~+~
                     ContactID~+~TriageID~+~EventFollowupDate~+~EventChangeDate~+~ContactName
                     UserName~+~Respons01~+~Hyperlink01~+~Hyperlink01Desc~+~Hyperlink02
                     Hyperlink02Desc~+~Hyperlink03~+~Hyperlink03Desc~+~ProjectIssueName~+~ProjectID";
                     */
                    event.title = [temp objectAtIndex:0];
                    event.taglineStr = tagline;
                    event.masterNav = self.navigationController;
                    event.parent = detailViewController;
                    event.theRoot = self;
                    event.leftRed = leftRed;
                    event.rightRed = rightRed;
                    event.contactPerson = [temp objectAtIndex:9];
                    event.contactPersonID = [temp objectAtIndex:5];
                    event.followupPerson = [temp objectAtIndex:10];
                    event.dateText = [temp objectAtIndex:7];
                    event.eventName = [temp objectAtIndex:1];
                    event.dateCreatedStr = [temp objectAtIndex:4];
                    event.projectIDStr = [temp objectAtIndex:19];
                    self.projectID = [temp objectAtIndex:19];//so the personPopController can find the PMID so workgroup is correct.
                    event.currentSwitch = currentSeg;
                    event.eventIDStr = [temp objectAtIndex:2];
                    event.issueName = [temp objectAtIndex:18];
                    event.lastUpdateStr = [temp objectAtIndex:8];
                    event.notesText = [temp objectAtIndex:3];
                    event.rootViewController = self;
                    event.priorityNum = [[temp objectAtIndex:6] intValue];
                    event.needPush = YES;
                    event.newEvent = NO;
                    event.ourIndexPath = indexPath;
                    lastView = event;
                    eventController = event;
                    if (fromSwipe) {
                        if (isRightSwipe) {
                            
                            NSMutableArray *vcs =  [NSMutableArray arrayWithArray:detailViewController.navigationController.viewControllers];
                            [vcs retain];
                            [vcs insertObject:event atIndex:[vcs count]-1];
                            [detailViewController.navigationController setViewControllers:vcs animated:NO];
                            [detailViewController.navigationController popViewControllerAnimated:YES];
                        } else {
                            [[detailViewController navigationController] pushViewController:event animated:YES];
                        }
                    } else {
                        [[detailViewController navigationController] pushViewController:event animated:NO];
                    }
                    fromSwipe = NO;
                }
            }
            
        } else {
            
            
            
            if (depth ==1) {
                
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                if (indexPath.row==0) {
                    
                    [detailViewController.navigationController popViewControllerAnimated:NO]; 
                  
                    
                    //********************** Open Contact Book to Cover View **********************
                    
                    //make a check to see if the array is empty -- might need it...
                    FullContactViewController *contactView = [[FullContactViewController alloc] init];
                    contactView.title = @"Contact Information";
                    contactView.selectRow = -1;
                    contactView.selectSection = 0;
                    contactView.contact.titleLbl1.text = @"";
                    [detailViewController.navigationController pushViewController:contactView animated:YES];
                    [contactView release];
                    
                    contactOpen = YES;
                    
                    //*************************************************************************
                    
                    nextMode = @"Contacts";
                    nextTitle = @"Contacts";
                    
                    NSString *getContacts = [NSString stringWithFormat:@"http://%@/GetContacts.php?mUser=%@&mPassword=%@",
                                             [serverInfo objectAtIndex:0], 
                                             [serverInfo objectAtIndex:3],
                                             [serverInfo objectAtIndex:4]];
                    
                    //ContactName~+~ContactID
                    NSString *contacts = [NSString stringWithContentsOfURL: 
                                          [NSURL URLWithString:
                                           getContacts]
                                                                  encoding:NSASCIIStringEncoding error:&error];
                    
                    NSRange lastsquiggle = [contacts rangeOfString:@"~-~" options:NSBackwardsSearch];
                    
                    NSArray *people;
                    
                    if (lastsquiggle.location != NSNotFound) {
                        people = [[contacts substringToIndex:
                                   lastsquiggle.location]
                                  componentsSeparatedByString:@"~-~"];
                    } else {
                        people = [contacts componentsSeparatedByString:@"~-~"];
                    }
                    
                    [people retain];
                    
                    [indexArray removeAllObjects];
                    [indexArray addObject:@"{search}"];
                    nextElements = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[people count]:[[people objectAtIndex:0] substringToIndex:1]:people];
                    
                    
                    
                    
                } else if (indexPath.row==1) {
                    nextMode = @"Companies";
                    
                    nextTitle = @"Companies";
                    
                    NSString *getCompanies = [NSString stringWithFormat:@"http://%@/GetCompanies.php?mUser=%@&mPassword=%@",
                                             [serverInfo objectAtIndex:0], 
                                             [serverInfo objectAtIndex:3],
                                             [serverInfo objectAtIndex:4]];
                    
                    //ContactName~+~ContactID
                    NSString *contacts = [NSString stringWithContentsOfURL: 
                                          [NSURL URLWithString:
                                           getCompanies]
                                          encoding:NSASCIIStringEncoding error:&error];
                    
                    NSRange lastsquiggle = [contacts rangeOfString:@"~-~" options:NSBackwardsSearch];
                    
                    NSArray *companies;
                    
                    if (lastsquiggle.location != NSNotFound) {
                        companies = [[contacts substringToIndex:
                                   lastsquiggle.location]
                                  componentsSeparatedByString:@"~-~"];
                    } else {
                        companies = [contacts componentsSeparatedByString:@"~-~"];
                    }
                    
                    [companies retain];
                    [indexArray removeAllObjects];
                    [indexArray addObject:@"{search}"];
                    
                    nextElements = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[companies count]:[[companies objectAtIndex:0] substringToIndex:1]:companies];
                    
                    
                } else {
                    
                    nextMode = @"Projects-Master";
                    
                    nextTitle = @"Projects";
                   
                    NSString *getProjects = [NSString stringWithFormat:@"http://%@/GetProjectAlphabetically.php?mUser=%@&mPassword=%@",
                                              [serverInfo objectAtIndex:0], 
                                              [serverInfo objectAtIndex:3],
                                              [serverInfo objectAtIndex:4]];
                  
                  
                    
                    //ContactName~+~ContactID
                    NSString *theProjects = [NSString stringWithContentsOfURL: 
                                          [NSURL URLWithString:
                                           getProjects]
                                                                  encoding:NSASCIIStringEncoding error:&error];
             
                    
                  
                    
                    NSRange lastsquiggle = [theProjects rangeOfString:@"~-~" options:NSBackwardsSearch];
                    
                    NSArray *projects;
                    
                    if (lastsquiggle.location != NSNotFound) {
                        projects = [[theProjects substringToIndex:
                                      lastsquiggle.location]
                                     componentsSeparatedByString:@"~-~"];
                    } else {
                        projects = [theProjects componentsSeparatedByString:@"~-~"];
                    }
                    
                    [projects retain];
                    
                    projects = [projects sortedArrayUsingSelector: @selector(compare:)];
    
                    
                    [indexArray removeAllObjects];
                    [indexArray addObject:@"{search}"];
                    
                    [projects retain];
                    
                    
                    nextElements = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[projects count]:[[projects objectAtIndex:0] substringToIndex:1] :projects];
                  
                    [nextElements retain];

                }
                
                
                RootViewController *listView = [[RootViewController alloc] init];
                listView.allProjects = allProjects;
                listView.finalProjectsStr = finalProjectsStr;
                listView.workGroupsArray = workGroupsArray;
                listView.elementsArray = nextElements;
                listView.titleStr = nextTitle;
                listView.mode = nextMode;
                listView.detailViewController = detailViewController;
                [listView setDepth:depth+1];
                listView.indexArray = indexArray;
                listView.serverInfo = serverInfo;
                listView.lastPrintDate = lastPrintDate;
                listView.parent = self;
                [self.navigationController pushViewController:listView animated:YES];
                //[[Scrap2AppDelegate splitViewController] presentModalViewController:listView animated:YES];
                detailViewController.detailItem = [elementsArray objectAtIndex:indexPath.row];
                [listView release];
                
            } else {
                
         
                if ([detailViewController.navigationController.viewControllers count] > 2) {
                    [detailViewController.navigationController popViewControllerAnimated:NO];
                }
                
                if ([mode isEqualToString:@"Contacts"]) {
                    
                    //Make it check for isSearching
                    
                        
                        UINavigationController *tempNav2 = [appDelegate.splitViewController.viewControllers objectAtIndex:1];
                         
                        
                        FullContactViewController *contactView =[tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1];      
                        
                    if (!searching) {
                        
                        //turn off edit mode
                        [contactView.contact cancelButtonAction:self]; 
                        
                    if (contactView.contact.selectSection < indexPath.section) {
                            contactView.contact.selectSection = indexPath.section;
                            contactView.contact.selectRow = indexPath.row;
                            contactView.contact.contactID = [[[[elementsArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] componentsSeparatedByString:@"~+~"] objectAtIndex:1];
                            [contactView.contact goDownPage:self];
                        
                        } else if (contactView.contact.selectSection > indexPath.section) {
                            contactView.contact.selectSection = indexPath.section;
                            contactView.contact.selectRow = indexPath.row;
                            contactView.contact.contactID = [[[[elementsArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] componentsSeparatedByString:@"~+~"] objectAtIndex:1];
                            [contactView.contact goUpPage:self];
                      
                        } else if (contactView.contact.selectRow < indexPath.row) {
                            contactView.contact.selectSection = indexPath.section;
                            contactView.contact.selectRow = indexPath.row;
                            contactView.contact.contactID = [[[[elementsArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] componentsSeparatedByString:@"~+~"] objectAtIndex:1];
                            [contactView.contact goDownPage:self];

                        } else if (contactView.contact.selectRow > indexPath.row) {
                            contactView.contact.selectSection = indexPath.section;
                            contactView.contact.selectRow = indexPath.row;
                            contactView.contact.contactID = [[[[elementsArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row] componentsSeparatedByString:@"~+~"] objectAtIndex:1];
                            [contactView.contact goUpPage:self];
                        }
                    } else {
                        //if searching
                        //take out of search mode
                        //and select person
                        
                        NSString *name = [copyList objectAtIndex:indexPath.row-1];
                        NSArray *rowSec = [self getPathForName:name];
                        
                        [self searchBarCancelButtonClicked:searchBar];
                        
                        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[[rowSec objectAtIndex:0] intValue] inSection:[[rowSec objectAtIndex:1] intValue]]];
                        
                         [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[[rowSec objectAtIndex:0] intValue]  inSection:[[rowSec objectAtIndex:1] intValue]] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                         
                        [rowSec release];
                        
                    }
                }
            }
         }
    }
    }
}


- (int) getElementsLeft:(int)section:(int)row {
  
    int count=0;
    
    if (!searching){
    
    for (int j = section; j < [elementsArray count]; ++j) {
        int i;
        if (j == section) {
            i = row;
        } else {
            i = 0;
        }
        NSArray *temp = [elementsArray objectAtIndex:j-1];
        for (int i=0; i<[temp count];++i) {
            ++count;
        }
    }
    }else{
       
        for (int i = row; i<[copyList count]; ++i) {
            ++count;
        }
        
    }
    return  count;
}

- (NSComparisonResult) compare:(NSArray *)oneArray:(NSArray *)twoArray {
    
    if ([oneArray objectAtIndex:0] < [twoArray objectAtIndex:0])
        return NSOrderedAscending;
    else if ([oneArray objectAtIndex:0] > [twoArray objectAtIndex:0])
        return NSOrderedDescending;
    else 
        return NSOrderedSame;
    
}



- (NSArray *)getPathForName:(NSString *)name {
    int row;
    int section;
    for (int i=0; i<[elementsArray count]; ++i) {
        NSArray *temp = [elementsArray objectAtIndex:i];
        for (int j=0; j<[temp count]; ++j) {
            if ([[temp objectAtIndex:j] isEqualToString:name]) {
                row = j;
                section = i+1;
                i=[elementsArray count];
                j=[temp count];
            }
        }
    }
    return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",row],[NSString stringWithFormat:@"%d",section], nil];
}




- (NSArray *) generateFinalList:(NSMutableArray *)soFar:(int)index:(int)total:(NSString *)letter:(NSArray *)people {
	
    
	if (index == total) {
        
		if ([[indexArray objectAtIndex:[indexArray count]-1] caseInsensitiveCompare:letter]!=NSOrderedSame) {
            [indexArray addObject:[letter capitalizedString]];
        }
        NSArray *theTemp = [[[NSArray alloc] initWithArray:soFar] autorelease];
        [indexArray retain];
        return theTemp;
	
    } else if ([[[people objectAtIndex:index] substringToIndex:1] caseInsensitiveCompare:letter]!=NSOrderedSame) {
		[soFar addObject:[[NSMutableArray alloc] initWithObjects:
						  [people objectAtIndex:index], nil]];
		[indexArray addObject:[letter capitalizedString]];
		return [self generateFinalList:soFar :index+1 :total :[[people objectAtIndex:index] substringToIndex:1]:people];
        
	} else {
		
		[[soFar objectAtIndex:[soFar count]-1] addObject:[people objectAtIndex:index]];
		return [self generateFinalList:soFar :index+1 :total :letter:people];
		
	}
}


- (NSString *) getRecentEvents:(NSString *)sofar:(NSArray *)theTemp:(NSString *)date:(int) i:(int)triage {
  
    
    if (i==[theTemp count]) {
       return sofar;
    } else {
        
        NSArray *realTemp = [[theTemp objectAtIndex:i] componentsSeparatedByString:@"~+~"];
        NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&ProjectID=%@&DateAfter=%@&Triage=%d",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   [realTemp objectAtIndex:1],
                                   date, triage];
        
        NSError *error;
        NSString *events = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             getEventsSite]
                              encoding:NSASCIIStringEncoding error:&error];
  
        return [self getRecentEvents:[NSString stringWithFormat:@"%@%@",sofar, events]:theTemp:date:i+1:triage];
    }
}






- (NSString *) getActiveEvents:(int)triage {
    
    NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetActiveEvents.php?mUser=%@&mPassword=%@&Triage=%d&UserID=%@",
                            [serverInfo objectAtIndex:0], 
                            [serverInfo objectAtIndex:3],
                            [serverInfo objectAtIndex:4],
                            triage, userIDNum];
        
    NSError *error;
    NSString *events = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             getEventsSite] encoding:NSASCIIStringEncoding error:&error];
        
    return events;
}






- (NSString *) getDueEvents:(NSString *)date:(int)triage {
   
    NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetDueEvents.php?mUser=%@&mPassword=%@&WorkGroupID=%@&Date=%@&Triage=%d",[serverInfo objectAtIndex:0],[serverInfo objectAtIndex:3],[serverInfo objectAtIndex:4],workGroupID, date, triage];
  
    NSError *error;
    NSString *events = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:getEventsSite] encoding:NSASCIIStringEncoding error:&error];
    return events;
}




- (NSArray *) getServerInfo {
    return serverInfo;
}



- (NSString *)getMode {
	return mode;
}



- (void) changeDetailTitle: (NSString *)str {
		detailViewController.title = @"";
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void) setDepth:(int)num {
	depth = num;
}

- (void)dealloc {
    [detailViewController release];
    [detailViewController release]; 
    [elementsArray release]; 
    [mode release]; 
    [eventMode release];
    [serverInfoStr release];
    [usernameTxt release];
    [passwordTxt release];
    [userIDNum release];
    [serverInfo release];
    [LoginName release];
    [UserPassword release];
    [UserName release];
    [UserInitials release];
    [isManager release];
    [isFollowup release];
    [issueName release];
    [issueID release];
    [projectName release];
    [projectID release];
    [newEventTxt release];
    [lastView release];
    [titleStr release];
    [eventController release];
    [PMIdTxt release];
    [allProjects release];
    [finalProjectsStr release];
    [workGroupsArray release];
    [popoverController release];
    [workGroupID release];
    [finalEventsProjectsStr release];
    [allEventsProjects release];
    [workGroupStr release];
    [openedUrl release];
    if (indexArray) {
        [searchBar release];
        [indexArray release];
    }
    [super dealloc];
}


@end

