//
//  LinksTable.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/24/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class EventDetail_Proj;


@interface LinksTable : UIViewController {
    NSArray *elements;
    EventDetail_Proj *parent;
    IBOutlet UITableView *table;
 
    IBOutlet UIButton *addButton;
    IBOutlet UIImageView *doneLbl;
    RootViewController *theRoot;
    NSString *eventIDStr;
}
@property (nonatomic, retain) NSString *eventIDStr;
@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, retain) NSArray *elements;
@property (nonatomic, retain) EventDetail_Proj *parent;

- (IBAction) plusBtnPushed:(id)sender;
- (IBAction) doneBtnPushed:(id)sender;

@end
