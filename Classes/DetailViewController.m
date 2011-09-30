//
//  DetailViewController.m
//  Scrap2
//
//  Created by Kelsey Levine on 4/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"


@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, master;
@synthesize serverInfo, enableDueRSwipe, enableDueLSwipe, theRoot;


#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) {
       // [popoverController dismissPopoverAnimated:YES];
    }        
}

- (void) setLandPortImage: (NSString *)image {
	
	if ([image isEqualToString:@"port"]) {
        NSLog(@"righthere");
		portImage.alpha  = 1;
		portImage2.alpha = 1;
		portImage3.alpha = 1;
        logoutPortBtn.alpha = 1;
        logoutLandBtn.enabled = YES;
        
        logoutLandBtn.alpha = 0;
        logoutLandBtn.enabled = NO;
		landImage.alpha  = 0;
		landImage2.alpha = 0;
		landImage3.alpha = 0;
	} else {
        NSLog(@"or here");
		portImage.alpha  = 0;
		portImage2.alpha = 0;
		portImage3.alpha = 0;
        logoutPortBtn.alpha = 0;
        logoutLandBtn.enabled = NO;
        
        logoutLandBtn.alpha = 1;
        logoutLandBtn.enabled = YES;
		landImage.alpha  = 1;
		landImage2.alpha = 1;
		landImage3.alpha = 1;
	}

	
}

- (void)configureView {
    // Update the user interface for the detail item.
    detailDescriptionLabel.text = [detailItem description];   
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	[barButtonItem setTitle:@"Menu"];
	[[self navigationItem] setLeftBarButtonItem:barButtonItem];
	[self setPopoverController:pc];
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        //Ripple
        portImage.alpha  = 1;
        //riseline
		portImage2.alpha = 1;
        //copyright
		portImage3.alpha = 1;
        logoutPortBtn.alpha = 1;
        logoutLandBtn.enabled = YES;
        
        logoutLandBtn.alpha = 0;
        logoutLandBtn.enabled = NO;
        //ripple
		landImage.alpha  = 0;
        //riseline
		landImage2.alpha = 0;
        //copyright
		landImage3.alpha = 0;
		
    }
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        //ripple
        portImage.alpha  = 0;
        //riseline
		portImage2.alpha = 0;
        //copyright
		portImage3.alpha = 0;
        logoutPortBtn.alpha = 0;
        logoutLandBtn.enabled = NO;
        
        logoutLandBtn.alpha = 1;
        logoutLandBtn.enabled = YES;
        //ripple
		landImage.alpha  = 1;
        //riseline
		landImage2.alpha = 1;
        //copyright
		landImage3.alpha = 1;
		
    }
}



#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"";
	
  
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIInterfaceOrientation orientation = [UIDevice currentDevice].orientation;
    
    BOOL isPort = (orientation == UIInterfaceOrientationPortrait || 
				   orientation == UIInterfaceOrientationPortraitUpsideDown);

	
	if (isPort) {
        NSLog(@"port");
        //Ripple
        portImage.alpha  = 1;
        //riseline
		portImage2.alpha = 1;
        //copyright
		portImage3.alpha = 1;
        logoutPortBtn.alpha = 1;
        logoutLandBtn.enabled = YES;
        
        logoutLandBtn.alpha = 0;
        logoutLandBtn.enabled = NO;
        //ripple
		landImage.alpha  = 0;
        //riseline
		landImage2.alpha = 0;
        //copyright
		landImage3.alpha = 0;
		

	} else {
        NSLog(@"not port");
        //ripple
        portImage.alpha  = 0;
        //riseline
		portImage2.alpha = 0;
        //copyright
		portImage3.alpha = 0;
        logoutPortBtn.alpha = 0;
        logoutLandBtn.enabled = NO;
        
        logoutLandBtn.alpha = 1;
        logoutLandBtn.enabled = YES;
        //ripple
		landImage.alpha  = 1;
        //riseline
		landImage2.alpha = 1;
        //copyright
		landImage3.alpha = 1;
	}

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[self.view addGestureRecognizer:swipeLeft];
	
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[self.view addGestureRecognizer:swipeRight];
	
}

- (IBAction) logoutBtnPressed {
    exit(1);
}

- (NSString *) getServerInfo {

	return serverInfo;
	
}

- (void)swipeRightAction:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (enableDueRSwipe) {
        if (([theRoot.elementsArray count]>0)&&(![[theRoot.elementsArray objectAtIndex:0] isEqualToString:@""])) {
            [theRoot rightSwipe:[NSIndexPath indexPathForRow:[theRoot.elementsArray count] inSection:0]:YES];
        }
    }
}



- (void)swipeLeftAction:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (enableDueLSwipe) {
        if (([theRoot.elementsArray count]>0)&&(![[theRoot.elementsArray objectAtIndex:0] isEqualToString:@""])) {
            [theRoot leftSwipe:[NSIndexPath indexPathForRow:1 inSection:0]:YES];
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

- (NSString *)uploadData:(NSURL *)url {
    
    return [NSString stringWithFormat:@"http://%@/CreateNewDocument.php?mUser=%@&mPassword=%@",
                                  [theRoot.serverInfo objectAtIndex:0],
                                  [theRoot.serverInfo objectAtIndex:3],
                                  [theRoot.serverInfo objectAtIndex:4]];
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [detailDescriptionLabel release];
    [super dealloc];
}

@end
