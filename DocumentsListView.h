//
//  DocumentsListView.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/24/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EventDetail_Proj;

@interface DocumentsListView : UIViewController {
    IBOutlet UITableView *table;
    NSArray *elementsArray;
    EventDetail_Proj *parent;
}


@property (nonatomic, retain) NSArray *elementsArray;
@property (nonatomic, retain) EventDetail_Proj *parent;

@end
