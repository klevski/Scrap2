//
//  Scrap2AppDelegate.h
//  Scrap2
//
//  Created by Kelsey Levine on 4/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetail-Proj.h"
#import "BlackCover.h"

@class RootViewController;
@class DetailViewController;
@class EventDetail_Proj;
@class BlackCover;


@interface Scrap2AppDelegate : NSObject <UIApplicationDelegate> {
    
    BlackCover *black;
    UIWindow *window;
    NSMutableArray *uploadArray;
    UISplitViewController *splitViewController;
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
    NSURL *openedUrl;
    NSString *currentEventName;
    NSMutableArray *allFiles;
}
@property (nonatomic, retain) NSMutableArray *allFiles;
@property (nonatomic, retain) IBOutlet UIWindow *blackWindow;
@property (nonatomic, retain) NSURL *openedUrl;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void)setCurrentEvent:(NSString *)event;
- (void) presentAddFileRoot;

@end
