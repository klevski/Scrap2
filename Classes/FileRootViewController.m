//
//  FileRootViewController.m
//  Scrap2
//
//  Created by Kelsey Levine on 6/20/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "FileRootViewController.h"
#import "WorkGroupTblView.h"



@implementation FileRootViewController

@synthesize elementsArray, finalProjectsStr, workGroupsArray, allProjects, serverInfo;
@synthesize titleStr, mode, depth, workGroupStr, allEventsProjects, workGroupID, eventMode;
@synthesize userIDNum, projectID, projectName, stack, stringStack;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoading = YES;
    appDelegate = (Scrap2AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([stringStack count]==0) {
        backBtn.alpha = 0;
        backLbl.alpha = 0;
    }
    
    if (!workGroupsArray) {
        [[workGroupsArray alloc] init];
    }
    
    
	[elementsArray retain];
	if (elementsArray == nil) {
		self.title = @"Switchboard";
        titleStr = @"Switchboard";
		elementsArray = [[NSMutableArray alloc] initWithObjects: @"Events", @"Projects", @"Master Database", nil];
		mode = @"";
		depth = 0;
        [titleStr retain];
		
	}
    
    table = firstTable;
	notTable = otherTable;
    
    if (([mode isEqualToString:@"Projects"] && depth==3) || ([mode isEqualToString:@"Events"] && depth==2)) {
        table.separatorColor = [UIColor lightGrayColor];
    }
    
    if ([mode isEqualToString:@"Projects"]) {
        table.backgroundColor = [UIColor colorWithRed:.93 green:.93 blue:1 alpha:1];
    } else if ([mode isEqualToString:@"Events"]) {
        if (depth == 2) {
            [allEventsProjects retain];
            workGroupStr = [[workGroupsArray objectAtIndex:0] substringFromIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location+3];
            [workGroupStr retain];
            
            
        }
        table.backgroundColor = [UIColor colorWithRed:1 green:.93 blue:.93 alpha:1];
    } else if ([mode isEqualToString:@"Master"]) {
        table.backgroundColor = [UIColor colorWithRed:.93 green:1 blue:.93 alpha:1];
    }
    
    if (!workGroupID) {
        workGroupID = [[[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location] retain];
    }
    
    // create a custom navigation bar button and set it to always say "Back"
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = titleStr;
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    
    
    if ([eventMode isEqualToString:@"active"]) {
        currentPriority = 1;
    } else {
        currentPriority = 3;
    }

	
    
    
	if ([mode isEqualToString:@"Projects"]) {
		
		currentSeg = 0;
		
	}
    
    
    WorkGroupTblView *wgTble = [[WorkGroupTblView alloc] init];
    wgTble.theRoot = self;
    wgTble.elements = workGroupsArray;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:wgTble];
    [wgTble release];
    isLoading = NO;
}



