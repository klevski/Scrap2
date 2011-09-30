//
//  DetailViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 4/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
	IBOutlet UIImageView *portImage;
	IBOutlet UIImageView *portImage2;
	IBOutlet UILabel *portImage3;
	IBOutlet UIImageView *landImage;
	IBOutlet UIImageView *landImage2;
	IBOutlet UILabel *landImage3;
    IBOutlet UIButton *logoutPortBtn;
    IBOutlet UIButton *logoutLandBtn;
	
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    id detailItem;
    UILabel *detailDescriptionLabel;
	UIViewController *master;
    BOOL enableDueRSwipe;
    BOOL enableDueLSwipe;
    RootViewController *theRoot;
    
    NSString *theTitle;

}

@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, readwrite) BOOL enableDueRSwipe;
@property (nonatomic, readwrite) BOOL enableDueLSwipe;
@property (nonatomic, retain) NSString *serverInfo;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) UIViewController *master;

- (void) setLandPortImage:(NSString *)image;
- (IBAction) logoutBtnPressed;
- (NSString *) getTitle;


@end
