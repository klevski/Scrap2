//
//  EventDetail-Proj.h
//  Scrap2
//
//  Created by Kelsey Levine on 4/25/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"
#import "Scrap2AppDelegate.h"


@class Scrap2AppDelegate;
@class personPopController;
@class DateFollowPopController;
@class ContactPopController;
@class RootViewController;

@interface EventDetail_Proj : UIViewController {
   
    
    UIViewController *nextView;
    IBOutlet UILabel *taglineLbl;
    IBOutlet UITextField *documentsTxt;
    NSString *taglineStr;
    IBOutlet UIButton *contactInfoBtn;
	IBOutlet UIButton *blueXBtn;
	IBOutlet UIButton *backToMasterButton;
	UINavigationController *masterNav;
	NSString *orientation;
	UIPopoverController *popoverController;
	IBOutlet UISwitch *complete;
	NSString *linkAStr;
	NSString *linkADescrStr;
	NSString *linkBStr;
	NSString *linkBDescrStr;
	IBOutlet UITextField *contactText;
	IBOutlet UITableView *documentTbl;

	NSMutableArray *elementsArray;
	UIViewController *parent;
	IBOutlet UIButton *linkABtn;
	IBOutlet UIButton *linkBBtn;
	
	IBOutlet UIButton *personPopoverBtn;
	IBOutlet UILabel *personAssignedLbl;
	IBOutlet UIButton *contactPopoverBtn;
	personPopController *personPopView;
	DateFollowPopController *datePopView;
	ContactPopController *contactPopView;

	IBOutlet UILabel *dateLbl;
	NSString *dateText;
	IBOutlet UIButton *dateBtn;
	BOOL vert;
	UIViewController *rootViewController;
	NSString *eventsMode;
	
	IBOutlet UITextView *notes;
	NSString *notesText;
	
	IBOutlet UILabel *eventTitleLbl;
	IBOutlet UILabel *issueTitleLbl;
	NSString *eventName;
	NSString *issueName;
	IBOutlet UILabel *lastUpdateLbl;
	NSString *lastUpdateStr;
	
	IBOutlet UILabel *dateCreatedLbl;
	NSString *dateCreatedStr;
	
	IBOutlet UILabel *eventIDLbl;
	NSString *eventIDStr;
	
	IBOutlet UILabel *projectIDLbl;
	NSString *projectIDStr;
	
	int currentSwitch;
	int priorityNum;
	
	IBOutlet UISegmentedControl *prioritySeg;
	RootViewController *theRoot;
	
	NSString *followupPerson;
	NSString *contactPerson;
	NSString *contactPersonID;
	
	EventDetail_Proj *previous;
	BOOL needPush;
	
	NSIndexPath *ourIndexPath;
	IBOutlet UIButton *completeBtn;
	NSString *totalString;
    IBOutlet UIButton *insertDateBtn;
    BOOL isLoading;
    NSString *hyperlink;
    IBOutlet UITextField *hyperlinkTxt;
    
    //Open/closed segment
    IBOutlet UISegmentedControl *openClosedSeg;
    
    IBOutlet UIButton *blue1;
    IBOutlet UIButton *blue2;
    
    IBOutlet UIImageView *fakeSeg;
    
    IBOutlet UILabel *eventTitleLbl1;
    IBOutlet UILabel *eventTitleLbl2;
	
    IBOutlet UIImageView *rightRedLight;
    IBOutlet UIImageView *leftRedLight;
    BOOL rightRed;
    BOOL leftRed;
    
    IBOutlet UILabel *insertDateLbl;
    IBOutlet UILabel *contactLbl;
    IBOutlet UILabel *linksLbl;
    IBOutlet UILabel *documentsLbl;
    
    NSArray *linksArray;
    BOOL newEvent;
    IBOutlet UIImageView *openClosedSegImage;
    
    Scrap2AppDelegate *appDelegate;
    NSString *getDocUrl;
    
    //**TODO**
    //set this when push this view
    BOOL isPortrait;
    NSTimer* holdTimer;
    int holderCount;
    
    NSString *theTitle;
    
    //To email the contact
    IBOutlet UIButton *emailBtn;
    IBOutlet UITextField *emailText;
    
    
}