//the user presses a different priority on the top of the list
- (IBAction) changePrioritySeg:(id)sender {
    
    if (!isLoading) {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (currentPriority != [segmentedControl selectedSegmentIndex]+1) {
        currentPriority = [segmentedControl selectedSegmentIndex]+1; 
    }
    
    NSError *error;
    
  
        //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
        NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                   [serverInfo objectAtIndex:0],
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   userIDNum];
        
        
        
        NSString *workGroups = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 getWorkGroups] encoding:NSASCIIStringEncoding error:&error];
        
        NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
        
        if (lastsquiggle.location != NSNotFound) {
            
            workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
            
        } else {
            workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
        }
        workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];
    
    
       
 
    
    
    
    
    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];
    int daysToAdd = -2;
    NSDate *afterDate = [now addTimeInterval:60*60*24*daysToAdd];
    NSDate *finalAfterDate;
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:afterDate];
    
    //take out the weekends - get the last 48 hours from the week
    
    // 1 = Sunday, 2 = Monday, etc.
    if (([comp weekday]==1)||([comp weekday]==7)) {
        finalAfterDate = [afterDate addTimeInterval:-60*60*24*3];
        
    } else {
        finalAfterDate = afterDate;
    }
    
    
    
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString *afterDateStr = [format stringFromDate:finalAfterDate];
    
    
    
    NSString *eventsString;
    NSString *titleDetail;
    if ([eventMode isEqualToString:@"due"]) {
        eventsString = [self getDueEvents:[format stringFromDate:[NSDate date]]:currentPriority+1];
        titleDetail = @"Due for Review";
    } else if ([eventMode isEqualToString:@"active"]) {
        eventsString = [self getActiveEvents: currentPriority+1];
        titleDetail = @"Active Events";
    } else {
        
        NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&Triage=%d&DateAfter=%@&UserID=%@&WorkGroupID=%@",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   currentPriority+1,
                                   afterDateStr,userIDNum, workGroupID];   
        
        
        eventsString = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:
                         getEventsSite] encoding:NSASCIIStringEncoding error:&error];
        
        
        titleDetail = @"Recent Events";
    }
    
  
    
    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
        elementsArray = [[eventsString substringToIndex:
                          eventsString.length-3]
                         componentsSeparatedByString:@"~-~"];
    } else {
        elementsArray = [eventsString componentsSeparatedByString:@"~-~"];
    }
    
    if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        self.title = [NSString stringWithFormat:@"%@ (0)",
                      titleDetail];
    } else {
        self.title = [NSString stringWithFormat:@"%@ (%d)",
                      titleDetail,
                      [elementsArray count]];
        
    }
    [elementsArray retain];
    
    [format release];
    isreloadingTbl = NO;
    [table reloadData];
   // isreloadingTbl = NO;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (([mode isEqualToString:@"Projects"]) || ([mode isEqualToString:@"Events"] && depth==2)) {
        return [elementsArray count]+1;
	} else {
		return [elementsArray count];
	}
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    isreloadingTbl = NO;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
       // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ((cell == nil) || isreloadingTbl || indexPath.row < [elementsArray count]+1){
		
       
        
		if  ([mode isEqualToString:@"Projects"] && depth == 3) {
           
			cell = [self getCellContentView:CellIdentifier]; 
            
        } else if ([mode isEqualToString:@"Events"] && depth == 2) {
            if ([eventMode isEqualToString:@"active"]) {
              
                cell = [self getActiveCellContent:CellIdentifier];
            } else {
               
                cell = [self getEventCellContent:CellIdentifier];
            }
        } else if ([mode isEqualToString:@"Projects"] && (depth == 2 || depth == 1)) {
           
            cell=[self getTitleCellContent:CellIdentifier];
            
        } else {
            
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            
		}
		cell.accessoryType = UITableViewCellAccessoryNone;
		
    }
    
	
    if ([elementsArray count]!=0) {
        
        if ([[elementsArray objectAtIndex:0] isEqualToString:@""]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
	if ([mode isEqualToString:@"Events"] && depth == 2) {
        
        if (![eventMode isEqualToString:@"active"]) {
        
		UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];	
		UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
		UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
		UISegmentedControl *segCont = (UISegmentedControl *)[cell viewWithTag:4];
		UITextField *textField = (UITextField *)[cell viewWithTag:5];
        UIImageView *image = (UIImageView *)[cell viewWithTag:6];
        UIButton *tempBtn1 = (UIButton *)[cell viewWithTag:8];
		
           
        
        cell.userInteractionEnabled = YES;
        
        //EventName~+~EventID~+~EventDescription
        if (indexPath.row != 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            image.alpha = 0;
            if (([elementsArray count]!=0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
            	NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                
                lblTemp1.text = [temp objectAtIndex:0];
                lblTemp1.alpha = 1;
                lblTemp2.text = [temp objectAtIndex:1];
                lblTemp2.alpha = 1;
                lblTemp3.text = [temp objectAtIndex:3];
                lblTemp3.alpha = 1;
               
                if ([[appDelegate getUploadArray] containsObject: [temp objectAtIndex:2]]) {
                    tempBtn1.selected = YES;
                }
                
            } else {
                lblTemp1.text = @"";
                lblTemp1.alpha = 0;
                lblTemp2.text = @"";
                lblTemp2.alpha = 0;
                lblTemp3.text = @"";
                lblTemp3.alpha = 0;
                tempBtn1.alpha = 0;
            }
				
            textField.alpha = 0;
            image.alpha = 0;
            segCont.alpha = 0;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            textField.text = workGroupStr;
            textField.alpha = 1;
            lblTemp1.text = @"";
            lblTemp1.alpha = 0;
            lblTemp2.text = @"";
            lblTemp2.alpha = 0;
            lblTemp3.text = @"";
            lblTemp3.alpha = 0;
            segCont.alpha = 1;
            image.alpha = 1;
            tempBtn1.alpha = 0;
            [segCont retain];
            [segCont addTarget:self action:@selector(changePrioritySeg:) 
              forControlEvents:UIControlEventValueChanged];
            isLoading = YES;
           segCont.selectedSegmentIndex = currentPriority-1;
            isLoading = NO;
        }
    }else {
            
      
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];	
            UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
            UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
            UISegmentedControl *segCont = (UISegmentedControl *)[cell viewWithTag:4];
            UIButton *tempBtn1 = (UIButton *)[cell viewWithTag:5];
            
            
            cell.userInteractionEnabled = YES;
            
            //EventName~+~EventID~+~EventDescription
            if (indexPath.row != 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
               // image.alpha = 0;
                if (([elementsArray count]!=0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                    NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                    
                    lblTemp1.text = [temp objectAtIndex:0];
                    lblTemp1.alpha = 1;
                    lblTemp2.text = [temp objectAtIndex:1];
                    lblTemp2.alpha = 1;
                    lblTemp3.text = [temp objectAtIndex:3];
                    lblTemp3.alpha = 1;
                    
                    if ([[appDelegate getUploadArray] containsObject: [temp objectAtIndex:2]]) {
                        tempBtn1.selected = YES;
                    }
                    
                    tempBtn1.alpha = 1;
                
                } else {
                   
                    lblTemp1.text = @"";
                    lblTemp1.alpha = 0;
                    lblTemp2.text = @"";
                    lblTemp2.alpha = 0;
                    lblTemp3.text = @"";
                    lblTemp3.alpha = 0;
                    tempBtn1.alpha = 0;
                    
                }
               // tempBtn.alpha = 0;	
               // textField.alpha = 0;
               // image.alpha = 0;
                segCont.alpha = 0;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
               // textField.text = workGroupStr;
               // textField.alpha = 1;
                lblTemp1.text = @"";
                lblTemp1.alpha = 0;
                lblTemp2.text = @"";
                lblTemp2.alpha = 0;
                lblTemp3.text = @"";
                lblTemp3.alpha = 0;
                segCont.alpha = 1;
               // image.alpha = 1;
                tempBtn1.alpha = 0;
                [segCont retain];
                [segCont addTarget:self action:@selector(changePrioritySeg:) 
                  forControlEvents:UIControlEventValueChanged];
                isLoading = YES;
                segCont.selectedSegmentIndex = currentPriority-1;
                isLoading = NO;
        }
    }
        
    } else if ([mode isEqualToString:@"Projects"] && depth == 3) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
        UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
        UIButton *circle = (UIButton *)[cell viewWithTag:4];
        UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:5];
        UIImageView *image = (UIImageView *)[cell viewWithTag:6];
        
        if (indexPath.row!=0) {
            
            lblTemp4.alpha = 0;
            image.alpha = 0;
            if (([elementsArray count] > 0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])
                && (indexPath.row-1 < [elementsArray count])) {
                cell.userInteractionEnabled = YES;
               
                //EventName~+~EventID~+~EventDescription
                NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
              
               
                if ([[appDelegate getUploadArray] containsObject: [temp objectAtIndex:1]]) {
                    circle.selected = YES;
                }
                
                circle.alpha = 1;
                lblTemp2.text = [temp objectAtIndex:0];
                lblTemp3.text = [temp objectAtIndex:2];
            } else {
                cell.userInteractionEnabled = YES;
                
                lblTemp2.text = @"";
                lblTemp3.text = @"";
                circle.alpha = 0;
            }
            
            
        } else {
            lblTemp4.alpha = 1;
            image.alpha = 1;
            lblTemp4.text = titleStr;
            self.title = @"";
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            circle.alpha = 0;
            lblTemp2.text = @"";
            lblTemp3.text = @"";
        }
        
        
        
        
    } else if ([mode isEqualToString:@"Projects"] && (depth == 2 || depth == 1)) {
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
        UIImageView *image = (UIImageView *)[cell viewWithTag:3];
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:4];
        
        if (indexPath.row==0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            lblTemp1.text = titleStr;
            lblTemp1.alpha = 1;
            image.alpha = 1;
            lblTemp2.alpha = 0;
            
        } else {
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if ([[elementsArray objectAtIndex:indexPath.row-1] rangeOfString: @"~+~"].location!=NSNotFound) {
                lblTemp2.text = [[elementsArray objectAtIndex:indexPath.row-1] 
                                 substringToIndex: [[elementsArray objectAtIndex:indexPath.row-1]
                                                    rangeOfString:@"~+~"].location];
            } else {
                lblTemp2.text = [elementsArray objectAtIndex:indexPath.row-1];
            }
            lblTemp1.alpha = 0;
            lblTemp2.alpha = 1;
            image.alpha = 0;
            
        }
        
	} else {
		cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		if ([[elementsArray objectAtIndex:indexPath.row] rangeOfString: @"~+~"].location!=NSNotFound) {
			cell.textLabel.text = [[elementsArray objectAtIndex:indexPath.row] 
								   substringToIndex: [[elementsArray objectAtIndex:indexPath.row]
													  rangeOfString:@"~+~"].location];
		} else {
			cell.textLabel.text = [elementsArray objectAtIndex:indexPath.row];
		}
		cell.textLabel.textColor = [UIColor whiteColor];
	}
    
    if (([elementsArray count] > 0) && ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([mode isEqualToString:@"Projects"] && depth == 3) {
		if ((indexPath.row == 0)&& [mode isEqualToString:@"Projects"]) {
			return 42;
		} else {
			return 70;
		}
        
    }else if ([mode isEqualToString:@"Events"] && depth == 2) {
        if (([eventMode isEqualToString:@"active"]) && (indexPath.row == 0)) {
            return 41;
        } else {
            return 78;
        }
    }else if ([mode isEqualToString:@"Projects"] && (depth == 2 || depth == 1)) {
        if (indexPath.row == 0) {
			return 42;
		} else {
			return 50;
		}
    } else {
		return 50;
	}
}

