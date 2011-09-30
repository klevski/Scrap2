//
//  DocImageView.m
//  Scrap2
//
//  Created by Kelsey Levine on 5/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "DocImageView.h"


@implementation DocImageView

@synthesize imageViewStr;

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
    // Do any additional setup after loading the view from its nib.
    
    NSLog(imageViewStr);
    
    [imageView setImage:[UIImage imageNamed:imageViewStr]];
    if ([imageViewStr isEqualToString:@"FairLand3.jpg"]) {
        shadow.alpha = 1;
        bottomCover.alpha = 1;
        border.alpha = 1;
        imageView.frame = CGRectMake(0, 125, 703, 384);
        shadow.frame = CGRectMake(0, 521, 703, 10);
        bottomCover.frame = CGRectMake(0, 524, 703, 200);
        border.frame = CGRectMake(0, 113, 703, 408);
        
        
    } else if ([imageViewStr isEqualToString:@"FairLand2.jpg"]) {
        shadow.alpha = 1;
        bottomCover.alpha = 1;
        border.alpha = 1;
        imageView.frame = CGRectMake(0, 100, 703, 480);
        shadow.frame = CGRectMake(0, 592, 703, 10);
        bottomCover.frame = CGRectMake(0, 595, 703, 200);
        border.frame = CGRectMake(0, 88, 703, 504);
        
    } else if ([imageViewStr isEqualToString:@"FairLand1.jpg"]) {
        shadow.alpha = 1;
        bottomCover.alpha = 1;
        border.alpha = 1;
        imageView.frame = CGRectMake(0, 80, 703, 527);
        shadow.frame = CGRectMake(0, 619, 703, 10);
        bottomCover.frame = CGRectMake(0, 622, 703, 200);
        border.frame = CGRectMake(0, 68, 703, 551);
    } else if ([imageViewStr isEqualToString:@"FairWindsFloorPlan.png"]) {
        imageView.frame = CGRectMake(85, 0, 546, 704);
        shadow.alpha = 0;
        bottomCover.alpha = 0;
        border.alpha = 0;
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    }

    
    
}

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
