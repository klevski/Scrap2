//
//  WorkGroupTblView.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/28/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ContactPage.h"


@interface WorkGroupTblView : UIViewController {
    RootViewController *theRoot;
    NSArray *elements;
    IBOutlet UITableView *table;
    IBOutlet UILabel *titleLbl;
    NSMutableArray *copyList;
    BOOL searching;
    UISearchBar *searchBar;
    IBOutlet UIButton *doneButton;
    NSMutableArray *indexArray;
    ContactPage *contactParent;
}
@property (nonatomic, retain) ContactPage *contactParent;
@property (nonatomic, retain) RootViewController *theRoot;
@property (nonatomic, retain) NSArray *elements;


- (IBAction)searchBarCancelButtonClicked:(id)sender;

@end