//the content of the cells in the Active Event List
- (UITableViewCell *) getActiveCellContent:(NSString *)cellIdentifier {
    
 
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(70, 5, 270, 15);
	CGRect Label2Frame = CGRectMake(70, 20, 270, 20);
	CGRect Label3Frame = CGRectMake(80, 26, 260, 60);
	CGRect SegFrame = CGRectMake(-3.0f, -2, 374.0f, 44.0f);
    CGRect CircleFrame = CGRectMake(5, 8, 48, 52);
	UILabel *lblTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
    //Project label
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //event name label
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:15];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //descriptor label
	//Initialize seg with tag 3.
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 3;
	lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	lblTemp.numberOfLines = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    //Initialize Label with tag 4;
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] 
											initWithItems:
											[NSArray arrayWithObjects:
											 @"1", @"2",@"3", nil]];
    
  

    
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tag = 4;
	segmentedControl.alpha = 0;
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.frame = SegFrame;
	[cell.contentView addSubview:segmentedControl];
    [segmentedControl release];
    
    
    //Initialize Image with tag 6.
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"EmptyCircle"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"fullCircle"] forState:UIControlStateSelected];
    [btn addTarget:self action: @selector(circleBtnPressed:withEvent:)
    forControlEvents: UIControlEventTouchUpInside];
    btn.frame = CircleFrame;
	btn.tag = 5;
    [cell.contentView addSubview:btn];
	[btn release];
    
    
    return cell;
}




- (UITableViewCell *) getEventCellContent:(NSString *)cellIdentifier {
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(70, 5, 270, 15);
	CGRect Label2Frame = CGRectMake(70, 20, 270, 20);
	CGRect Label3Frame = CGRectMake(80, 26, 260, 60);
	CGRect SegFrame = CGRectMake(-3.0f, 41, 374.0f, 38.0f);
    CGRect TextFrame = CGRectMake(60, 6, 200, 28);
    CGRect ImageFrame = CGRectMake(0, -3, 374, 44);
    CGRect CircleFrame = CGRectMake(5, 8, 48, 52);
	UILabel *lblTemp;
    UIImageView *image;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
    //Project label
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //event name label
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:15];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
    //descriptor label
	//Initialize seg with tag 3.
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 3;
	lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	lblTemp.numberOfLines = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    //Initialize Label with tag 4;
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] 
											initWithItems:
											[NSArray arrayWithObjects:
											 @"1", @"2",@"3", nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tag = 4;
	segmentedControl.alpha = 0;
	segmentedControl.selectedSegmentIndex = 2;
	segmentedControl.frame = SegFrame;
	[cell.contentView addSubview:segmentedControl];
    [segmentedControl release];
    
    //This is the little grey bar across the top
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theBigBar"]];
    image.frame = ImageFrame;
	image.tag = 6;
    [cell.contentView addSubview:image];
	[image release];
    
    
    //Initialize Image with tag 6.
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"EmptyCircle"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"fullCircle"] forState:UIControlStateSelected];
    [btn addTarget:self action: @selector(circleBtnPressed:withEvent:)
  forControlEvents: UIControlEventTouchUpInside];
    btn.frame = CircleFrame;
	btn.tag = 8;
    [cell.contentView addSubview:btn];
	[btn release];

    
    //so the user can select which work group's events they would like to see
    //Initialize Label with tag 5;
    UITextField *textField = [[UITextField alloc] initWithFrame:TextFrame];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor]; //text color
    textField.font = [UIFont systemFontOfSize:17.0];  //font size
    
    textField.backgroundColor = [UIColor clearColor]; //background color
    textField.tag = 5;
    textField.textAlignment = UITextAlignmentCenter;
	[cell.contentView addSubview:textField];
	[textField release];
	
    //The button to bring up a table to choose the work group.
    //need to give it a tag too so that user cannot press it when not
    //in the top row.  Tag will be 7
    UIButton *wgButton = [[UIButton alloc] initWithFrame:TextFrame];
    wgButton.backgroundColor = [UIColor clearColor];
    wgButton.tag = 7;
    [wgButton addTarget:self action:@selector(displayWorkGroupTbl:) 
       forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:wgButton];
    [wgButton release];
    
    return cell;
    
}

- (void) displayWorkGroupTbl:(id)sender {
    [popoverController setPopoverContentSize:CGSizeMake(212, 290)];
	[popoverController presentPopoverFromRect:CGRectMake(54, -250, 212, 290) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void) updateWorkGroupSelected:(NSString *)str {
    
    [popoverController dismissPopoverAnimated:YES];
    //first, change the text in the textbox to the new work group
    workGroupStr = [str substringFromIndex:[str rangeOfString:@"~-~"].location+3];
    workGroupID = [str substringToIndex:[str rangeOfString:@"~-~"].location];
    
    [workGroupStr retain];
    [workGroupID retain];
    
    NSError *error;
    
    //get the relevant projects from the new work group that was selected.
    
    
        
        //Get the projects for the array
        NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetPMIDProjects.php?mUser=%@&mPassword=%@&PMID=%@",
                                     [serverInfo objectAtIndex:0], 
                                     [serverInfo objectAtIndex:3],
                                     [serverInfo objectAtIndex:4],
                                     workGroupID];    
        
        
        
        NSString *projects = [NSString stringWithContentsOfURL: 
                              [NSURL URLWithString:
                               getProjectsSite]
                                                      encoding:NSASCIIStringEncoding error:&error];
        
        
        
        NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
        
        
        allEventsProjects = [[projects substringToIndex:
                              lastsquiggle.location]
                             componentsSeparatedByString:@"~-~"];
   
    [allEventsProjects retain];
    
    
    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    
    
    NSString *eventsString;
    NSString *titleDetail;
    if ([eventMode isEqualToString:@"due"]) {
        eventsString = [self getDueEvents:[format stringFromDate:[NSDate date]]:currentPriority+1];
        titleDetail = @"Due for Review";
    } else if ([eventMode isEqualToString:@"active"]) {
        eventsString = [self getActiveEvents:currentPriority+1];
        titleDetail = @"Active Events";
    } else {
        //if we are in recent events, find the day that qualifies it as recent
        NSDate *now = [NSDate date];
        int daysToAdd = -1;
        NSDate *afterDate = [now addTimeInterval:60*60*24*daysToAdd];
        NSDate *finalAfterDate;
        
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:afterDate];
        
        //take out the weekends - get the last 48 hours from the week
        
        // 1 = Sunday, 2 = Monday, etc.
        if (([comp weekday]==1)||([comp weekday]==7)) {
            finalAfterDate = [afterDate addTimeInterval:-60*60*24*3];
            
        } else {
            finalAfterDate = afterDate;
        }
        
        
        NSString *afterDateStr = [format stringFromDate:finalAfterDate];
        
        NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&Triage=%d&DateAfter=%@&UserID=%@&WorkGroupID=%@",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   currentPriority+1,
                                   afterDateStr,userIDNum, workGroupID];    
        
        eventsString = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:
                         getEventsSite] encoding:NSASCIIStringEncoding error:&error];
        
        titleDetail = @"Recent Events";
    }
    
    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
        elementsArray = [[eventsString substringToIndex:
                          eventsString.length-3]
                         componentsSeparatedByString:@"~-~"];
    } else {
        elementsArray = [eventsString componentsSeparatedByString:@"~-~"];
    }
    
    if (([elementsArray count]==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
        self.title = [NSString stringWithFormat:@"%@ (0)",
                      titleDetail];
    } else {
        self.title = [NSString stringWithFormat:@"%@ (%d)",
                      titleDetail,
                      [elementsArray count]];
        
    }
    [elementsArray retain];
    [format release];
    isreloadingTbl = YES;
    [table reloadData];
   // isreloadingTbl = NO;
}

- (UITableViewCell *) getTitleCellContent:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 90);
    CGRect Label1Frame = CGRectMake(0, -7, 374, 53);
    CGRect Label2Frame = CGRectMake(10, 10, 290, 30);
    CGRect ImageFrame = CGRectMake(0, -3, 374, 44);
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
    
    UILabel *lblTemp;
    UIImageView *image;
    
       
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theBigBar"]];
    image.frame = ImageFrame;
	image.tag = 3;
    [cell.contentView addSubview:image];
	[image release];
    
    //Initialize Label with tag 5;
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.shadowColor = [UIColor whiteColor];
    lblTemp.shadowOffset = CGSizeMake(0, 1);
	lblTemp.tag = 1;
	lblTemp.font = [UIFont boldSystemFontOfSize:17];
    lblTemp.textAlignment = UITextAlignmentCenter;
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
    
    //Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 4;
	lblTemp.font = [UIFont boldSystemFontOfSize:20];
	lblTemp.textColor = [UIColor whiteColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
    
    return cell;
}


