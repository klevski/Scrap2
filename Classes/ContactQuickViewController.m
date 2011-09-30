//
//  ContactQuickViewController.m
//  Scrap2
//
//  Created by Kelsey Levine on 5/11/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "ContactQuickViewController.h"


@implementation ContactQuickViewController

@synthesize contactID, needPush, theRoot, cellText, officeText, nameLbl, emailText;


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


- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration{
    
	if(portrait){
   
        if (!needPush) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
            ContactQuickViewController *contactView = [[ContactQuickViewController alloc] initWithNibName:@"ContactQuickView" bundle:nil];
            contactView.theRoot = theRoot;
            contactView.needPush = NO;
            contactView.contactID = contactID;
            [[self navigationController] pushViewController:contactView animated:YES];
        }
        
    } else {
        if (!needPush) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
            ContactQuickViewController *contactView = [[ContactQuickViewController alloc] initWithNibName:@"ContactQuickViewLand" bundle:nil];
            contactView.theRoot = theRoot;
            contactView.needPush = NO;
            contactView.contactID = contactID;
            [[self navigationController] pushViewController:contactView animated:YES];
        }
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!needPush) {
        self.navigationItem.hidesBackButton = TRUE;
    }
    
    NSError *error;
    
    //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
    NSString *getUserInfo = [NSString stringWithFormat:@"http://%@/GetQuickContactInfo.php?mUser=%@&mPassword=%@&ContactID=%@", 
                               [[theRoot getServerInfo] objectAtIndex:0], 
                               [[theRoot getServerInfo] objectAtIndex:3],
                               [[theRoot getServerInfo] objectAtIndex:4], contactID];
                               
    NSString *info = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:
                         getUserInfo]
                        encoding:NSASCIIStringEncoding error:&error];
    
    
    //name~-~officephone~-~cellphone
    NSArray *infoArray = [info componentsSeparatedByString:@"~-~"];
    
    nameLbl.text = [infoArray objectAtIndex:0];
    cellText.text = [infoArray objectAtIndex:2];
    officeText.text = [infoArray objectAtIndex:1];
    emailText.text = [infoArray objectAtIndex:3];
}

- (IBAction) didPressEmail:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", emailText.text]]];
    
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
