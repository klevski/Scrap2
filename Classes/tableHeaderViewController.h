//
//  tableHeaderViewController.h
//  Scrap2
//
//  Created by Kelsey Levine on 6/24/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface tableHeaderViewController : UIViewController {
    
    IBOutlet UISearchBar *searchbar;
    IBOutlet UITextField *textField;
    RootViewController *theRoot;
    
}

@property (nonatomic, retain) RootViewController *theRoot;

- (IBAction)buttonPressed:(id)sender;

@end
