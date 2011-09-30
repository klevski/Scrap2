//
//  ContactQuickViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/11/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ContactQuickViewController : UIViewController {
    NSString *contactID;
    BOOL needPush;
    RootViewController *theRoot;
    IBOutlet UITextField *cellText;
    IBOutlet UITextField *officeText;
    IBOutlet UITextField *emailText;
    IBOutlet UILabel *nameLbl;
}
@property (nonatomic, retain) IBOutlet UITextField *emailText;
@property (nonatomic, retain) IBOutlet UILabel *nameLbl;
@property (nonatomic, retain) IBOutlet UITextField *cellText;
@property (nonatomic, retain) IBOutlet UITextField *officeText;
@property (nonatomic, readwrite) BOOL needPush;
@property (nonatomic, retain) NSString *contactID;
@property (nonatomic, retain) RootViewController *theRoot;

- (IBAction) didPressEmail:(id)sender;
- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration;

@end