//for custom cells for the Event Lists
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 90);
	CGRect Label1Frame = CGRectMake(70, 5, 270, 15);
	CGRect Label2Frame = CGRectMake(70, 8, 270, 20);
	CGRect Label3Frame = CGRectMake(80, 15, 260, 60);
    CGRect Label5Frame = CGRectMake(0, -7, 374, 53);
    CGRect ImageFrame = CGRectMake(0, -3, 374, 44);
    CGRect CircleFrame = CGRectMake(5, 8, 48, 52);
	UILabel *lblTemp;
    UIImageView *image;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 1;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 2;
	//lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	//lblTemp.numberOfLines = 3;
	lblTemp.font = [UIFont boldSystemFontOfSize:15];
	lblTemp.textColor = [UIColor blackColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	
	//Initialize seg with tag 3.
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
	lblTemp.tag = 3;
	lblTemp.lineBreakMode = UILineBreakModeWordWrap;
	lblTemp.numberOfLines = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    
    //Initialize Image with tag 6.
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"EmptyCircle"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"fullCircle"] forState:UIControlStateSelected];
    [btn addTarget:self action: @selector(circleBtnPressed:withEvent:)
        forControlEvents: UIControlEventTouchUpInside];
    btn.frame = CircleFrame;
    btn.highlighted = NO;
	btn.tag = 4;
    [cell.contentView addSubview:btn];
	[btn release];
    

    
    //Initialize Image with tag 6.
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theBigBar"]];
    image.frame = ImageFrame;
	image.tag = 6;
    [cell.contentView addSubview:image];
	[image release];
    
    //Initialize Label with tag 5;
	lblTemp = [[UILabel alloc] initWithFrame:Label5Frame];
	lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.shadowColor = [UIColor whiteColor];
    lblTemp.shadowOffset = CGSizeMake(0, 1);
	lblTemp.tag = 5;
	lblTemp.font = [UIFont boldSystemFontOfSize:17];
    lblTemp.textAlignment = UITextAlignmentCenter;
	lblTemp.textColor = [UIColor darkGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
    
    
    
	return cell;
}


