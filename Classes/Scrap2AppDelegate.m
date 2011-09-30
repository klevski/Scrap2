//
//  Scrap2AppDelegate.m
//  Scrap2
//
//  Created by Kelsey Levine on 4/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "Scrap2AppDelegate.h"

#import "EventDetail-Proj.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "DocumentsListView.h"
#import "BlackCover.h"
#import "FileRootViewController.h"
#import "DocumentDisplayView.h"





@implementation Scrap2AppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController, openedUrl;
@synthesize blackWindow, allFiles;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
   
	//sleep(1);
	
    // Override point for customization after app launch.
    
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
   
    splitViewController.navigationController.navigationBar.tag = 0;
    [window makeKeyAndVisible];
    allFiles = [[NSMutableArray alloc] init];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    
    
    //So maintain currentEvent as a variable
    //if there is a current event, make it popup and ask if you want to add the document to this
    //event.
    openedUrl = url;
    [openedUrl retain];
    if ([openedUrl isFileURL]) {
    
       // [[FileList sharedFileList] importAndSelectFromURL:openedUrl];
    

  
    
    
    uploadArray = [[NSMutableArray alloc] init];
    UINavigationController *tempNav2 = [splitViewController.viewControllers objectAtIndex:1];
    
    
    //need to test if last item on the second Nav controller is of type eventDetail_proj
    UIViewController *lastView = [tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1];
    
    
    
    if ([lastView isKindOfClass:[EventDetail_Proj class]]) {
    
        EventDetail_Proj *lastEvent = [tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1];
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add File to Event" 
                                                    message:[NSString stringWithFormat:@"Would you like to add this file to the event %@?", lastEvent.eventName]
                                                   delegate:self 
                                          cancelButtonTitle: @"Cancel"
                                          otherButtonTitles: @"Yes", @"Different Event", nil];	
        [alert show];
        [alert release];
    
    } else {
        [lastView dismissModalViewControllerAnimated:YES];
        //if the last view is not an event, present the rootview in the center of the screen,
        //with the rest darkened so they can navigate to the event to which they would like
        //to add the new file.
        [self presentAddFileRoot];
    }
    
    
    
    //if not, put the URL as a variable and load the project list with a popup that says navigate to 
    //the event to which you would like to add the url and press the add document here button
    //make available a cancel button as well so they can stop the "uploading" task
    
    
    }
   return  YES;
}




- (void)importAndSelectFromURL {
   
    NSString *importFilePath = [openedUrl path];
    NSString *importFilename = [importFilePath lastPathComponent]; 
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES); 
    
    NSString *dir = [dirs objectAtIndex:0];
    NSString *filename = importFilename; 
    NSFileManager *fm = [NSFileManager defaultManager]; 
    
    //adding file to storage
    NSError *error = nil; 
    [fm copyItemAtPath:importFilePath 
                toPath:[dir stringByAppendingPathComponent:
                        filename] error:&error];
    
    //getting files from storage
    NSString *dirPath = [dirs objectAtIndex:0]; 
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:NULL]; 
   
    allFiles = [[NSMutableArray array] retain]; // the filenames returned by pathsMatchingExtensions: don’t include the whole // file path, so we add it to each file here.
    //for (NSString *file in files) { 
      //  [allFiles addObject:[dirPath stringByAppendingPathComponent:file]];
    //}
    NSLog(@"allFiles: %@", allFiles);
    
    //to remove all the files from this storage:
    for (NSString *file in files) {
        [[NSFileManager defaultManager] removeItemAtPath:file
                                               error:&error];
    }
    
    
   NSLog(@"allFiles: %@", allFiles);
    
    UINavigationController *tempNav2 = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController *lastView = [tempNav2.viewControllers objectAtIndex:[tempNav2.viewControllers count]-1];
  
    ///********************************* to upload files *********************************
    //NSData *data = [[NSData alloc] initWithContentsOfFile:[files objectAtIndex:[files count]-1]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:openedUrl];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[lastView uploadData:openedUrl]]];
    NSLog(@"datastring: %@", data);
	[request setHTTPMethod:@"POST"];
    NSLog(@"openedURL: '%@'", openedUrl);
    
  
    NSLog(@"contents of url: %@", [NSString stringWithContentsOfURL: 
                                openedUrl encoding:NSASCIIStringEncoding error:&error]);
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\";filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/pdf\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:data]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
	NSLog(@"return string: %@", returnString);
    
    ///////////***************************************************************************
    
    
    
    DocumentDisplayView *docDisplay = [[DocumentDisplayView alloc] init];
    docDisplay.pdfUrl = openedUrl;
   
    [lastView.navigationController pushViewController:docDisplay animated:YES];
    [docDisplay release];
      
}



- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        nil;
    } else {
        [self presentAddFileRoot];
    }
}



- (void) addUploadArray:(NSString *)str {
    [uploadArray addObject:str];
}

- (void) removeUploadArray:(NSString *)str {
    [uploadArray removeObject:str];
}

- (void) removeAllFromUpload {
    [uploadArray removeAllObjects];
}

- (NSMutableArray *)getUploadArray {
    return uploadArray;
}


- (void) presentAddFileRoot {
    
    
    
    NSArray *tempContollers = [[splitViewController.viewControllers objectAtIndex:0] viewControllers];
    
        
        RootViewController *currentRoot = [tempContollers objectAtIndex:[tempContollers count]-1];
    
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableArray *stringStack = [[NSMutableArray alloc] init];
    
    for (int i=0; i < [tempContollers count]-1; ++i) {
        
        RootViewController *tempRoot = [tempContollers objectAtIndex:i];
        
        
        NSLog(@"finalProjectsStr: %@", tempRoot.finalProjectsStr);
        NSLog(@"mode: %@", tempRoot.mode);
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempRoot.elementsArray, @"elementsArray",
                                    tempRoot.serverInfo, @"serverInfo",
                                    tempRoot.workGroupsArray, @"workGroupsArray",
                                    nil];
        
        
        
        NSDictionary *dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempRoot.userIDNum, @"userIDNum",
                                    tempRoot.titleStr, @"titleStr",
                                    tempRoot.mode, @"mode",
                                    [NSString stringWithFormat:@"%d",tempRoot.depth], @"depth",
                                    tempRoot.projectName, @"projectName", 
                                    tempRoot.projectID, @"projectID",
                                    tempRoot.eventMode, @"eventMode",
                                    nil];
        
        [stringStack addObject:dictionary2];
        [stack addObject:dictionary];

        
    }
    
        FileRootViewController *listView = [[FileRootViewController alloc] initWithNibName:@"AddFileRoot" bundle:nil];
        
        listView.elementsArray = currentRoot.elementsArray;
        listView.workGroupsArray = currentRoot.workGroupsArray;
        listView.userIDNum = currentRoot.userIDNum;
        listView.serverInfo = currentRoot.serverInfo;
        listView.titleStr = currentRoot.titleStr;
        listView.mode = currentRoot.mode;
        [listView setDepth:currentRoot.depth];
        listView.projectName = currentRoot.projectName;
        listView.projectID = currentRoot.projectID;
        listView.eventMode = currentRoot.eventMode;
        listView.stack = stack;
        listView.stringStack = stringStack;
     
     
    black = [[BlackCover alloc] initWithNibName:@"BlackCoverView" bundle:nil];
    black.view.frame = CGRectMake(0, 0, black.view.frame.size.width, black.view.frame.size.height+20);
    [window addSubview:black.view];
    [window setAutoresizesSubviews:NO];
    listView.view.frame = CGRectMake(210.0, 85.0, listView.view.frame.size.width, listView.view.frame.size.height);
    [window addSubview:listView.view];

    [listView release];
    
}


- (void)removeViewFromWindow:(UIView *)view {
    
    [view removeFromSuperview];
    [black.view removeFromSuperview];
    [black release];
     
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


- (void)setCurrentEvent:(NSString *)event{
    NSLog(@"setting the event");
    currentEventName = event;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [splitViewController release];
    [window release];
    [rootViewController release];
    [detailViewController release];
    [openedUrl release];
    [blackWindow release];
    [super dealloc];
}


@end

