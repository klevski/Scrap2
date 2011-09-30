//
//  ContactPage.m
//  Scrap2
//
//  Created by Kelsey Levine on 6/30/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "ContactPage.h"
#import "WorkGroupTblView.h"


@implementation ContactPage

@synthesize theRoot, contactID, selectRow, selectSection, currentView, hiddenView, swipeCount, fromSwipe, parent;

@synthesize isTitle, titleLbl1, titleLbl2, titleLbl21, titleLbl22;

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
    [self.view addSubview:topView];
    currentView = topView;
    hiddenView = bottomView;
    currentTitle = titleView;
    hiddenTitle = titleView2;
    
    isTitle = YES;
    selectRow = -1;
    
    scrollView.contentSize = CGSizeMake(400, 980);
    scrollView2.contentSize = CGSizeMake(400, 980);
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpAction:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[self.view addGestureRecognizer:swipeLeft];
    
    
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownAction:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[self.view addGestureRecognizer:swipeRight];
    
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpAction:)];
	swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	swipeUp.delegate = self;
	[self.view addGestureRecognizer:swipeUp];
    
	UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownAction:)];
	swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	swipeDown.delegate = self;
	[self.view addGestureRecognizer:swipeDown];
	
    
    [self.view addSubview:currentTitle];
    titleLbl1.text = @"";

    UIBarButtonItem *returnToSwitchBtn = [[UIBarButtonItem alloc] initWithTitle:@"Return to Switchboard" style:UIBarButtonItemStyleBordered target:self action:@selector(masterPushed:)];
    
    [parent.navigationItem setLeftBarButtonItem:returnToSwitchBtn];
    [returnToSwitchBtn release];
    
}



- (IBAction) goDownPage:(id)sender {
    
    if (!emptyNote) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:parent action:@selector(editButtonAction:)];
        
        [parent.navigationItem setRightBarButtonItem:editButton];
        [editButton release];
        
        hiddenView.alpha = 1;
    } else {
        //get rid of right bar button
        [parent.navigationItem setRightBarButtonItem:nil];
    }
    
    
    [self assignHiddenValues];
   
    UIView *tempView;
    if (isTitle) {
        tempView = currentTitle;
    } else {
        tempView = currentView;
    }
    
    isTitle = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [tempView removeFromSuperview];
    [self.view addSubview:hiddenView];
    [UIView commitAnimations];
    
    UIView *tempCurrent = currentView;
    currentView = hiddenView;
    hiddenView = tempCurrent;
    if (!emptyNote) {
       
    if ([theRoot getElementsLeft:selectSection:selectRow] == 2) {
        [self performSelector:@selector(twoPages) withObject:nil afterDelay:.05];
    } else if ([theRoot getElementsLeft:selectSection:selectRow] == 0) {
        [self performSelector:@selector(emptyPages) withObject:nil afterDelay:.05];
    }
    }
        
}

- (IBAction) goUpPage:(id)sender {
    
    [self assignHiddenValues];
    
    if (!emptyNote) {
        hiddenView.alpha = 1;
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:parent action:@selector(editButtonAction:)];
        
        [parent.navigationItem setRightBarButtonItem:editButton];
        [editButton release];
    } else {
        parent.navigationItem.rightBarButtonItem = nil;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
     [currentView removeFromSuperview];
    [self.view addSubview:hiddenView];
    [UIView commitAnimations];
    
    UIView *tempCurrent = currentView;
    currentView = hiddenView;
    hiddenView = tempCurrent;
    
  

    
    if ([theRoot getElementsLeft:selectSection:selectRow] > 2) {
        [self performSelector:@selector(fillPages) withObject:nil afterDelay:.8];
  
    } else if ([theRoot getElementsLeft:selectSection:selectRow] > 0) {
        [self performSelector:@selector(twoPages) withObject:nil afterDelay:.8];
    } else {
         [self performSelector:@selector(emptyPages) withObject:nil afterDelay:.8];
    }
}

- (void) twoPages {
     [parent addTwoPages];
}

- (void) emptyPages {
    [parent emptyNotepad];
}

- (void) fillPages {
     [parent fillNotepad];
}


