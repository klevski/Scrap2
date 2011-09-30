//
//  ContactPopController.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/9/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@class OverlayViewController;

@interface ContactPopController : UIViewController {
	
	IBOutlet UITableView *table;
	NSArray *people;
	UIViewController *parent;
	RootViewController *theRoot;
	NSMutableArray *finalList;
	IBOutlet UISearchBar *searchBar;
	NSMutableArray *copyList;
	BOOL searching;
	BOOL letUserSelectRow;
	OverlayViewController *ovController;
	NSMutableArray *indexArray;
}
@property (nonatomic, retain) NSMutableArray *indexArray;
@property (nonatomic, retain) NSMutableArray *finalList;
@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, retain) IBOutlet UITableView *table; 
@property (nonatomic, retain) NSArray *people;
@property (nonatomic, retain) UIViewController *parent;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
