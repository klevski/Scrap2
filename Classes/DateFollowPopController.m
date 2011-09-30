//
//  DateFollowPopController.m
//  Scrap2
//
//  Created by Kelsey Levine on 4/27/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "DateFollowPopController.h"


@implementation DateFollowPopController

@synthesize parent, picker, startDate, forPrint, lastDate;

- (void)viewDidLoad {
	[super viewDidLoad];
	
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy"];
    if (!forPrint) {
	picker.date = [format dateFromString:parent.dateLbl.text];
	picker.minimumDate = [NSDate date];
        doneBtn.alpha = 0;
    } else {
        if (lastDate) {
            picker.date = lastDate;
        } else {
            picker.date = [NSDate date];
        }

    }
	
}

- (void) updateView:(NSDate *)lastDate1 {
   
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy"];
    
    if (!forPrint) {
        picker.date = [format dateFromString:parent.dateLbl.text];
        picker.minimumDate = [NSDate date];
        doneBtn.alpha = 0;
    
    } else {
        picker.minimumDate = nil;
        doneBtn.alpha = 1;
        if (lastDate1) {
            picker.date = lastDate1;
        } else {
            picker.date = [NSDate date];
        }
    }
}

- (IBAction)donePressed:(id)sender {
    [parent changeForPrint:picker.date];
}

- (IBAction) pickChange:(id)sender {
	if (!forPrint) {
        [parent changeReviewDate:picker.date:YES];
    } 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