- (void) goUpTitlePage:(NSString *)lbl1:(NSString *)lbl2 {
    
    parent.navigationItem.rightBarButtonItem = nil;
    
    if ([hiddenTitle isEqual: titleView]) {
        titleLbl1.text = lbl1;
        titleLbl2.text = lbl2;
    } else {
        titleLbl21.text = lbl1;
        titleLbl22.text = lbl2;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [currentTitle removeFromSuperview];
    [self.view addSubview:hiddenTitle];
    [UIView commitAnimations];
    
    UIView *tempCurrent = currentTitle;
    currentTitle = hiddenTitle;
    hiddenTitle = tempCurrent;
}



- (void) goDownTitlePage:(NSString *)lbl1:(NSString *)lbl2 {
    
    parent.navigationItem.rightBarButtonItem = nil;
    
    if ([hiddenTitle isEqual: titleView]) {
        titleLbl1.text = lbl1;
        titleLbl2.text = lbl2;
    } else {
        titleLbl21.text = lbl1;
        titleLbl22.text = lbl2;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [currentTitle removeFromSuperview];
    [self.view addSubview:hiddenTitle];
    [UIView commitAnimations];
    
    UIView *tempCurrent = currentTitle;
    currentTitle = hiddenTitle;
    hiddenTitle = tempCurrent;
    
}


- (void)swipeUpAction:(UISwipeGestureRecognizer *)gestureRecognizer {
	
    if ((!theRoot.searching) && (!editing)) {
        
        
        if (!parent.isEmpty) {
            int row;
            int section;
            
            if (selectRow == -1) {
                //the it is a title pate
                
                //if there is something in the array
                if (([theRoot.elementsArray count] > 0) && (![[[theRoot.elementsArray objectAtIndex:0] objectAtIndex:0] isEqualToString:@" ~+~0000"])) {
                    
                    
                    
                    //UIView *tempCurrent = currentView;
                    //currentView = hiddenView;
                    //hiddenView = tempCurrent;
                    
                    
                    [theRoot tableView:theRoot.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                    [theRoot.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    
                } else {
                    //go from titlepage to cardboard
                    [self emptyPages];
                    emptyNote = YES;
                    
                    [self performSelector:@selector(emptyPages) withObject:nil afterDelay:.8];
                    hiddenView.alpha = 0;
                    currentView.alpha = 0;
                    [self goDownPage:self];
                    emptyNote = NO;
                    parent.isEmpty = YES;
                    parent.selectRow = 10000000;
                    parent.selectSection = 100000000;
                    selectRow = 1000000;
                    selectSection = 10000000;
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                    [currentTitle removeFromSuperview];
                    [UIView commitAnimations];
                    
                    UIView *tempCurrent = currentView;
                    currentView = hiddenView;
                    hiddenView = tempCurrent;
                    
                    parent.navigationItem.rightBarButtonItem = nil;
                }
                
                //if it is the last row in a section
            } else if ([[theRoot.elementsArray objectAtIndex:selectSection-1] count]==selectRow+1) {
                
                hiddenView.alpha = 1;
                currentView.alpha = 1;
                
                if ([theRoot.elementsArray count] != selectSection) {
                    
                    emptyNote = NO;
                    row = 0;
                    
                    section = selectSection+1;
                    [theRoot tableView:theRoot.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                    [theRoot.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    
                } else {
                    [self lastPage];
                }
                
            } else {
                
                row = selectRow+1;
                section = selectSection;
                [theRoot tableView:theRoot.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                [theRoot.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                
            }
        }
    }
}


- (void) lastPage {
    
    emptyNote = YES;
    [self performSelector:@selector(emptyPages) withObject:nil afterDelay:.8];
    hiddenView.alpha = 0;
    [self goDownPage:self];
    emptyNote = NO;
    parent.isEmpty = YES;
    parent.selectRow = 10000000;
    parent.selectSection = 100000000;
    selectRow = 1000000;
    selectSection = 10000000;
    [theRoot.tableView deselectRowAtIndexPath:[theRoot.tableView indexPathForSelectedRow] animated:YES];
}


- (void)swipeDownAction:(UISwipeGestureRecognizer *)gestureRecognizer {
	
    [self swipeDown];
    
}

- (void)swipeDown {
    if ((!theRoot.searching) && (!editing)){
    
    
    int row;
    int section;
    
    if (parent.isEmpty) {
        
        
        if (([theRoot.elementsArray count] > 0) && (![[[theRoot.elementsArray objectAtIndex:0] objectAtIndex:0] isEqualToString:@" ~+~0000"])) {
        
        //if it is the empty cardboard, select the last item on the list
        parent.isEmpty = NO;
        emptyNote = NO;
        
        section = [theRoot.elementsArray count];
        row = [[theRoot.elementsArray objectAtIndex:section-1] count]-1;
        
        
        [theRoot tableView:theRoot.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        [theRoot.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
       
        //else straight from cardboard to cover
        } else {
           
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
            [currentView removeFromSuperview];
            [self.view addSubview:hiddenTitle];
            [UIView commitAnimations];
            
            
            parent.isEmpty = NO;
            selectRow = -1;
            selectSection = 0;
            parent.selectRow = -1;
            parent.selectSection = 0;
            
            parent.navigationItem.rightBarButtonItem = nil;
        }
        
    } else {
        
        
        
        //if it is the first row in a section
        if (selectRow-1<0) {
            if ((selectSection-1 != 0) && (selectRow != -1)) {
                row = [[theRoot.elementsArray objectAtIndex:selectSection-2]count]-1;
                section = selectSection-1;
                //[parent fillNotepad];
                [theRoot tableView:theRoot.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                [theRoot.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
           
                //else if it is the top item in the list, flip down the coverPage
            } else if (selectRow != -1) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:1.0];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
                [currentView removeFromSuperview];
                [self.view addSubview:currentTitle];
                [UIView commitAnimations];
                
                parent.selectRow = -1;
                parent.selectSection = 0;
                selectRow = -1;
                selectSection = 0;
                
                UIView *tempCurrent = currentView;
                currentView = hiddenView;
                hiddenView = tempCurrent;
                
                [theRoot.tableView deselectRowAtIndexPath:[theRoot.tableView indexPathForSelectedRow] animated:YES];
                isTitle = YES;
                [parent.navigationItem setRightBarButtonItem:nil];
                
                 [parent.navigationItem setRightBarButtonItem:nil];
                
            }
        } else {
            
            row = selectRow-1;
            section = selectSection;
            [theRoot tableView:theRoot.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [theRoot.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
        }
    }
    }
}



- (void) assignHiddenValues {
    
    //ContactName~+~Phone Number 1~+~Phone Number 2~+~Email Address~+~Street~+~City~+~State'
    //Zip Code~+~Title~+~Notes~+~LocalFax~+~Weblink~+~CompanyName~+~City~+~State~+~ZipCode'];
    //Country~+~'Website~+~companyID
    
    
    //fetch contact info
    NSString *linksStrLink = [NSString stringWithFormat:@"http://%@/GetContactInformation.php?mUser=%@&mPassword=%@&contactID=%@",
                              [theRoot.serverInfo objectAtIndex:0],
                              [theRoot.serverInfo objectAtIndex:3],
                              [theRoot.serverInfo objectAtIndex:4],
                              contactID];
    
    NSError *error;
    
    //returns with the Link~+~Description
    NSString *linksStr = [NSString stringWithContentsOfURL: 
                          [NSURL URLWithString:
                           linksStrLink]
                                                  encoding:NSASCIIStringEncoding error:&error];
    
    NSArray *temp = [linksStr componentsSeparatedByString:@"~+~"];
    
    companyID = [temp objectAtIndex:19];
    [companyID retain];
    
    if ([hiddenView isEqual:topView]) {
        
        contactName.text    = [temp objectAtIndex:0];
        officePhone.text    = [temp objectAtIndex:1];
        mobilePhone.text    = [temp objectAtIndex:2];
        email.text          = [temp objectAtIndex:3];
        contactTitle.text   = [temp objectAtIndex:8];
        notes.text          = [temp objectAtIndex:9];
        fax.text            = [temp objectAtIndex:10];
        NSString *tempweb;
        
        if ([[temp objectAtIndex:11] rangeOfString:@"#"].location != NSNotFound) {
            tempweb = [[temp objectAtIndex:11] substringFromIndex:[[temp objectAtIndex:11] rangeOfString:@"#"].location+1];
        } else {
            tempweb = [temp objectAtIndex:11];
        }
        
        if ([tempweb rangeOfString:@"#"].location != NSNotFound) {
            contactWebsite.text   = [tempweb substringToIndex:[tempweb rangeOfString:@"#"].location];
            
        } else {
            contactWebsite.text   = tempweb;
            
        }
        companyName.text    = [temp objectAtIndex:12];
        compAddress1.text   = [temp objectAtIndex:12];
        compAddress2.text   = [temp objectAtIndex:13];
        NSString *add1 = [temp objectAtIndex:14];
        NSString *add2 = [temp objectAtIndex:15];
        
        if ((add1.length > 0)&&(add2.length >0)) {
            compAddress3.text = [NSString stringWithFormat:@"%@, %@", 
                                 add1, add2];
        } else if (add1.length > 0) {
            compAddress3.text = add1;
        } else {
            compAddress3.text = add2;
        }

        compAddress4.text   = [temp objectAtIndex:16];
        compAddress5.text   = [temp objectAtIndex:17];
        
        
        if ([[temp objectAtIndex:18] rangeOfString:@"#"].location != NSNotFound) {
            tempweb = [[temp objectAtIndex:18] substringFromIndex:[[temp objectAtIndex:18] rangeOfString:@"#"].location+1];
        } else {
            tempweb = [temp objectAtIndex:18];
        }
        
        if ([tempweb rangeOfString:@"#"].location != NSNotFound) {
            compWebsite.text    = [tempweb substringToIndex:[tempweb rangeOfString:@"#"].location];
            
        } else {
            compWebsite.text    = tempweb;
            
        }

        
        
    } else {
        
        contactName2.text    = [temp objectAtIndex:0];
        officePhone2.text    = [temp objectAtIndex:1];
        mobilePhone2.text    = [temp objectAtIndex:2];
        email2.text          = [temp objectAtIndex:3];
        contactTitle2.text   = [temp objectAtIndex:8];
        notes2.text          = [temp objectAtIndex:9];
        fax2.text            = [temp objectAtIndex:10];
        
        NSString *tempweb;
        
        if ([[temp objectAtIndex:11] rangeOfString:@"#"].location != NSNotFound) {
            tempweb = [[temp objectAtIndex:11] substringFromIndex:[[temp objectAtIndex:11] rangeOfString:@"#"].location+1];
        } else {
            tempweb = [temp objectAtIndex:11];
        }
        
        if ([tempweb rangeOfString:@"#"].location != NSNotFound) {
            contactWebsite2.text   = [tempweb substringToIndex:[tempweb rangeOfString:@"#"].location];
            
        } else {
            contactWebsite2.text   = tempweb;
            
        }
        
        
        companyName2.text    = [temp objectAtIndex:12];
        compAddress12.text   = [temp objectAtIndex:12];
        compAddress22.text   = [temp objectAtIndex:13];
        NSString *add1 = [temp objectAtIndex:14];
        NSString *add2 = [temp objectAtIndex:15];
        
        if ((add1.length > 0)&&(add2.length >0)) {
            compAddress32.text = [NSString stringWithFormat:@"%@, %@", 
                                 add1, add2];
        } else if (add1.length > 0) {
            compAddress32.text = add1;
        } else {
            compAddress32.text = add2;
        }
        
        compAddress42.text   = [temp objectAtIndex:16];
        compAddress52.text   = [temp objectAtIndex:17];
        
        
        if ([[temp objectAtIndex:18] rangeOfString:@"#"].location != NSNotFound) {
           tempweb = [[temp objectAtIndex:18] substringFromIndex:[[temp objectAtIndex:18] rangeOfString:@"#"].location+1];
        } else {
            tempweb = [temp objectAtIndex:18];
        }
        
        if ([tempweb rangeOfString:@"#"].location != NSNotFound) {
            compWebsite2.text    = [tempweb substringToIndex:[tempweb rangeOfString:@"#"].location];

        } else {
            compWebsite2.text    = tempweb;

        }
        
                
    }
}


- (IBAction) masterPushed: (id)sender {
	[theRoot turnOffDetailSwipe];
    RootViewController *temp = [[theRoot.navigationController viewControllers] objectAtIndex:0];
	temp.title = @"";
	[theRoot.navigationController popToViewController:[[theRoot.navigationController viewControllers] objectAtIndex:0] animated:YES];
	[parent.navigationController popToViewController:[[parent.navigationController viewControllers]
													objectAtIndex:0] animated:YES];
}




- (IBAction) sendEmail:(id)sender {
    
    if (currentView == topView) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", email.text]]];

    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", email2.text]]];

    }
}

- (IBAction) goToCompSite:(id)sender {
    if (currentView == topView) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:compWebsite.text]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:compWebsite2.text]];
        
    }
}



- (IBAction) goToContactSite:(id)sender {
    
    if (currentView == topView) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactWebsite.text]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactWebsite2.text]];
        
    }
}

//********************************Edit Things****************************************************

- (void)editAction {
   
    if(!editing) {
        editing = YES;
        scrollView.scrollEnabled = YES;
        scrollView2.scrollEnabled = YES;
        chooseCompBtn.enabled = YES;
        chooseCompBtn2.enabled = YES;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(editAction)];
        
        [parent.navigationItem setRightBarButtonItem:doneButton];
        [doneButton release];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
        
        [parent.navigationItem setLeftBarButtonItem:cancelButton];
        [cancelButton release];

        
          [self makeEditScene];
        
        //when begin editing, scroll to make the selected field visible over the keyboard.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reposition) name:UITextViewTextDidBeginEditingNotification object:nil];
        
    }else {
        
        if (((contactNameTxt.text.length > 1) && [currentView isEqual:topView]) ||
            ((contactNameTxt2.text.length > 1) && (![currentView isEqual:topView]))){
            
            
            //need to scroll to the top
            [scrollView setContentOffset:CGPointZero animated:NO];
            [scrollView2 setContentOffset:CGPointZero animated:NO];
            
            editing = NO;
            scrollView2.scrollEnabled = NO;
            scrollView.scrollEnabled = NO;
            chooseCompBtn.enabled = NO;
            chooseCompBtn2.enabled = NO;
            
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:parent action:@selector(editButtonAction:)];
            
            [parent.navigationItem setRightBarButtonItem:editButton];
            [editButton release];
            
            
            UIBarButtonItem *returnToSwitchBtn = [[UIBarButtonItem alloc] initWithTitle:@"Return to Switchboard" style:UIBarButtonItemStyleBordered target:self action:@selector(masterPushed:)];
            
            [parent.navigationItem setLeftBarButtonItem:returnToSwitchBtn];
            [returnToSwitchBtn release];
            
            
            [self removeEditScene:NO];
            [self dismissKeyboard];
            
            //send new info to DB and send new name to theRoot.
            
            //fetch contact info
            NSString *editContactInfo; 
            
            if ([currentView isEqual:topView]) {
                
                NSString *info1 = [self cleanString:notes.text];
                NSString *info2 = [self cleanString:contactNameTxt.text];
                NSString *info3 = [self cleanString:contactTitleTxt.text];
                NSString *info4 = [self cleanString:emailTxt.text];
                NSString *info5 = [self cleanString:officePhoneTxt.text];
                NSString *info6 = [self cleanString:mobilePhoneTxt.text];
                NSString *info7 = [self cleanString:faxTxt.text];
                NSString *info8 = [self cleanString:contactWebsiteTxt.text];
                
                editContactInfo = [NSString stringWithFormat:@"http://%@/EditContactInformation.php?mUser=%@&mPassword=%@&contactID=%@&notes=%@&contactName=%@&contactTitle=%@&companyID=%@&email=%@&officePhone=%@&mobilePhone=%@&fax=%@&contactWebsite=%@",
                                   [theRoot.serverInfo objectAtIndex:0],
                                   [theRoot.serverInfo objectAtIndex:3],
                                   [theRoot.serverInfo objectAtIndex:4],
                                   contactID,
                                   info1,
                                   info2,
                                   info3,
                                   companyID,
                                   info4,
                                   info5,
                                   info6,
                                   info7,
                                   info8];
                
            } else {
                
                
                
                
                NSString *info1 = [self cleanString:notes2.text];
               
               
                NSString *info2 = [self cleanString:contactNameTxt2.text];
               
               
                
                NSString *info3 = [self cleanString:contactTitleTxt2.text];
               
               
                NSString *info4 = [self cleanString:emailTxt2.text];
               
                NSString *info5 = [self cleanString:officePhoneTxt2.text];
               
                NSString *info6 = [self cleanString:mobilePhoneTxt2.text];
               
                NSString *info7 = [self cleanString:faxTxt2.text];
               
                NSString *info8 = [self cleanString:contactWebsiteTxt2.text];
               
                
                editContactInfo = [NSString stringWithFormat:@"http://%@/EditContactInformation.php?mUser=%@&mPassword=%@&contactID=%@&notes=%@&contactName=%@&contactTitle=%@&companyID=%@&email=%@&officePhone=%@&mobilePhone=%@&fax=%@&contactWebsite=%@",
                                   [theRoot.serverInfo objectAtIndex:0],
                                   [theRoot.serverInfo objectAtIndex:3],
                                   [theRoot.serverInfo objectAtIndex:4],
                                   contactID,
                                   info1,
                                   info2,
                                   info3,
                                   companyID,
                                   info4,
                                   info5,
                                   info6,
                                   info7,
                                   info8];
            }
            
            
            
            NSError *error;
            
            
            //returns with the Link~+~Description
            NSString *editInfo = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   editContactInfo] encoding:NSASCIIStringEncoding error:&error];
            
        } else {
            //Make a popup saying that there must be a contact name
          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Contact Name" 
                                                            message:@"Contact Name must be at least one character long."
                                                           delegate:self 
                                                  cancelButtonTitle:@"Okay" 
                                                  otherButtonTitles: nil];	
            [alert show];
            [alert release];
        }
        
    }
    
}


