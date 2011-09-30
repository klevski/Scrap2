//
//  RootViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 4/23/11.
//  Copyright 2011 Riseline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scrap2AppDelegate.h"

@class DetailViewController, EventDetail_Proj;
@class Scrap2AppDelegate;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
    
    RootViewController *parent;
    
    EventDetail_Proj *eventController;
	NSArray *elementsArray;
	NSString *mode;
	int depth;
	NSString *eventMode;
	NSString *serverInfoStr;
	UITextField *usernameTxt;
	UITextField *passwordTxt;
	UITextField *newEventTxt;
    UITextField *PMIdTxt;
	
	NSString *userIDNum;
	NSString *LoginName;
	NSString *UserPassword;
	NSString *UserName;
	NSString *UserInitials;
	NSString *isManager;
	NSString *isFollowup;
	NSArray *serverInfo;
	
	NSString *issueName;
	NSString *issueID;
	NSString *projectName;
	NSString *projectID;
	
	int currentSeg;
	BOOL fromSwipe;
	int swipeCount;
	BOOL isRightSwipe;
	UIViewController *lastView;
    NSString *titleStr;
    int currentPriority;
    int lastSelectedRow;
    NSArray *allProjects;
    NSString *finalProjectsStr;
    NSArray *workGroupsArray;
    UIPopoverController *popoverController;
    //Because this is a subset of finalProjectsStr,
    //we need to separate the two in so loads properly in project mode
    NSString *finalEventsProjectsStr;
    NSArray *allEventsProjects;
    
    NSString *workGroupID;
    NSString *workGroupStr;
    BOOL newEvent;
    
    NSMutableArray *indexArray;
    
    //the importing file
    NSURL *openedUrl;
    Scrap2AppDelegate *appDelegate;
    IBOutlet UITableView *tbl;
    BOOL searching;
    NSMutableArray *copyList;
    BOOL letUserSelectRow;
    UIViewController *black;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITextField *headerText;
    IBOutlet UIView *headerView;
    
    BOOL contactOpen;
    
    NSDate *lastPrintDate;
    NSString *theTitle;
    UISegmentedControl *currentOpenCloseSeg;
    UISegmentedControl *currentPrioritySeg;
    
    NSString *lastRequestMade;
}
@property (nonatomic, retain) NSString *lastRequestMade;
@property (nonatomic, retain) RootViewController *parent;
@property (nonatomic, retain) NSDate *lastPrintDate;
@property (nonatomic, retain) NSMutableArray *copyList;
@property (nonatomic, readwrite) BOOL searching;
@property (nonatomic, retain) NSMutableArray *indexArray;
@property (nonatomic, retain) NSURL *openedUrl;
@property (nonatomic, readwrite) BOOL newEvent;
@property (nonatomic, retain) NSString *workGroupStr;
@property (nonatomic, retain) NSArray *allEventsProjects;
@property (nonatomic, retain) NSString *finalEventsProjectsStr;
@property (nonatomic, retain) NSString *workGroupID;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSArray *workGroupsArray;
@property (nonatomic, retain) NSString *finalProjectsStr;
@property (nonatomic, retain) NSArray *allProjects;
@property (nonatomic, readwrite) int currentPriority;
@property (nonatomic, retain) EventDetail_Proj *eventController;
@property (nonatomic, readwrite) int depth;
@property (nonatomic, readwrite) int lastSelectedRow;
@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) UIViewController *lastView;
@property (nonatomic, readwrite) BOOL isRightSwipe;
@property (nonatomic, readwrite) int swipeCount;
@property (nonatomic, readwrite) BOOL fromSwipe;
@property (nonatomic, readwrite) int currentSeg;
@property (nonatomic, retain) UITextField *newEventTxt;
@property (nonatomic, retain) UITextField *PMIdTxt;
@property (nonatomic, retain) NSString *issueName;
@property (nonatomic, retain) NSString *issueID;
@property (nonatomic, retain) NSString *projectName;
@property (nonatomic, retain) NSString *projectID;
@property (nonatomic, retain) NSString *isFollowup;
@property (nonatomic, retain) NSString *isManager;
@property (nonatomic, retain) NSString *UserInitials;
@property (nonatomic, retain) NSString *UserName;
@property (nonatomic, retain) NSString *UserPassword;
@property (nonatomic, retain) NSString *LoginName;
@property (nonatomic, retain) UITextField *usernameTxt;
@property (nonatomic, retain) UITextField *passwordTxt;
@property (nonatomic, retain) NSString *serverInfoStr;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSArray *elementsArray;
@property (nonatomic, retain) NSString *mode;
@property (nonatomic, retain) NSString *userIDNum;
@property (nonatomic, retain) NSString *eventMode;
@property (nonatomic, retain) NSArray *serverInfo;

- (void) setDepth:(int)num;
- (IBAction)AddButtonAction:(id)sender;
-(NSString *) replaceElement:(int)num:(NSString *)new:(NSString *)old;
- (int)getElementsIndexOfStringContaining:(NSString *)str:(int)place;
- (IBAction) displayWorkGroupTbl:(id)sender;

@end