- (IBAction) circleBtnPressed:(id)sender withEvent: (UIEvent *) event {
  
    UIButton *btn = sender;
    
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: table];
    NSIndexPath * indexPath = [table indexPathForRowAtPoint: location];    
    
    NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
    
   
    
    if (btn.selected) {
        btn.selected = NO;
        if ([mode isEqualToString:@"Events"]) {
                [appDelegate removeUploadArray:[temp objectAtIndex:2]];
             } else {
                [appDelegate removeUploadArray:[temp objectAtIndex:1]];
             }
    } else {
        btn.selected = YES;
        if ([mode isEqualToString:@"Events"]) {
            [appDelegate addUploadArray:[temp objectAtIndex:2]];
        } else {
            [appDelegate addUploadArray:[temp objectAtIndex:1]];
        }

    }

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    

	
	if (depth == 0) {
		cell.textLabel.font = [UIFont italicSystemFontOfSize:20];
		if (indexPath.row == 0) {
			[cell setBackgroundColor:[UIColor colorWithRed:.75 green:.1 blue:.1 alpha:1]];
		} else if (indexPath.row == 1) {
			[cell setBackgroundColor:[UIColor colorWithRed:.2 green:.3 blue:.6 alpha:1]];
		}else {
			[cell setBackgroundColor:[UIColor colorWithRed:.1 green:.5 blue:.1 alpha:1]];
		}
		
	} else if (depth == 1) {
		if ([mode isEqualToString:@"Events"]) {
			[cell setBackgroundColor:[UIColor colorWithRed:.97 green:.47 blue:.52 alpha:1]];
		} else if ([mode isEqualToString:@"Projects"]) {
            if (indexPath.row==0) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                
                if (![[elementsArray objectAtIndex:0] isEqualToString:@""]) {
                    [cell setBackgroundColor:[UIColor colorWithRed:.34 green:.48 blue:.75 alpha:1]];
                } else {
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
            }
		} else {
			[cell setBackgroundColor:[UIColor colorWithRed:.53 green:.73 blue:.53 alpha:1]];
		}
	} else if (depth == 2) {
		if ([mode isEqualToString:@"Events"]) {
            if ((indexPath.row==0) || ([[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                [cell setBackgroundColor:[UIColor colorWithRed:1 green:.8 blue:.85 alpha:1]];
            }
		} else if ([mode isEqualToString:@"Projects"]) {
            if (indexPath.row==0) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                
                if (![[elementsArray objectAtIndex:0] isEqualToString:@""]) {
                    [cell setBackgroundColor:[UIColor colorWithRed:.48 green:.63 blue:.88 alpha:1]];
                } else {
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
            }
		} else {
			[cell setBackgroundColor:[UIColor colorWithRed:.73 green:.88 blue:.73 alpha:1]];
		}
	} else {
		if ([mode isEqualToString:@"Events"]) {
			[cell setBackgroundColor:[UIColor colorWithRed:.75 green:.1 blue:.1 alpha:1]];
		} else if ([mode isEqualToString:@"Projects"]) {
			if (indexPath.row==0) {
                [cell setBackgroundColor:[UIColor clearColor]];
            } else {
                
                if (indexPath.row > [elementsArray count]) {
                    [cell setBackgroundColor: [UIColor colorWithRed:.93 green:.93 blue:1 alpha:1]];
                }else if (([elementsArray count] > 0) && (![[elementsArray objectAtIndex:0] isEqualToString:@""])) {
                    [cell setBackgroundColor:[UIColor colorWithRed:.7 green:.8 blue:.95 alpha:1]];
                } else {
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
            }
            
		} else {
			[cell setBackgroundColor:[UIColor colorWithRed:.1 green:.5 blue:.1 alpha:1]];
		}
	}
    
}



- (IBAction) latestSegmentAction:(id)sender {
    
    
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	
	if (currentSeg != [segmentedControl selectedSegmentIndex]) {
        
		currentSeg = [segmentedControl selectedSegmentIndex];
        
    }
    
    NSString *geteventsSite;
    
    //If the user wants to see the closed events
    if (currentSeg==1) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if (depth==3) {
            
            
            //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
            geteventsSite = [NSString stringWithFormat:@"http://%@/GetClosedIssueEvents.php?mUser=%@&mPassword=%@&issueID=%@",
                             [serverInfo objectAtIndex:0], 
                             [serverInfo objectAtIndex:3],
                             [serverInfo objectAtIndex:4],
                             issueID];
            
            //getting closed issues
        } else if (depth==2) {
            
            //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
            geteventsSite = [NSString stringWithFormat:@"http://%@/GetClosedProjectIssues.php?mUser=%@&mPassword=%@&ProjectID=%@",
                             [serverInfo objectAtIndex:0], 
                             [serverInfo objectAtIndex:3],
                             [serverInfo objectAtIndex:4],
                             projectID];
            
            //getting closed Projects
        } else if (depth==1) {
            
            NSError *error;
            
            if (!workGroupsArray) {
                //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
                NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                           [serverInfo objectAtIndex:0],
                                           [serverInfo objectAtIndex:3],
                                           [serverInfo objectAtIndex:4],
                                           userIDNum];
                
                NSString *workGroups = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         getWorkGroups]
                                                                encoding:NSASCIIStringEncoding error:&error];
                
                
                NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
                
                if (lastsquiggle.location != NSNotFound) {
                    
                    workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
                    
                } else {
                    workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
                }
                
                workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];
            }
            
            //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
            geteventsSite = [NSString stringWithFormat:@"http://%@/GetClosedProjects.php?mUser=%@&mPassword=%@",
                             [serverInfo objectAtIndex:0], 
                             [serverInfo objectAtIndex:3],
                             [serverInfo objectAtIndex:4]];
            
            
            NSString *projects = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   geteventsSite]
                                                          encoding:NSASCIIStringEncoding error:&error];
            
            NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
            
            if (!allProjects) {
                
                if (lastsquiggle.location != NSNotFound) {
                    allProjects = [[projects substringToIndex:
                                    lastsquiggle.location]
                                   componentsSeparatedByString:@"~-~"];
                    
                } else {
                    allProjects = [projects componentsSeparatedByString:@"~-~"];
                    
                    
                }
            }
            
            
            //OWN FUNTION ****************
            //loop through and determine if the second item in each array is in the list from tblPermissions
            //if it is, add it on to string and finally return string.
            //****************************
            
            
            if (!finalProjectsStr) {
                finalProjectsStr = [self getFinalProjects: allProjects:@"": workGroupsArray: 0];
            }
            
            //split up the string and pass it on as nextElements
            
            //ASSIGN NEXTELEMENTS
            elementsArray = [finalProjectsStr componentsSeparatedByString:@"~-~"];
        }
        
        
        //else if the user wants to see all open things
    } else {
        
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        
        //open events
        if (depth == 3) {
            
            //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
            geteventsSite = [NSString stringWithFormat:@"http://%@/GetIssueEvents.php?mUser=%@&mPassword=%@&issueID=%@",
                             [serverInfo objectAtIndex:0], 
                             [serverInfo objectAtIndex:3],
                             [serverInfo objectAtIndex:4],
                             issueID, 
                             [segmentedControl selectedSegmentIndex]];
            //open issues
        } else if (depth == 2) {
            //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
            geteventsSite = [NSString stringWithFormat:@"http://%@/GetProjectIssues.php?mUser=%@&mPassword=%@&ProjectID=%@",
                             [serverInfo objectAtIndex:0], 
                             [serverInfo objectAtIndex:3],
                             [serverInfo objectAtIndex:4],
                             projectID];
            
            
            
            //open projects
        } else {
            
            NSError *error;
            
            if (!workGroupsArray) {
                //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
                NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                           [serverInfo objectAtIndex:0],
                                           [serverInfo objectAtIndex:3],
                                           [serverInfo objectAtIndex:4],
                                           userIDNum];
                
                NSString *workGroups = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         getWorkGroups]
                                                                encoding:NSASCIIStringEncoding error:&error];
                
                
                NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
                
                if (lastsquiggle.location != NSNotFound) {
                    
                    workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
                    
                } else {
                    workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
                }
                workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];
            }
            
            
            //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
            geteventsSite = [NSString stringWithFormat:@"http://%@/GetProjects.php?mUser=%@&mPassword=%@",
                             [serverInfo objectAtIndex:0], 
                             [serverInfo objectAtIndex:3],
                             [serverInfo objectAtIndex:4]];
            
            
            NSString *projects = [NSString stringWithContentsOfURL: 
                                  [NSURL URLWithString:
                                   geteventsSite]
                                                          encoding:NSASCIIStringEncoding error:&error];
            
            NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
            
            
            if (!allProjects) {
                allProjects = [[projects substringToIndex:
                                lastsquiggle.location]
                               componentsSeparatedByString:@"~-~"];
            }
            
            
            
            //OWN FUNTION ****************
            //loop through and determine if the second item in each array is in the list from tblPermissions
            //if it is, add it on to string and finally return string.
            //****************************
            if (!finalProjectsStr) {
                finalProjectsStr = [self getFinalProjects: allProjects:@"": workGroupsArray: 0];
            }
            
            
            //split up the string and pass it on as nextElements
            
            //ASSIGN NEXTELEMENTS
            elementsArray = [finalProjectsStr componentsSeparatedByString:@"~-~"];
            
            
        }
        
    }
    
    
    if (depth != 1) {
        
        NSError *error;
        
        
        
        //EventName~+~EventID~+~EventDescription
        NSString *events = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             geteventsSite]
                                                    encoding:NSASCIIStringEncoding error:&error];
        
        NSRange lastsquiggle = [events rangeOfString:@"~-~" options:NSBackwardsSearch];
        
        if (lastsquiggle.location != NSNotFound) {
            elementsArray = [[events substringToIndex:
                              lastsquiggle.location]
                             componentsSeparatedByString:@"~-~"];
            
        } else {
            elementsArray = [events componentsSeparatedByString:@"~-~"];
            
            
        }
    }
	
    
    
    if ([[elementsArray objectAtIndex:0] isEqualToString:@""]) {
        titleStr = [NSString stringWithFormat:@"%@(0)",
                    [titleStr substringToIndex:[titleStr rangeOfString:@"("].location]];
    } else {
        titleStr = [NSString stringWithFormat:@"%@(%d)",
                    [titleStr substringToIndex:[titleStr rangeOfString:@"("].location],
                    [elementsArray count]];
        
    }
    
    [titleStr retain];
    [elementsArray retain];
    
    isreloadingTbl = NO;
    [table reloadData];
	
}


- (void) prepareNextView: (RootViewController *)rv {
	rv.userIDNum = userIDNum;
	
	rv.serverInfo = serverInfo;
	
}



- (void) pushAnimationDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context {
    //[table removeFromSuperview];
}



