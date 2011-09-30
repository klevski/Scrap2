//
//  personPopController.h
//  Scrap2
//
//  Created by Kelsey Levine on 4/26/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface personPopController : UIViewController {

	IBOutlet UITableView *table;
	NSArray *people;
	UIViewController *parent;
	RootViewController *theRoot;
}
@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, retain) IBOutlet UITableView *table; 
@property (nonatomic, retain) NSArray *people;
@property (nonatomic, retain) UIViewController *parent;

@end