- (NSString *) cleanString: (NSString *)theNotes {
    
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
    
    return  fullfinalDesc17;
    
}


- (void)cancelButtonAction:(id)sender {
    
    
    //need to scroll to the top
    [scrollView setContentOffset:CGPointZero animated:NO];
    [scrollView2 setContentOffset:CGPointZero animated:NO];
    
    editing = NO;
    scrollView2.scrollEnabled = NO;
    scrollView.scrollEnabled = NO;
   
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:parent action:@selector(editButtonAction:)];
    
    [parent.navigationItem setRightBarButtonItem:editButton];
    [editButton release];
    
    
    UIBarButtonItem *returnToSwitchBtn = [[UIBarButtonItem alloc] initWithTitle:@"Return to Switchboard" style:UIBarButtonItemStyleBordered target:self action:@selector(masterPushed:)];
    
    [parent.navigationItem setLeftBarButtonItem:returnToSwitchBtn];
    [returnToSwitchBtn release];
    
    
    
    [self removeEditScene:YES];
    [self dismissKeyboard];
}


- (void)reposition {
    [scrollView setContentOffset:CGPointMake(0, 300) animated:YES];
    [scrollView2 setContentOffset:CGPointMake(0, 300) animated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    editingText = textField;
    
    if ([editingText isEqual:compAddress1Txt] || [editingText isEqual:compAddress1Txt2]) {
    [scrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    [scrollView2 setContentOffset:CGPointMake(0, 90) animated:YES];
    
    }else if ([editingText isEqual:compAddress3Txt] || [editingText isEqual:compAddress3Txt2]) {
        [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
        [scrollView2 setContentOffset:CGPointMake(0, 160) animated:YES];
   } else if ([editingText isEqual:compAddress2Txt] || [editingText isEqual:compAddress2Txt2] ||
              [editingText isEqual:compAddress1Txt] || [editingText isEqual:compAddress1Txt2]) {
       [scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
       [scrollView2 setContentOffset:CGPointMake(0, 120) animated:YES];
   } else if ([editingText isEqual:compAddress4Txt] || [editingText isEqual:compAddress4Txt2]) {
        [scrollView setContentOffset:CGPointMake(0, 180) animated:YES];
        [scrollView2 setContentOffset:CGPointMake(0, 180) animated:YES];
    } else if ([editingText isEqual:compAddress5Txt] || [editingText isEqual:compAddress5Txt2]) {
        [scrollView setContentOffset:CGPointMake(0, 190) animated:YES];
        [scrollView2 setContentOffset:CGPointMake(0, 190) animated:YES];
    } else if ([editingText isEqual:compWebsiteTxt] || [editingText isEqual:compWebsiteTxt2]) {
        [scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
        [scrollView2 setContentOffset:CGPointMake(0, 200) animated:YES];
    } else {
        [scrollView setContentOffset:CGPointZero animated:YES];
        [scrollView2 setContentOffset:CGPointZero animated:YES];
    }
}


- (IBAction)dismissKeyboard {
    [editingText resignFirstResponder];
}


- (IBAction)makeNotesEditable {
    
        
    if ([currentView isEqual:topView]) {
        enableText.alpha = 0;
        enableText.enabled = NO;
        notes.editable = YES;
    } else {
        enableText2.alpha = 0;
        enableText2.enabled = NO;
        notes2.editable = YES;
    }
    
}

- (void)makeEditScene {
    
    if ([currentView isEqual:topView]) {
        enableText.alpha = 1;
        enableText.enabled = YES;
        contactName.alpha=0;
        contactTitle.alpha=0;
        companyName.alpha=0;
        email.alpha=0;
        officePhone.alpha=0;
        mobilePhone.alpha=0;
        fax.alpha=0;
        contactWebsite.alpha=0;
        compAddress1.textColor = [UIColor darkGrayColor];
        compAddress2.textColor = [UIColor darkGrayColor];
        compAddress3.textColor = [UIColor darkGrayColor];
        compAddress4.textColor = [UIColor darkGrayColor];
        compAddress5.textColor = [UIColor darkGrayColor];
        compWebsite.textColor  = [UIColor darkGrayColor];
        
        emailBtn.alpha=0;
        contactSiteBtn.alpha=0;
        compSiteBtn.alpha=0;
        
        notesTxt.alpha = 1;
        nameLabellbl.alpha=.8;
        companyLabellbl.alpha=.8;
        titleLabellbl.alpha=.8;
        contactNameTxt.alpha=1;
        contactTitleTxt.alpha=1;
        companyNameTxt.alpha=1;
        emailTxt.alpha=1;
        officePhoneTxt.alpha=1;
        mobilePhoneTxt.alpha=1;
        faxTxt.alpha=1;
        contactWebsiteTxt.alpha=1;
       
        contactNameTxt.text=contactName.text;
        contactTitleTxt.text=contactTitle.text;
        companyNameTxt.text=companyName.text;
        emailTxt.text=email.text;
        officePhoneTxt.text=officePhone.text;
        mobilePhoneTxt.text=mobilePhone.text;
        faxTxt.text=fax.text;
        contactWebsiteTxt.text=contactWebsite.text;
       
        

    } else {
        enableText2.alpha = 1;
        enableText2.enabled = YES;
       
        contactName2.alpha=0;
        contactTitle2.alpha=0;
        companyName2.alpha=0;
        email2.alpha=0;
        officePhone2.alpha=0;
        mobilePhone2.alpha=0;
        fax2.alpha=0;
        contactWebsite2.alpha=0;
        compAddress12.textColor = [UIColor darkGrayColor];
        compAddress22.textColor = [UIColor darkGrayColor];
        compAddress32.textColor = [UIColor darkGrayColor];
        compAddress42.textColor = [UIColor darkGrayColor];
        compAddress52.textColor = [UIColor darkGrayColor];
        compWebsite2.textColor  = [UIColor darkGrayColor];
        
        emailBtn2.alpha=0;
        contactSiteBtn2.alpha=0;
        compSiteBtn2.alpha=0;
        
        notesTxt2.alpha=1;
        nameLabellbl2.alpha=.8;
        companyLabellbl2.alpha=.8;
        titleLabellbl2.alpha=.8;
        contactNameTxt2.alpha=1;
        contactTitleTxt2.alpha=1;
        companyNameTxt2.alpha=1;
        emailTxt2.alpha=1;
        officePhoneTxt2.alpha=1;
        mobilePhoneTxt2.alpha=1;
        faxTxt2.alpha=1;
        contactWebsiteTxt2.alpha=1;
        
      
        contactNameTxt2.text=contactName2.text;
        contactTitleTxt2.text=contactTitle2.text;
        companyNameTxt2.text=companyName2.text;
        emailTxt2.text=email2.text;
        officePhoneTxt2.text=officePhone2.text;
        mobilePhoneTxt2.text=mobilePhone2.text;
        faxTxt2.text=fax2.text;
        contactWebsiteTxt2.text=contactWebsite2.text;
      
        
    }
    
}


- (void)removeEditScene:(BOOL)fromCancel {
    notes.editable = NO;
    
    if ([currentView isEqual:topView]) {
        
        if (!fromCancel) {
            //assign all the labels to be the textfield values
            contactName.text = contactNameTxt.text;
            contactTitle.text = contactTitleTxt.text;
            companyName.text = companyNameTxt.text;
            email.text = emailTxt.text;
            officePhone.text = officePhoneTxt.text;
            mobilePhone.text = mobilePhoneTxt.text;
            fax.text = faxTxt.text;
            contactWebsite.text =  contactWebsiteTxt.text;           
        }

        enableText.alpha = 0;
        enableText.enabled = NO;
        notes.editable = NO;
        contactName.alpha=1;
        contactTitle.alpha=1;
        companyName.alpha=1;
        email.alpha=1;
        officePhone.alpha=1;
        mobilePhone.alpha=1;
        fax.alpha=1;
        contactWebsite.alpha=1;
        compAddress1.textColor = [UIColor blackColor];
        compAddress2.textColor = [UIColor blackColor];
        compAddress3.textColor = [UIColor blackColor];
        compAddress4.textColor = [UIColor blackColor];
        compAddress5.textColor = [UIColor blackColor];
        compWebsite.textColor  = [UIColor blackColor];
        
        emailBtn.alpha=1;
        contactSiteBtn.alpha=1;
        compSiteBtn.alpha=1;
        
        notesTxt.alpha=0;
        nameLabellbl.alpha=0;
        companyLabellbl.alpha=0;
        titleLabellbl.alpha=0;
        contactNameTxt.alpha=0;
        contactTitleTxt.alpha=0;
        companyNameTxt.alpha=0;
        emailTxt.alpha=0;
        officePhoneTxt.alpha=0;
        mobilePhoneTxt.alpha=0;
        faxTxt.alpha=0;
        contactWebsiteTxt.alpha=0;
        
               
        
    } else {
        
        if (!fromCancel) {
            //assign all the labels to be the textfield values
            contactName2.text = contactNameTxt2.text;
            contactTitle2.text = contactTitleTxt2.text;
            companyName2.text = companyNameTxt2.text;
            email2.text = emailTxt2.text;
            officePhone2.text = officePhoneTxt2.text;
            mobilePhone2.text = mobilePhoneTxt2.text;
            fax2.text = faxTxt2.text;
            contactWebsite2.text =  contactWebsiteTxt2.text;           
        }
        
        notes2.editable = NO;
        enableText.alpha = 0;
        enableText.enabled = NO;
        contactName2.alpha=1;
        contactTitle2.alpha=1;
        companyName2.alpha=1;
        email2.alpha=1;
        officePhone2.alpha=1;
        mobilePhone2.alpha=1;
        fax2.alpha=1;
        contactWebsite2.alpha=1;
        compAddress12.textColor = [UIColor blackColor];
        compAddress22.textColor = [UIColor blackColor];
        compAddress32.textColor = [UIColor blackColor];
        compAddress42.textColor = [UIColor blackColor];
        compAddress52.textColor = [UIColor blackColor];
        compWebsite2.textColor  = [UIColor blackColor];
        
        emailBtn2.alpha=1;
        contactSiteBtn2.alpha=1;
        compSiteBtn2.alpha=1;
        
        notesTxt2.alpha=0;
        nameLabellbl2.alpha=0;
        companyLabellbl2.alpha=0;
        titleLabellbl2.alpha=0;
        contactNameTxt2.alpha=0;
        contactTitleTxt2.alpha=0;
        companyNameTxt2.alpha=0;
        emailTxt2.alpha=0;
        officePhoneTxt2.alpha=0;
        mobilePhoneTxt2.alpha=0;
        faxTxt2.alpha=0;
        contactWebsiteTxt2.alpha=0;
       
        
    }

}

- (IBAction) chooseCompany:(id)sender {
    
    
    WorkGroupTblView *wgTble = [[WorkGroupTblView alloc] init];
    wgTble.contactParent = self;
    wgTble.theRoot = theRoot;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:wgTble];
    
    [popoverController setPopoverContentSize:CGSizeMake(241, 590)];
    if ([currentView isEqual:topView]) {
   
        [popoverController presentPopoverFromRect:companyNameTxt.frame inView:currentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else { 
        [popoverController presentPopoverFromRect:companyNameTxt2.frame inView:currentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


- (void) NewCancelButtonAction {
    //flip the page up
    //select the last row that was selected
    
}

- (void) newEditAction {
    //should save the contact info
  
    if (((contactNameTxt.text.length > 1) && [currentView isEqual:topView]) ||
    ((contactNameTxt2.text.length > 1) && (![currentView isEqual:topView]))){
        
        //need to scroll to the top
        [scrollView setContentOffset:CGPointZero animated:NO];
        [scrollView2 setContentOffset:CGPointZero animated:NO];
        
        editing = NO;
        scrollView2.scrollEnabled = NO;
        scrollView.scrollEnabled = NO;
        chooseCompBtn.enabled = NO;
        chooseCompBtn2.enabled = NO;
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:parent action:@selector(editButtonAction:)];
        
        [parent.navigationItem setRightBarButtonItem:editButton];
        [editButton release];
        
        
        UIBarButtonItem *returnToSwitchBtn = [[UIBarButtonItem alloc] initWithTitle:@"Return to Switchboard" style:UIBarButtonItemStyleBordered target:self action:@selector(masterPushed:)];
        
        [parent.navigationItem setLeftBarButtonItem:returnToSwitchBtn];
        [returnToSwitchBtn release];
        
        
        [self removeEditScene:NO];
        [self dismissKeyboard];
        
        //send new info to DB and send new name to theRoot.
        
        //fetch contact info
        NSString *editContactInfo; 
        
        if ([currentView isEqual:topView]) {
            
          
            NSString *info1 = [self cleanString:notes.text];
            NSString *info2 = [self cleanString:contactNameTxt.text];
            NSString *info3 = [self cleanString:contactTitleTxt.text];
            NSString *info4 = [self cleanString:emailTxt.text];
            NSString *info5 = [self cleanString:officePhoneTxt.text];
            NSString *info6 = [self cleanString:mobilePhoneTxt.text];
            NSString *info7 = [self cleanString:faxTxt.text];
            NSString *info8 = [self cleanString:contactWebsiteTxt.text];
            
            
            NSString *infoComp;
            if (companyID) {
                infoComp=companyID;
            } else {
                infoComp = @"";
            }
            
            
            editContactInfo = [NSString stringWithFormat:@"http://%@/CreateNewContact.php?mUser=%@&mPassword=%@&notes=%@&contactName=%@&contactTitle=%@&companyID=%@&email=%@&officePhone=%@&mobilePhone=%@&fax=%@&contactWebsite=%@",
                               [theRoot.serverInfo objectAtIndex:0],
                               [theRoot.serverInfo objectAtIndex:3],
                               [theRoot.serverInfo objectAtIndex:4],
                               info1,
                               info2,
                               info3,
                               infoComp,
                               info4,
                               info5,
                               info6,
                               info7,
                               info8];
            
        } else {
            
            NSString *info1 = [self cleanString:notes2.text];
            NSString *info2 = [self cleanString:contactNameTxt2.text];
            NSString *info3 = [self cleanString:contactTitleTxt2.text];
            NSString *info4 = [self cleanString:emailTxt2.text];
            NSString *info5 = [self cleanString:officePhoneTxt2.text];
            NSString *info6 = [self cleanString:mobilePhoneTxt2.text];
            NSString *info7 = [self cleanString:faxTxt2.text];
            NSString *info8 = [self cleanString:contactWebsiteTxt2.text];
            NSString *infoComp;
            if (companyID) {
                infoComp=companyID;
            } else {
                infoComp = @"";
            }
            
            
            
            editContactInfo = [NSString stringWithFormat:@"http://%@/CreateNewContact.php?mUser=%@&mPassword=%@&notes=%@&contactName=%@&contactTitle=%@&companyID=%@&email=%@&officePhone=%@&mobilePhone=%@&fax=%@&contactWebsite=%@",
                               [theRoot.serverInfo objectAtIndex:0],
                               [theRoot.serverInfo objectAtIndex:3],
                               [theRoot.serverInfo objectAtIndex:4],
                               info1,
                               info2,
                               info3,
                               infoComp,
                               info4,
                               info5,
                               info6,
                               info7,
                               info8];
        }
        
                
        NSError *error;
       
        //returns with the Link~+~Description
        NSString *editInfo = [NSString stringWithContentsOfURL: 
                              [NSURL URLWithString:
                               editContactInfo] encoding:NSASCIIStringEncoding error:&error];
        
               
        //reload the table to be the last query that was made
        [theRoot updateTableWithLU];
        
        //select the row that contains the new person
        NSIndexPath *test = [theRoot getElementsDividedIndexOfStringContaining:editInfo:1];
        //maybe first get row and then section or something
        
        if (test) {
            
            selectRow = test.row;
            selectSection = test.section;
            [theRoot.tableView selectRowAtIndexPath:test animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
        
    } else {
        //Make a popup saying that there must be a contact name
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Contact Name" 
                                                        message:@"Contact Name must be at least one character long."
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles: nil];	
        [alert show];
        [alert release];
    }
    

    
   
}


- (void) createNewContact {
    
    editing = YES;
    scrollView.scrollEnabled = YES;
    scrollView2.scrollEnabled = YES;
    chooseCompBtn.enabled = YES;
    chooseCompBtn2.enabled = YES;
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(newEditAction)];
    
    [parent.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(NewCancelButtonAction)];
    
    [parent.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    //when begin editing, scroll to make the selected field visible over the keyboard.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reposition) name:UITextViewTextDidBeginEditingNotification object:nil];


    if (![currentView isEqual:topView]) {
       
        enableText.alpha = 1;
        enableText.enabled = YES;
        contactName.alpha=0;
        contactTitle.alpha=0;
        companyName.alpha=0;
        email.alpha=0;
        officePhone.alpha=0;
        mobilePhone.alpha=0;
        fax.alpha=0;
        contactWebsite.alpha=0;
        compAddress1.textColor = [UIColor darkGrayColor];
        compAddress2.textColor = [UIColor darkGrayColor];
        compAddress3.textColor = [UIColor darkGrayColor];
        compAddress4.textColor = [UIColor darkGrayColor];
        compAddress5.textColor = [UIColor darkGrayColor];
        compWebsite.textColor  = [UIColor darkGrayColor];
        
        emailBtn.alpha=0;
        contactSiteBtn.alpha=0;
        compSiteBtn.alpha=0;
        
        notesTxt.alpha = 1;
        nameLabellbl.alpha=.8;
        companyLabellbl.alpha=.8;
        titleLabellbl.alpha=.8;
        contactNameTxt.alpha=1;
        contactTitleTxt.alpha=1;
        companyNameTxt.alpha=1;
        emailTxt.alpha=1;
        officePhoneTxt.alpha=1;
        mobilePhoneTxt.alpha=1;
        faxTxt.alpha=1;
        contactWebsiteTxt.alpha=1;
        
        notes.text = @"";        
        contactNameTxt.text=@"";
        contactTitleTxt.text=@"";
        companyNameTxt.text=@"";
        emailTxt.text=@"";
        officePhoneTxt.text=@"";
        mobilePhoneTxt.text=@"";
        faxTxt.text=@"";
        contactWebsiteTxt.text=@"";
        compAddress1.text=@"";
        compAddress2.text=@"";
        compAddress3.text=@"";
        compAddress4.text=@"";
        compAddress5.text=@"";
        compWebsite.text=@"";
        
        
        
    } else {
        enableText2.alpha = 1;
        enableText2.enabled = YES;
      
        contactName2.alpha=0;
        contactTitle2.alpha=0;
        companyName2.alpha=0;
        email2.alpha=0;
        officePhone2.alpha=0;
        mobilePhone2.alpha=0;
        fax2.alpha=0;
        contactWebsite2.alpha=0;
        compAddress12.textColor = [UIColor darkGrayColor];
        compAddress22.textColor = [UIColor darkGrayColor];
        compAddress32.textColor = [UIColor darkGrayColor];
        compAddress42.textColor = [UIColor darkGrayColor];
        compAddress52.textColor = [UIColor darkGrayColor];
        compWebsite2.textColor  = [UIColor darkGrayColor];
        
        emailBtn2.alpha=0;
        contactSiteBtn2.alpha=0;
        compSiteBtn2.alpha=0;
        
        notesTxt2.alpha=1;
        nameLabellbl2.alpha=.8;
        companyLabellbl2.alpha=.8;
        titleLabellbl2.alpha=.8;
        contactNameTxt2.alpha=1;
        contactTitleTxt2.alpha=1;
        companyNameTxt2.alpha=1;
        emailTxt2.alpha=1;
        officePhoneTxt2.alpha=1;
        mobilePhoneTxt2.alpha=1;
        faxTxt2.alpha=1;
        contactWebsiteTxt2.alpha=1;
        
        notes2.text = @"";
        contactNameTxt2.text=@"";
        contactTitleTxt2.text=@"";
        companyNameTxt2.text=@"";
        emailTxt2.text=@"";
        officePhoneTxt2.text=@"";
        mobilePhoneTxt2.text=@"";
        faxTxt2.text=@"";
        contactWebsiteTxt2.text=@"";
        compAddress12.text=@"";
        compAddress22.text=@"";
        compAddress32.text=@"";
        compAddress42.text=@"";
        compAddress52.text=@"";
        compWebsite2.text=@"";
       
       
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [currentView removeFromSuperview];
    [self.view addSubview:hiddenView];
    [UIView commitAnimations];
    
    UIView *tempCurrent = currentView;
    currentView = hiddenView;
    hiddenView = tempCurrent;
    [self performSelector:@selector(fillPages) withObject:nil afterDelay:.8];
    
    if ([currentView isEqual:topView]) {
        [contactNameTxt becomeFirstResponder];
    } else {
        [contactNameTxt2 becomeFirstResponder];
    }
    
    //and deselect row in table
    [theRoot.tableView deselectRowAtIndexPath:[theRoot.tableView indexPathForSelectedRow] animated:YES];
}



- (void) updateCompany:(NSString *)str {
    [popoverController dismissPopoverAnimated:YES];
    [popoverController release];
    
    NSRange separator = [str rangeOfString:@"~+~"];
    //set the company label to read the correct name
    
    //set the companyID to this id
    companyID = [str substringFromIndex:separator.location+3];
    [companyID retain];
    
    //query for the rest of the company information and change them
    //on the form
    
    //fetch contact info
    NSString *getCompanyInfo = [NSString stringWithFormat:@"http://%@/GetCompanyInfo.php?mUser=%@&mPassword=%@&companyID=%@",
                                 [theRoot.serverInfo objectAtIndex:0],
                                 [theRoot.serverInfo objectAtIndex:3],
                                 [theRoot.serverInfo objectAtIndex:4],
                                 companyID];
    
    NSError *error;
    
    //Address~+~City~+~State~+~ZipCode~+~Country~+~Website
    NSString *companyInfo = [NSString stringWithContentsOfURL: 
                          [NSURL URLWithString:
                           getCompanyInfo] encoding:NSASCIIStringEncoding error:&error];
    
    NSArray *temp = [companyInfo componentsSeparatedByString:@"~+~"];
    if ([currentView isEqual:topView]) {
        companyNameTxt.text = [str substringToIndex:separator.location];
        compAddress1.text = [str substringToIndex:separator.location];
        compAddress2.text = [temp objectAtIndex:0];
        NSString *add1 = [temp objectAtIndex:1];
        NSString *add2 = [temp objectAtIndex:2];
        
       
        if ((add1.length > 0)&&(add2.length >0)) {
            compAddress3.text = [NSString stringWithFormat:@"%@, %@", 
                                 [temp objectAtIndex:1], [temp objectAtIndex:2]];
        } else if (add1.length > 0) {
            compAddress3.text = add1;
        } else {
            compAddress3.text = add2;
        }
        compAddress4.text = [temp objectAtIndex:3];
        compAddress5.text = [temp objectAtIndex:4];
        
        NSString *tempweb;
        if ([[temp objectAtIndex:5] rangeOfString:@"#"].location != NSNotFound) {
            tempweb = [[temp objectAtIndex:5] substringFromIndex:[[temp objectAtIndex:5] rangeOfString:@"#"].location+1];
        } else {
            tempweb = [temp objectAtIndex:5];
        }
        
        if ([tempweb rangeOfString:@"#"].location != NSNotFound) {
            compWebsite.text    = [tempweb substringToIndex:[tempweb rangeOfString:@"#"].location];
            
        } else {
            compWebsite.text    = tempweb;
            
        }

    } else {
        companyNameTxt2.text = [str substringToIndex:separator.location];
        compAddress12.text = [str substringToIndex:separator.location];
        compAddress22.text = [temp objectAtIndex:0];
      
        NSString *add1 = [temp objectAtIndex:1];
        NSString *add2 = [temp objectAtIndex:2];
        
        if ((add1.length > 0)&&(add2.length >0)) {
            compAddress32.text = [NSString stringWithFormat:@"%@, %@", 
                                 [temp objectAtIndex:1], [temp objectAtIndex:2]];
        } else if (add1.length > 0) {
            compAddress32.text = add1;
        } else {
            compAddress32.text = add2;
        }

        compAddress42.text = [temp objectAtIndex:3];
        compAddress52.text = [temp objectAtIndex:4];
        
        NSString *tempweb;
        if ([[temp objectAtIndex:5] rangeOfString:@"#"].location != NSNotFound) {
            tempweb = [[temp objectAtIndex:5] substringFromIndex:[[temp objectAtIndex:5] rangeOfString:@"#"].location+1];
        } else {
            tempweb = [temp objectAtIndex:5];
        }
        
        if ([tempweb rangeOfString:@"#"].location != NSNotFound) {
            compWebsite2.text    = [tempweb substringToIndex:[tempweb rangeOfString:@"#"].location];
            
        } else {
            compWebsite2.text    = tempweb;
            
        }
    }
    
    
}

//***********************************************************************************************


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