- (void) swapTables:(UITableView *)wasTable :(UITableView *)wasOtherTable {
    
    table = wasOtherTable;
    otherTable = wasTable;
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    
    [userIDNum retain];
    [serverInfo retain];
    	
	//check to see if the username and other info is not yet set.  If not, fetch the info and store it
	
    if (![[elementsArray objectAtIndex:0] isEqualToString:@""]) {
        
        NSArray *nextElements;
        NSString *nextTitle;
        NSString *nextMode;
        NSError *error;
               
        
        //$ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
        //NSArray *userInfo = [serverInfoStr componentsSeparatedByString:@"~-~"];
        
        
        
        if ([mode isEqualToString:@""]) {
            
                   
            [aTableView deselectRowAtIndexPath:indexPath animated:YES];
            //if not in any mode yet and the user selects "events" present the Events options
            if ([[elementsArray objectAtIndex:indexPath.row] isEqualToString:@"Events"]) {
                
                nextElements = [[NSMutableArray alloc] initWithObjects:@"Recent Events", @"Due for Review", @"Active Followup", nil];
                nextTitle = @"Events";
                nextMode = @"Events";
                
                
                
                
            } else if ([[elementsArray objectAtIndex:indexPath.row] isEqualToString:@"Projects"]) {
                
             
                
                NSError *error;
                //Get the projects for the array
                NSString *getProjectsSite = [NSString stringWithFormat:@"http://%@/GetProjectsTest.php?mUser=%@&mPassword=%@&UserID=%@",
                                             [serverInfo objectAtIndex:0], 
                                             [serverInfo objectAtIndex:3],
                                             [serverInfo objectAtIndex:4],
                                             userIDNum];
           
                
                NSString *projects = [NSString stringWithContentsOfURL: 
                                      [NSURL URLWithString:
                                       getProjectsSite] encoding:
                                      NSASCIIStringEncoding error:&error];
                
                
                
                NSRange lastsquiggle = [projects rangeOfString:@"~-~" options:NSBackwardsSearch];
                
                //ASSIGN NEXTELEMENTS
                nextElements = [[projects substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~-~"];
                nextTitle = [NSString stringWithFormat:@"Projects (%d)", [nextElements count]];
                nextMode = @"Projects";
                
            } else {
                
                
                nextElements = [[NSArray alloc] initWithObjects:@"Contacts", @"Companies", @"Projects", nil];
                nextTitle = @"Master Database";
                nextMode = @"Master Database";
                
                
            }
            
           
            if ([nextMode isEqualToString:@"Events"]) {
    
            }
         
            
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        elementsArray, @"elementsArray",
                                        serverInfo, @"serverInfo",
                                        workGroupsArray, @"workGroupsArray",
                                        nil];
            
            
            
            NSDictionary *dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         userIDNum, @"userIDNum",
                                         titleStr, @"titleStr",
                                         mode, @"mode",
                                         [NSString stringWithFormat:@"%d",depth], @"depth",
                                         projectName, @"projectName", 
                                         projectID, @"projectID",
                                         eventMode, @"eventMode",
                                         nil];
            
            [stringStack addObject:dictionary2];
            [stack addObject:dictionary];
            
          
            elementsArray = nextElements;
            [elementsArray retain];
            mode = nextMode;
          //questionable
           // [nextElements release];
            titleStr = nextTitle;
            [titleStr retain];
            depth = depth+1;
            isreloadingTbl = YES;
            backBtn.alpha = 1;
            backLbl.alpha = 1;
            [otherTable reloadData];
            
            
            otherTable.frame = CGRectMake(table.frame.origin.x+table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
            
            CGRect otherTableFinalFrame = table.frame;
            CGRect tableFinalFrame = CGRectMake(table.frame.origin.x-table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
            
            
            // Animate the push
            [UIView beginAnimations: nil context: NULL];
            [UIView setAnimationDelegate: self];
            [UIView setAnimationDuration:.4];
            [UIView setAnimationDidStopSelector: @selector(pushAnimationDidStop:finished:context:)];
            otherTable.frame = otherTableFinalFrame;
            table.frame = tableFinalFrame;
            
            [UIView commitAnimations];
            [self swapTables:table:otherTable];
            
                       

            
            
        } else if ([mode isEqualToString:@"Projects"]) {
            
          
            
            if (depth == 1) {
                
              
                
                [aTableView deselectRowAtIndexPath:indexPath animated:YES];
                
                //make array out of row of elements array.  Use the first part as the title for next view
                //and second part has the idea so we can fetch the issues.
                NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                
                
                //get the open issues that go with the specific project
                
                //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                NSString *getIssuesSite = [NSString stringWithFormat:@"http://%@/GetProjectIssues.php?mUser=%@&mPassword=%@&ProjectID=%@",
                                           [serverInfo objectAtIndex:0], 
                                           [serverInfo objectAtIndex:3],
                                           [serverInfo objectAtIndex:4],
                                           [temp objectAtIndex:1]];
                
                NSString *issues = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     getIssuesSite]
                                                            encoding:NSASCIIStringEncoding error:&error];
                
                NSRange lastsquiggle = [issues rangeOfString:@"~-~" options:NSBackwardsSearch];
                
                
                if (lastsquiggle.location != NSNotFound) {
                    
                    nextElements = [[issues substringToIndex:
                                     lastsquiggle.location]
                                    componentsSeparatedByString:@"~-~"];
                } else {
                    nextElements = [issues componentsSeparatedByString:@"~-~"];
                }
                
                if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                 [temp objectAtIndex:0],
                                 0];
                } else {
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                 [temp objectAtIndex:0],
                                 [nextElements count]];
                }
                
                nextMode = @"Projects";
        
                NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            elementsArray, @"elementsArray",
                                            serverInfo, @"serverInfo",
                                            workGroupsArray, @"workGroupsArray",
                                            nil];
                
                
                
                NSDictionary *dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             userIDNum, @"userIDNum",
                                             titleStr, @"titleStr",
                                             mode, @"mode",
                                             [NSString stringWithFormat:@"%d",depth], @"depth",
                                             projectName, @"projectName", 
                                             projectID, @"projectID",
                                             eventMode, @"eventMode",
                                             nil];
                
                [stringStack addObject:dictionary2];
                [stack addObject:dictionary];
      
                elementsArray = nextElements;
                [elementsArray retain];
                projectName = [temp objectAtIndex:0];
                [projectName retain];
                projectID = [temp objectAtIndex:1];
                [projectID retain];
                titleStr = nextTitle;
                [titleStr retain];
                depth = depth+1;
                isreloadingTbl = YES;
                backBtn.alpha = 1;
                backLbl.alpha = 1;
                [otherTable reloadData];
                //isreloadingTbl = NO;
                
                //For animation
                
                //first it is where you want to move the images to.
                
                // Set up view2
                
                //puts the other table to the right of the centered table
                otherTable.frame = CGRectMake(table.frame.origin.x+table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
                
                //calculates the position of where the two tables should end up
                CGRect otherTableFinalFrame = table.frame;
                CGRect tableFinalFrame = CGRectMake(table.frame.origin.x-table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
               
                
                // describe/set up the animation
                [UIView beginAnimations: nil context: NULL];
                [UIView setAnimationDelegate: self];
                [UIView setAnimationDuration:.4];
                [UIView setAnimationDidStopSelector: @selector(pushAnimationDidStop:finished:context:)];
                
                //put the tables in their final destinations
                otherTable.frame = otherTableFinalFrame;
                table.frame = tableFinalFrame;
               
                [UIView commitAnimations];
                
                //swap the table names because now, otherTable is in the center
                [self swapTables:table:otherTable];
                                 
                
            }else if (depth == 2) {
                
          
                if (indexPath.row != 0) {
                    
                   
                    
                    NSArray *temp = [[elementsArray objectAtIndex:indexPath.row-1] componentsSeparatedByString:@"~+~"];
                    
                    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    //serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
                    NSString *geteventsSite = [NSString stringWithFormat:@"http://%@/GetIssueEvents.php?mUser=%@&mPassword=%@&issueID=%@",
                                               [serverInfo objectAtIndex:0], 
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               [temp objectAtIndex:1], 0];
                    
                    
                    
                    //EventName~+~EventID~+~EventDescription
                    NSString *events = [NSString stringWithContentsOfURL: 
                                        [NSURL URLWithString:
                                         geteventsSite]
                                                                encoding:NSASCIIStringEncoding error:&error];
                    
                    
                    NSRange lastsquiggle = [events rangeOfString:@"~-~" options:NSBackwardsSearch];
                    
                    if (lastsquiggle.location != NSNotFound) {
                        nextElements = [[events substringToIndex:
                                         lastsquiggle.location]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [events componentsSeparatedByString:@"~-~"];
                    }
                    
                    
                    
                    if ([[nextElements objectAtIndex:0] isEqualToString:@""]) {
                        
                        nextTitle = [NSString stringWithFormat:@"%@ (0)", 
                                     [temp objectAtIndex:0],
                                     [nextElements count]];			
                    } else {
                        nextTitle = [NSString stringWithFormat:@"%@ (%d)", 
                                     [temp objectAtIndex:0],
                                     [nextElements count]];	
                    }
                    
                    
                    
                    nextMode = @"Projects";
                
                    
                    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                elementsArray, @"elementsArray",
                                                serverInfo, @"serverInfo",
                                                workGroupsArray, @"workGroupsArray",
                                                nil];
                    
                    
                    
                    NSDictionary *dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 userIDNum, @"userIDNum",
                                                 titleStr, @"titleStr",
                                                 mode, @"mode",
                                                 [NSString stringWithFormat:@"%d",depth], @"depth",
                                                 projectName, @"projectName", 
                                                 projectID, @"projectID",
                                                 eventMode, @"eventMode",
                                                 nil];
                    
                    [stringStack addObject:dictionary2];
                    [stack addObject:dictionary];
                    
                    
                    elementsArray = nextElements;
                    [elementsArray retain];
               
                    titleStr = nextTitle;
                    [titleStr retain];
                    issueName = [temp objectAtIndex:0];
                    [issueName retain];
                    issueID = [temp objectAtIndex:1];
                    [issueID retain];
                 
                    depth = depth+1;
                
                    
                    isreloadingTbl = YES;
                     backBtn.alpha = 1;
                    backLbl.alpha = 1;
                    [otherTable reloadData];
                   
                    
                    otherTable.frame = CGRectMake(table.frame.origin.x+table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
                    
                    CGRect otherTableFinalFrame = table.frame;
                    CGRect tableFinalFrame = CGRectMake(table.frame.origin.x-table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
                    
                    
                    // Animate the push
                    [UIView beginAnimations: nil context: NULL];
                    [UIView setAnimationDelegate: self];
                    [UIView setAnimationDuration:.4];
                    [UIView setAnimationDidStopSelector: @selector(pushAnimationDidStop:finished:context:)];
                    otherTable.frame = otherTableFinalFrame;
                    table.frame = tableFinalFrame;
                    
                    [UIView commitAnimations];
                    [self swapTables:table:otherTable];
                    
                }
            } else if (depth == 3) {
               
                
                if (indexPath.row != 0) {
                    
                        //Here we have to show the files in that event
                    //and we have to have circles in which the user can press to 
                    //select the event
                    
                }
            }
        } else if ([mode isEqualToString:@"Events"]) {
            
            NSString *nextEventMode;
            
            if (depth == 1) {
                [aTableView deselectRowAtIndexPath:indexPath animated:YES];
               
                
                if (indexPath.row == 2) {
                    //assigned to you and you can pick priority level
                                      NSString *eventsString = [self getActiveEvents:2];
                    
                    
                    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
                        nextElements = [[eventsString substringToIndex:
                                         eventsString.length-3]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [eventsString componentsSeparatedByString:@"~-~"];
                    }
                    currentPriority = 1;
                    nextEventMode = @"active";
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)",
                                 [elementsArray objectAtIndex:indexPath.row],
                                 [nextElements count]];
                    
                } else if (indexPath.row == 1) {
                    //*********************************DUE FOR REVIEW**********************************
                    //This is followup day is today or older and work group.
                    //You can select which priority you want to look at
                    
                                       
                    
                    
                    NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                               [serverInfo objectAtIndex:0],
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               userIDNum];
                    
                    
                    
                    NSString *workGroups = [NSString stringWithContentsOfURL: 
                                            [NSURL URLWithString:
                                             getWorkGroups]
                                                                    encoding:NSASCIIStringEncoding error:&error];
                    
                    
                    NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
                    
                    if (lastsquiggle.location != NSNotFound) {
                        
                        workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
                        
                    } else {
                        workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
                    }
                    
                    workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];
                    
                    workGroupStr = [[workGroupsArray objectAtIndex:0] substringFromIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location+3];
                    
                    [workGroupID retain];
                    [workGroupStr retain];
                    
                    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"YYYY-MM-dd"];
                    NSString *today = [format stringFromDate:[NSDate date]];
                    NSString *eventsString = [self getDueEvents:today:4];
                    
                    
                    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
                        nextElements = [[eventsString substringToIndex:
                                         eventsString.length-3]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [eventsString componentsSeparatedByString:@"~-~"];
                    }
                    
                   
                    
                    nextEventMode = @"due";
                    currentPriority = 3;
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)",
                                 [elementsArray objectAtIndex:indexPath.row],
                                 [nextElements count]];
                    
                    [format release];
                    
                    
                } else {
                    //********************************RECENT EVENTS*********************************
                    //created in last 48 hours/take out weekends - look at work group and date created
                    //also allow for choice of priority
                    //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
                    
                                       
                    
                    
                    NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                                               [serverInfo objectAtIndex:0],
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               userIDNum];
                    
                    
                    
                    NSString *workGroups = [NSString stringWithContentsOfURL: 
                                            [NSURL URLWithString:
                                             getWorkGroups]
                                                                    encoding:NSASCIIStringEncoding error:&error];
                    
                    
                    NSRange lastsquiggle = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
                    
                    if (lastsquiggle.location != NSNotFound) {
                        
                        workGroupsArray = [[workGroups substringToIndex:lastsquiggle.location] componentsSeparatedByString:@"~+~"];
                        
                    } else {
                        workGroupsArray = [workGroups componentsSeparatedByString:@"~+~"];
                    }
                    
                    workGroupID = [[workGroupsArray objectAtIndex:0] substringToIndex:[[workGroupsArray objectAtIndex:0] rangeOfString:@"~-~"].location];
                    
                    
                    
                    
                    
                    ////***GETTING THE CORRECT DATE - THREE DAYS PRIOR TO GET THE LAST TWO DAYS NEW EVENTS.
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    NSDate *now = [NSDate date];
                    int daysToAdd = -2;
                    NSDate *afterDate = [now addTimeInterval:60*60*24*daysToAdd];
                    NSDate *finalAfterDate;
                    
                    NSCalendar* cal = [NSCalendar currentCalendar];
                    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:afterDate];
                    
                    //take out the weekends - get the last 48 hours from the week
                    
                    // 1 = Sunday, 2 = Monday, etc.
                    if (([comp weekday]==1)||([comp weekday]==7)) {
                        finalAfterDate = [afterDate addTimeInterval:-60*60*24*3];
                        
                    } else {
                        finalAfterDate = afterDate;
                    }
                    
                    
                    
                    [format setDateFormat:@"YYYY-MM-dd"];
                    NSString *afterDateStr = [format stringFromDate:finalAfterDate];
                    
                    
                    NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&Triage=%d&DateAfter=%@&UserID=%@&WorkGroupID=%@",
                                               [serverInfo objectAtIndex:0], 
                                               [serverInfo objectAtIndex:3],
                                               [serverInfo objectAtIndex:4],
                                               currentPriority+1,
                                               afterDateStr,userIDNum, workGroupID];    
                    
                    NSString *eventsString = [NSString stringWithContentsOfURL: 
                                              [NSURL URLWithString:
                                               getEventsSite] encoding:NSASCIIStringEncoding error:&error];
                    
                    
                    if ([eventsString rangeOfString:@"~-~"].location!=NSNotFound) {
                        nextElements = [[eventsString substringToIndex:
                                         eventsString.length-3]
                                        componentsSeparatedByString:@"~-~"];
                    } else {
                        nextElements = [eventsString componentsSeparatedByString:@"~-~"];
                    }
                    
                    currentPriority = 3;
                    nextEventMode = @"recent";
                    nextTitle = [NSString stringWithFormat:@"%@ (%d)",
                                 [elementsArray objectAtIndex:indexPath.row],
                                 [nextElements count]];
                    
                }
                
                NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            elementsArray, @"elementsArray",
                                            serverInfo, @"serverInfo",
                                            workGroupsArray, @"workGroupsArray",
                                            nil];
                
                
                
                NSDictionary *dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             userIDNum, @"userIDNum",
                                             titleStr, @"titleStr",
                                             mode, @"mode",
                                             [NSString stringWithFormat:@"%d",depth], @"depth",
                                             projectName, @"projectName", 
                                             projectID, @"projectID",
                                             eventMode, @"eventMode",
                                             nil];
                
                [stringStack addObject:dictionary2];
                [stack addObject:dictionary];
                
                
                elementsArray = nextElements;
                [elementsArray retain];
                mode = @"Events";
                eventMode = nextEventMode;
                titleStr = nextTitle;
                [titleStr retain];
                depth = depth+1;
                isreloadingTbl = YES;
                isLoading = YES;
                [otherTable reloadData];
                backBtn.alpha = 1;
                backLbl.alpha = 1;
                isLoading = NO;
                
                otherTable.frame = CGRectMake(table.frame.origin.x+table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
                
                CGRect otherTableFinalFrame = table.frame;
                CGRect tableFinalFrame = CGRectMake(table.frame.origin.x-table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
                
                
                // Animate the push
                [UIView beginAnimations: nil context: NULL];
                [UIView setAnimationDelegate: self];
                [UIView setAnimationDuration:.4];
                [UIView setAnimationDidStopSelector: @selector(pushAnimationDidStop:finished:context:)];
                otherTable.frame = otherTableFinalFrame;
                table.frame = tableFinalFrame;
                
                [UIView commitAnimations];
                [self swapTables:table:otherTable];
                
                
                
            
               
            }else {
                
                if (indexPath.row != 0) {
                    
                //have to show what docs are in the event
                    //have a way for user to select event
                                      
                }
            }
            
        } else {
            
            nextMode = @"Master Database";
            
            if (depth ==1) {
                
                
                if (indexPath.row==0) {
                    nextTitle = @"Contacts";
                    nextElements = [[NSArray alloc] initWithObjects:@"Robert Redford", 
                                    @"Julia Roberts", 
                                    @"Tom Cruise", 
                                    @"Patrick Demsey",
                                    @"Taylor Swift",
                                    nil];
                } else if (indexPath.row==1) {
                    nextTitle = @"Companies";
                    nextElements = [[NSArray alloc] initWithObjects:@"Great Store", 
                                    @"Fred's Furniture", 
                                    @"Craft Shop", 
                                    @"Spy Factory",
                                    @"007 California",
                                    nil];
                } else {
                    nextTitle = @"Projects";
                    nextElements = [[NSArray alloc] initWithObjects:@"Here is a Project", 
                                    @"Big Project", 
                                    @"Small Project", 
                                    @"Cool Project",
                                    @"Project for Fun",
                                    nil];
                }
                
                
            }
            
            RootViewController *listView = [[RootViewController alloc] init];
            listView.allProjects = allProjects;
            listView.finalProjectsStr = finalProjectsStr;
            listView.workGroupsArray = workGroupsArray;
            listView.elementsArray = nextElements;
            listView.titleStr = nextTitle;
            listView.mode = nextMode;
            [listView setDepth:depth+1];
            [self.navigationController pushViewController:listView animated:YES];
            //[[Scrap2AppDelegate splitViewController] presentModalViewController:listView animated:YES];
           // [nextElements release];
        }
    }
}


