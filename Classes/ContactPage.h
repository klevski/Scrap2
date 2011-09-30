//
//  ContactPage.h
//  Scrap2
//
//  Created by Kelsey Levine on 6/30/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "FullContactViewController.h"

@class FullContactViewController;

@interface ContactPage : UIViewController {
    RootViewController *theRoot;
    NSString *contactID;
    int selectRow;
    int selectSection;
    FullContactViewController *parent;
 
    
    IBOutlet UIView *topView;
    IBOutlet UIView *bottomView;
    
    IBOutlet UILabel *contactName;
    IBOutlet UILabel *contactTitle;
    IBOutlet UILabel *companyName;
    IBOutlet UILabel *email;
    IBOutlet UILabel *officePhone;
    IBOutlet UILabel *mobilePhone;
    IBOutlet UILabel *fax;
    IBOutlet UILabel *contactWebsite;
    IBOutlet UILabel *compAddress1;
    IBOutlet UILabel *compAddress2;
    IBOutlet UILabel *compAddress3;
    IBOutlet UILabel *compAddress4;
    IBOutlet UILabel *compAddress5;
    IBOutlet UILabel *compWebsite;
    IBOutlet UITextView *notes;
    
    IBOutlet UITextField *contactNameTxt;
    IBOutlet UITextField *contactTitleTxt;
    IBOutlet UITextField *companyNameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *officePhoneTxt;
    IBOutlet UITextField *mobilePhoneTxt;
    IBOutlet UITextField *faxTxt;
    IBOutlet UITextField *contactWebsiteTxt;
    IBOutlet UITextField *compAddress1Txt;
    IBOutlet UITextField *compAddress2Txt;
    IBOutlet UITextField *compAddress3Txt;
    IBOutlet UITextField *compAddress4Txt;
    IBOutlet UITextField *compAddress5Txt;
    IBOutlet UITextField *compWebsiteTxt;
    
    IBOutlet UITextField *notesTxt;
   
    IBOutlet UIButton *emailBtn;
    IBOutlet UIButton *contactSiteBtn;
    IBOutlet UIButton *compSiteBtn;
    
    IBOutlet UILabel *nameLabellbl;
    IBOutlet UILabel *companyLabellbl;
    IBOutlet UILabel *titleLabellbl;
    
    IBOutlet UILabel *nameLabellbl2;
    IBOutlet UILabel *companyLabellbl2;
    IBOutlet UILabel *titleLabellbl2;
    
    IBOutlet UIButton *emailBtn2;
    IBOutlet UIButton *contactSiteBtn2;
    IBOutlet UIButton *compSiteBtn2;
    
    IBOutlet UILabel *contactName2;
    IBOutlet UILabel *contactTitle2;
    IBOutlet UILabel *companyName2;
    IBOutlet UILabel *email2;
    IBOutlet UILabel *officePhone2;
    IBOutlet UILabel *mobilePhone2;
    IBOutlet UILabel *fax2;
    IBOutlet UILabel *contactWebsite2;
    IBOutlet UILabel *compAddress12;
    IBOutlet UILabel *compAddress22;
    IBOutlet UILabel *compAddress32;
    IBOutlet UILabel *compAddress42;
    IBOutlet UILabel *compAddress52;
    IBOutlet UILabel *compWebsite2;
    IBOutlet UITextView *notes2;
    
    IBOutlet UITextField *contactNameTxt2;
    IBOutlet UITextField *contactTitleTxt2;
    IBOutlet UITextField *companyNameTxt2;
    IBOutlet UITextField *emailTxt2;
    IBOutlet UITextField *officePhoneTxt2;
    IBOutlet UITextField *mobilePhoneTxt2;
    IBOutlet UITextField *faxTxt2;
    IBOutlet UITextField *contactWebsiteTxt2;
    IBOutlet UITextField *compAddress1Txt2;
    IBOutlet UITextField *compAddress2Txt2;
    IBOutlet UITextField *compAddress3Txt2;
    IBOutlet UITextField *compAddress4Txt2;
    IBOutlet UITextField *compAddress5Txt2;
    IBOutlet UITextField *compWebsiteTxt2;
    
     IBOutlet UITextField *notesTxt2;
    
    IBOutlet UILabel *titleLbl1;
    IBOutlet UILabel *titleLbl2;
    IBOutlet UIView  *titleView;
    
    IBOutlet UILabel *titleLbl21;
    IBOutlet UILabel *titleLbl22;
    IBOutlet UIView  *titleView2;
    
    //is set by parent depending on if
    //there are any elements in theRoot
    BOOL isTitle;
    
    UIView *currentView;
    UIView *hiddenView;
    
    UIView *currentTitle;
    UIView *hiddenTitle;
    
    BOOL emptyNote;
    
    int swipeCount;
    BOOL fromSwipe;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *scrollView2;
    BOOL editing;
    
    UITextField *editingText;
    NSString *companyID;
    IBOutlet UIButton *chooseCompBtn;
    IBOutlet UIButton *chooseCompBtn2;
    UIPopoverController *popoverController;
    
    IBOutlet UIButton *enableText;
    IBOutlet UIButton *enableText2;
   
}
@property (nonatomic, retain) IBOutlet UILabel *titleLbl1;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl2;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl21;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl22;
@property (nonatomic, readwrite) BOOL isTitle;
@property (nonatomic, retain) FullContactViewController *parent;
@property (nonatomic, readwrite) int swipeCount;
@property (nonatomic, readwrite) BOOL fromSwipe;
@property (nonatomic, readwrite) int selectSection;
@property (nonatomic, readwrite) int selectRow;
@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, retain) NSString *contactID;
@property (nonatomic, retain) UIView *hiddenView;
@property (nonatomic, retain) UIView *currentView;

- (IBAction) goUpPage:(id)sender;
- (IBAction) goDownPage:(id)sender;
- (IBAction) chooseCompany:(id)sender;
- (IBAction) sendEmail:(id)sender;
- (IBAction) goToCompSite:(id)sender;
- (IBAction) goToContactSite:(id)sender;
- (NSString *) cleanString: (NSString *)theNotes;
- (IBAction)makeNotesEditable;

@end
