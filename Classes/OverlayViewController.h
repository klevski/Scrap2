//
//  OverlayViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/9/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactPopController;

@interface OverlayViewController : UIViewController {

	ContactPopController *cpController;
	
}


@property (nonatomic, retain) ContactPopController *cpController;

@end
