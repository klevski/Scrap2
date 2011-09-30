//
//  DateFollowPopController.h
//  Scrap2
//
//  Created by Kelsey Levine on 4/27/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetail-Proj.h"


@interface DateFollowPopController : UIViewController {
	IBOutlet UIDatePicker	*picker;
	EventDetail_Proj		*parent;
    NSDate *startDate;
    BOOL forPrint;
    IBOutlet UIButton *doneBtn;
    NSDate *lastDate;
}
@property(nonatomic, retain) NSDate *lastDate;
@property(nonatomic, readwrite) BOOL forPrint;
@property(nonatomic, retain) NSDate *startDate;
@property(nonatomic, retain) IBOutlet UIDatePicker	*picker;
@property(nonatomic, retain) EventDetail_Proj		*parent;

- (IBAction) pickChange:(id)sender;
- (IBAction) donePressed:(id)sender;

@end