- (NSString *) getRecentEvents:(NSString *)sofar:(NSArray *)theTemp:(NSString *)date:(int) i:(int)triage {
    
    
    if (i==[theTemp count]) {
        return sofar;
    } else {
        
        NSArray *realTemp = [[theTemp objectAtIndex:i] componentsSeparatedByString:@"~+~"];
        NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetRecentEvents.php?mUser=%@&mPassword=%@&ProjectID=%@&DateAfter=%@&Triage=%d",
                                   [serverInfo objectAtIndex:0], 
                                   [serverInfo objectAtIndex:3],
                                   [serverInfo objectAtIndex:4],
                                   [realTemp objectAtIndex:1],
                                   date, triage];
        
        NSError *error;
        NSString *events = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             getEventsSite]
                                                    encoding:NSASCIIStringEncoding error:&error];
        
        return [self getRecentEvents:[NSString stringWithFormat:@"%@%@",sofar, events]:theTemp:date:i+1:triage];
    }
}






- (NSString *) getActiveEvents:(int)triage {
    
    NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetActiveEvents.php?mUser=%@&mPassword=%@&Triage=%d&UserID=%@",
                               [serverInfo objectAtIndex:0], 
                               [serverInfo objectAtIndex:3],
                               [serverInfo objectAtIndex:4],
                               triage, userIDNum];
    
    NSError *error;
    NSString *events = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:
                         getEventsSite] encoding:NSASCIIStringEncoding error:&error];
    
    return events;
}