@property (nonatomic, readwrite) BOOL isPortrait;
@property (nonatomic, readwrite) BOOL newEvent;
@property (nonatomic, retain) NSArray *linksArray;
@property (nonatomic, readwrite) BOOL leftRed;
@property (nonatomic, readwrite) BOOL rightRed;
@property (nonatomic, retain) NSString *hyperlink;
@property (nonatomic, retain) UIViewController *nextView;
@property (nonatomic, retain) NSString *taglineStr;
@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, retain) NSString *totalString;
@property (nonatomic, retain) IBOutlet UIButton *completeBtn;
@property (nonatomic, retain) IBOutlet UIButton *contactInfoBtn;
@property (nonatomic, retain) IBOutlet UIButton *linkABtn;
@property (nonatomic, retain) IBOutlet UIButton *linkBBtn;
@property (nonatomic, retain) NSString *linkAStr;
@property (nonatomic, retain) NSString *linkADescrStr;
@property (nonatomic, retain) NSString *linkBStr;
@property (nonatomic, retain) NSString *linkBDescrStr;
@property (nonatomic, retain) NSString *contactPersonID;
@property (nonatomic, retain) NSString *contactPerson;
@property (nonatomic, retain) IBOutlet UIButton *contactPopoverBtn;
@property (nonatomic, retain) NSIndexPath *ourIndexPath;
@property (nonatomic, readwrite) BOOL needPush;
@property (nonatomic, retain) EventDetail_Proj *previous;
@property (nonatomic, retain) NSString *followupPerson;
@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, retain) IBOutlet UISegmentedControl *prioritySeg;
@property (nonatomic, readwrite) int priorityNum;
@property (nonatomic, readwrite) int currentSwitch;
@property (nonatomic, retain) NSString *eventIDStr;
@property (nonatomic, retain) NSString *projectIDStr;
@property (nonatomic, retain) IBOutlet UILabel *dateCreatedLbl;
@property (nonatomic, retain) NSString *dateCreatedStr;
@property (nonatomic, retain) IBOutlet UILabel *eventIDLbl;
@property (nonatomic, retain) IBOutlet UILabel *projectIDLbl;
@property (nonatomic, retain) IBOutlet UILabel *lastUpdateLbl;
@property (nonatomic, retain) NSString *lastUpdateStr;
@property (nonatomic, retain) NSString *dateText;
@property (nonatomic, retain) NSString *issueName;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventTitleLbl;
@property (nonatomic, retain) IBOutlet UILabel *issueTitleLbl;
@property (nonatomic, retain) NSString *notesText;
@property (nonatomic, retain) IBOutlet UITextView *notes;
@property (nonatomic, retain) IBOutlet UIButton *blueXBtn;
@property (nonatomic, retain) NSString *eventsMode;
@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, retain) DateFollowPopController *datePopView;
@property (nonatomic, retain) ContactPopController *contactPopView;
@property (nonatomic, retain) IBOutlet UIButton *dateBtn;
@property (nonatomic, retain) IBOutlet UILabel *dateLbl;
@property (nonatomic, retain) personPopController *personPopView;
@property (nonatomic, retain) IBOutlet UILabel *personAssignedLbl;
@property (nonatomic, retain) IBOutlet UIButton *personPopoverBtn;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic, retain) UIViewController *parent;
@property (nonatomic, retain) IBOutlet UIButton *backToMasterButton;
@property (nonatomic, retain) UINavigationController *masterNav;
@property (nonatomic, retain) NSString *orientation;
@property (nonatomic, retain) IBOutlet UISwitch *complete;
@property (nonatomic, retain) IBOutlet UITextField *contactText;
@property (nonatomic, retain) IBOutlet UITableView *documentTbl;
@property (nonatomic, retain) NSMutableArray *elementsArray;
@property (nonatomic, retain) IBOutlet UIButton *insertDateBtn;

//for importing files
- (void)importAndSelectFromURL:(NSURL *)url;

- (IBAction) masterPushed: (id)sender;
- (IBAction) personPopoverBtnPushed:(id)sender;
- (IBAction) dateBtnPushed:(id)sender;
- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration;
- (void) changeReviewDate:(NSDate *)date:BOOL:first;
- (IBAction) blueXBtnPushed: (BOOL)first;
- (IBAction) switchValueChanged;
- (IBAction) segValueChanged;
- (IBAction) contactPersonPushed:(id)sender;
- (IBAction) linkBtnClicked:(id)sender;
- (IBAction) contactBtnPushed:(id)sender;
- (IBAction) completeBtnPushed:(id)sender;
- (IBAction) backgroundClicked:(id)sender;
- (IBAction) printDate:(id)sender;
- (IBAction) latestSegmentAction:(id)sender;
- (void) changePersonAssigned:(NSString *)person:(BOOL)first;
- (IBAction)showDocPushed:(id)sender;
- (IBAction) openBlueBtnPressed:(id)sender;
- (IBAction) closedBlueBtnPressed:(id)sender;
- (NSString *)uploadData:(NSURL *)url;
- (IBAction) blueSegBtnPressed:(id)sender;
-(IBAction) startAction: (id)sender;
-(IBAction) stopAction: (id)sender;
-(IBAction)sendEmail:(id)sender;
-(IBAction)emailTxtPressed:(id)sender;


@end

