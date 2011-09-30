//
//  FileRootViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 6/20/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scrap2AppDelegate.h"


@class Scrap2AppDelegate;


@interface FileRootViewController : UIViewController {
    
    Scrap2AppDelegate *appDelegate;
    
    IBOutlet UITableView *firstTable;
    IBOutlet UITableView *otherTable;
    IBOutlet UILabel *backLbl;
    IBOutlet UIButton *backBtn;
    
    UITableView *table;
    UITableView *notTable;
    
    NSArray *elementsArray;
    NSString *finalProjectsStr;
    NSArray *workGroupsArray;
    NSArray *allProjects;
    NSArray *serverInfo;
    NSString *titleStr;
    NSString *mode;
    int depth;
    NSString *eventMode;
    NSString *userIDNum;
    
    NSString *workGroupStr;
    NSArray *allEventsProjects;
    NSString *workGroupID;
    int currentPriority;
    int currentSeg;
    UIPopoverController *popoverController;
    
    NSString *projectName;
    NSString *projectID;
    NSString *issueName;
    NSString *issueID;
    
    BOOL isreloadingTbl;
    
    //to put all previous view
    //controllers (as strings)
    //divided by ~+~
    NSMutableArray *stack;
    NSMutableArray *stringStack;
    BOOL isLoading;
    
}
@property (nonatomic, retain) NSMutableArray *stringStack;
@property (nonatomic, retain) NSMutableArray *stack;
@property (nonatomic, retain) NSString *projectName;
@property (nonatomic, retain) NSString *projectID;
@property (nonatomic, retain) NSString *userIDNum;
@property (nonatomic, retain) NSString *eventMode;;
@property (nonatomic, retain) NSString *workGroupID;
@property (nonatomic, retain) NSString *workGroupStr;
@property (nonatomic, retain) NSArray *elementsArray;
@property (nonatomic, retain) NSString *finalProjectsStr;
@property (nonatomic, retain) NSArray *workGroupsArray;
@property (nonatomic, retain) NSArray *allProjects;
@property (nonatomic, retain) NSArray *serverInfo;
@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSString *mode;
@property (nonatomic, readwrite) int depth;
@property (nonatomic, retain) NSArray *allEventsProjects;

- (IBAction)backBtnPressed:(id)sender;

@end
