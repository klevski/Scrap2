//
//  FullContactViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 6/22/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ContactPage.h"

@class ContactPage;

@interface FullContactViewController : UIViewController {
    
    RootViewController *theRoot;
    NSString *contactID;
    ContactPage *contact;
    
    IBOutlet UIView *topView;
    IBOutlet UIView *bottomView;
    IBOutlet UIImageView *image;
    int selectSection;
    int selectRow;
    IBOutlet UIImageView *onePage;
    IBOutlet UIImageView *twoPages;
    IBOutlet UIImageView *lotsPages;
    BOOL isEmpty;
    NSString *theTitle;
    
}
@property (nonatomic, readwrite) BOOL isEmpty;
@property (nonatomic, retain) ContactPage *contact;
@property (nonatomic, readwrite) int selectSection;
@property (nonatomic, readwrite) int selectRow;
@property (nonatomic, retain) NSString *contactID;
@property (nonatomic, retain) RootViewController *theRoot;

- (IBAction) nextPageBtnPressed:(id)sender;

@end