- (NSString *) getDueEvents:(NSString *)date:(int)triage {
    
    NSString *getEventsSite = [NSString stringWithFormat:@"http://%@/GetDueEvents.php?mUser=%@&mPassword=%@&WorkGroupID=%@&Date=%@&Triage=%d",[serverInfo objectAtIndex:0],[serverInfo objectAtIndex:3],[serverInfo objectAtIndex:4],workGroupID, date, triage];
    
   
    
    NSError *error;
    NSString *events = [NSString stringWithContentsOfURL: 
                        [NSURL URLWithString:getEventsSite] encoding:NSASCIIStringEncoding error:&error];
    return events;
}


- (IBAction)cancelBtnPressed:(id)sender {
    [appDelegate removeAllFromUpload];
    [appDelegate removeViewFromWindow:self.view];
    
}


- (IBAction)backBtnPressed:(id)sender {
    
    if ([stringStack count]==1) {
        backBtn.alpha = 0;
        backLbl.alpha = 0;
    }
    
    NSDictionary *temps = [stringStack objectAtIndex:[stringStack count]-1];
    NSDictionary *temp = [stack objectAtIndex:[stack count]-1];
    
    elementsArray = [temp objectForKey:@"elementsArray"];
    workGroupsArray = [temp objectForKey:@"workGroupsArray"];
    userIDNum = [temps objectForKey:@"userIDNum"];
    serverInfo = [temp objectForKey:@"serverInfo"];
    titleStr = [temps objectForKey:@"titleStr"];
    if (![temps objectForKey:@"mode"]) {
      
        mode = @"";
    } else {
        mode = [temps objectForKey:@"mode"];
    }
    depth = [[temps objectForKey:@"depth"] intValue];
    projectName = [temps objectForKey:@"projectName"];
    projectID = [temps objectForKey:@"projectID"];
    eventMode = [temps objectForKey:@"eventMode"];
    
    [stack removeObject:temp];
    [stringStack removeObject:temps];
    
    isreloadingTbl = YES;
    [otherTable reloadData];
    
    
    otherTable.frame = CGRectMake(table.frame.origin.x-table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
    
    CGRect otherTableFinalFrame = table.frame;
    CGRect tableFinalFrame = CGRectMake(table.frame.origin.x+table.frame.size.width, table.frame.origin.y, table.frame.size.width, table.frame.size.height);
    
    
    // Animate the push
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration:.4];
    [UIView setAnimationDidStopSelector: @selector(pushAnimationDidStop:finished:context:)];
    otherTable.frame = otherTableFinalFrame;
    table.frame = tableFinalFrame;
    
    [UIView commitAnimations];
    [self swapTables:table:otherTable];
    
}



- (IBAction) uploadBtnPressed:(id)sender {
    [appDelegate importAndSelectFromURL];
    [self cancelBtnPressed:sender];
   
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [elementsArray release];
    [finalProjectsStr release];
    [workGroupsArray release];
    [allProjects release];
    [serverInfo release];
    [titleStr release];
    [mode release];
    [workGroupStr release];
    [allEventsProjects release];
    [workGroupID release];
    [eventMode release];
    [userIDNum release];
    [projectID release];
    [projectName release];
    [popoverController release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
