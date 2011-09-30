//
//  WorkGroupTblView.m
//  Scrap2
//
//  Created by Kelsey Levine on 5/28/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "WorkGroupTblView.h"


@implementation WorkGroupTblView

@synthesize theRoot, elements, contactParent;

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
     if ((!searching) && (![titleLbl.text isEqualToString:@"Work Groups"])) {
         return [elements count];
     } else {
         return 1;
     }
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     if ((!searching) && (![titleLbl.text isEqualToString:@"Work Groups"])) {
         return [[elements objectAtIndex:section] count];
     }else if(searching) {
         return [copyList count];
     } else {
         return [elements count];
     }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    for(UIView *view in [tableView subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            
            [view setBackgroundColor:[UIColor clearColor]];
            [view setFont:[UIFont fontWithName:@"Cochin" size:14]];
        }
    }
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    
    
    if ([titleLbl.text isEqualToString:@"Companies"] || [titleLbl.text isEqualToString:@"Categories"]) {
        
        if (searching) {
            NSRange separater = [[copyList objectAtIndex:indexPath.row] rangeOfString:@"~+~"];
            cell.textLabel.text = [[copyList objectAtIndex:indexPath.row] substringToIndex:separater.location];
       
        } else {
        
            NSRange separater = [[[elements objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] rangeOfString:@"~+~"];
            cell.textLabel.text = [[[elements objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] substringToIndex:separater.location];
            
        }
        cell.textLabel.font = [UIFont fontWithName:@"Cochin" size:14];
        
    } else {
    
        NSRange separater = [[elements objectAtIndex:indexPath.row] rangeOfString:@"~-~"];
        cell.textLabel.text = [[elements objectAtIndex:indexPath.row] substringFromIndex:separater.location+3];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
	
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![titleLbl.text isEqualToString:@"Work Groups"]) {

        if (searching) {
            if (contactParent) {
                [contactParent updateCompany:[copyList objectAtIndex:indexPath.row]];
            } else {
                [theRoot updateWorkGroupSelected:[copyList objectAtIndex:indexPath.row]:NO];
            }
        } else {
            if (contactParent) {
                [contactParent updateCompany:[[elements objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            } else {
                [theRoot updateWorkGroupSelected:[[elements objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]:NO];
            }
        }
    } else {
        [theRoot updateWorkGroupSelected:[elements objectAtIndex:indexPath.row]:NO];
    }
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
    
    NSError *error;
    
    
    searching = NO;
    copyList = [[NSMutableArray alloc] init];
    indexArray = [[NSMutableArray alloc] init];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    searchBar.barStyle=UIBarStyleDefault;
    searchBar.showsCancelButton=NO;
    searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    searchBar.delegate=self;
   
    table.tableHeaderView=searchBar;
    

    
    
    elements = [[NSArray alloc] init];
    
    if ([theRoot.mode isEqualToString:@"Contacts"] || contactParent) {
        titleLbl.text = @"Companies";
        
        NSString *getCompanies = [NSString stringWithFormat:@"http://%@/GetCompanies.php?mUser=%@&mPassword=%@",
                                   [theRoot.serverInfo objectAtIndex:0],
                                   [theRoot.serverInfo objectAtIndex:3],
                                   [theRoot.serverInfo objectAtIndex:4]];
        
        NSLog(@"getCompanies: %@", getCompanies);
        
        NSString *companies = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 getCompanies]
                                                        encoding:NSASCIIStringEncoding error:&error];
        
        NSLog(@"companies: %@", companies);
        NSRange lastsquiggle1 = [companies rangeOfString:@"~-~" options:NSBackwardsSearch];
        
        NSArray *elelements;
        if (lastsquiggle1.location != NSNotFound) {
            
            elelements = [[NSString stringWithFormat:@"All Companies~+~0000~-~%@",[companies substringToIndex:lastsquiggle1.location]] componentsSeparatedByString:@"~-~"];
            
        } else {
            elelements = [[NSString stringWithFormat:@"All Companies~+~0000~-~%@", companies] componentsSeparatedByString:@"~-~"];
        }
        
        
        [indexArray removeAllObjects];
        [indexArray addObject:@"{search}"];
        
        [elelements retain];
        
        
        elements = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[elelements count]:[[elelements objectAtIndex:0] substringToIndex:1] :elelements];
  

        
    } else if ([theRoot.mode isEqualToString:@"Companies"]) {
        titleLbl.text = @"Categories";
        
        NSString *getCategories = [NSString stringWithFormat:@"http://%@/GetCompanyCategories.php?mUser=%@&mPassword=%@",
                                   [theRoot.serverInfo objectAtIndex:0],
                                   [theRoot.serverInfo objectAtIndex:3],
                                   [theRoot.serverInfo objectAtIndex:4]];
        
        
        
        NSString *categories = [NSString stringWithContentsOfURL: 
                                [NSURL URLWithString:
                                 getCategories]
                                                        encoding:NSASCIIStringEncoding error:&error];
        
        
        NSRange lastsquiggle1 = [categories rangeOfString:@"~-~" options:NSBackwardsSearch];
        
        NSArray *elelements;
        
        if (lastsquiggle1.location != NSNotFound) {
            
            elelements = [[NSString stringWithFormat:@"All Categories~+~0000~-~%@",[categories substringToIndex:lastsquiggle1.location]] componentsSeparatedByString:@"~-~"];
            
        } else {
            elelements = [[NSString stringWithFormat:@"All Categories~+~0000~-~%@",categories ] componentsSeparatedByString:@"~-~"];
        }

        
        [indexArray removeAllObjects];
        [indexArray addObject:@"{search}"];
        
        [elelements retain];
        
        
        elements = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[elelements count]:[[elelements objectAtIndex:0] substringToIndex:1] :elelements];
        
        

        
        
    } else {

    
    
    //go to tblPermissions and get 'PMID' From rows WHERE UserID = userIDNum, ~+~ between
    NSString *getWorkGroups = [NSString stringWithFormat:@"http://%@/GetUserWorkGroups.php?mUser=%@&mPassword=%@&userId=%@",
                               [theRoot.serverInfo objectAtIndex:0],
                               [theRoot.serverInfo objectAtIndex:3],
                               [theRoot.serverInfo objectAtIndex:4],
                               theRoot.userIDNum];
    
    
    
    NSString *workGroups = [NSString stringWithContentsOfURL: 
                            [NSURL URLWithString:
                             getWorkGroups]
                                                    encoding:NSASCIIStringEncoding error:&error];
    
    
    NSRange lastsquiggle1 = [workGroups rangeOfString:@"~+~" options:NSBackwardsSearch];
    
    if (lastsquiggle1.location != NSNotFound) {
        
        elements = [[workGroups substringToIndex:lastsquiggle1.location] componentsSeparatedByString:@"~+~"];
        
    } else {
        elements = [workGroups componentsSeparatedByString:@"~+~"];
    }

    }
    
    [elements retain];
    
    
        
}


//******************************* Indices & Sections *************************************

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((!searching) && (![titleLbl.text isEqualToString:@"Work Groups"])) {
        return [[[[elements objectAtIndex:section] objectAtIndex:0] substringToIndex:1] capitalizedString];
    } else {
        return nil;
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if((!searching) && (![theRoot.mode isEqualToString:@"Events"]) && ([self numberOfRowsInTable]>6)) {
        return indexArray;
	} else {
		return nil;
	}
    
}


- (int) numberOfRowsInTable {
    int i = 0;
    for (int k = 0; k < [elements count]; ++k) {
        i = i + [[elements objectAtIndex:k] count];
    }
    return i;
}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	//[self doneSearching_Clicked:nil];
	
    if(searching) {
		return -1;
	} else {
        
        if (index == 0) {
            [tableView setContentOffset:CGPointZero animated:NO];
            return NSNotFound;
        } else {
            return index-1;
        }
	}
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    if ((!searching) && (![titleLbl.text isEqualToString:@"Work Groups"])) {
        
        NSString *sectionTitle;
        
        sectionTitle = [[[[elements objectAtIndex:section] objectAtIndex:0] substringToIndex:1] capitalizedString];

        
        // Create label with section title
        UILabel *label = [[[UILabel alloc] init] autorelease];
        label.frame = CGRectMake(10, 0, 230, 23);
        label.textColor = [UIColor blackColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.font = [UIFont fontWithName:@"Cochin" size:17];
        label.text = sectionTitle;
        label.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeaderBG.png"]];
        
        // Create header view and add label as a subview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
        view.backgroundColor = [UIColor blackColor];
        [view autorelease];
        [view addSubview:imageView];
        [view addSubview:label];
        
        return view;
        
	} else {
        return nil;
    }
    
    
}


//****************************************************************************



- (NSArray *) generateFinalList:(NSMutableArray *)soFar:(int)index:(int)total:(NSString *)letter:(NSArray *)people {
	
    
	if (index == total) {
        
		if ([[indexArray objectAtIndex:[indexArray count]-1] caseInsensitiveCompare:letter]!=NSOrderedSame) {
            [indexArray addObject:[letter capitalizedString]];
        }
        NSArray *theTemp = [[[NSArray alloc] initWithArray:soFar] autorelease];
        [indexArray retain];
        return theTemp;
        
    } else if ([[[people objectAtIndex:index] substringToIndex:1] caseInsensitiveCompare:letter]!=NSOrderedSame) {
		[soFar addObject:[[NSMutableArray alloc] initWithObjects:
						  [people objectAtIndex:index], nil]];
		[indexArray addObject:[letter capitalizedString]];
		return [self generateFinalList:soFar :index+1 :total :[[people objectAtIndex:index] substringToIndex:1]:people];
        
	} else {
		
		[[soFar objectAtIndex:[soFar count]-1] addObject:[people objectAtIndex:index]];
		return [self generateFinalList:soFar :index+1 :total :letter:people];
		
	}
}



///*************************************** Search stuff **************************************************


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyList removeAllObjects];
    
	if([searchText length] > 0) {
		searching = YES;
		//self.tableView.scrollEnabled = YES;
		[self searchTableView];
        
    } else {
        
        for (NSMutableArray *array in elements)
        {
            [copyList addObjectsFromArray:array];
        }
        
		
	}
    [table reloadData];
}





- (void) searchTableView {
	
    
	searching = YES;
	
    NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSMutableArray *array in elements)
	{
		[searchArray addObjectsFromArray:array];
	}
    
    
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if (titleResultsRange.length > 0)
			[copyList addObject:sTemp];
	}
	
   [searchArray release];
	searchArray = nil;
}




- (IBAction)searchBarCancelButtonClicked:(id)sender {
	
    searchBar.text = @"";
	[searchBar resignFirstResponder];
	doneButton.alpha = 0;
   	searching = NO;
    [table reloadData];
	
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
    if (!searching) {
        
        searching = YES;
        for (NSMutableArray *array in elements)
        {
            [copyList addObjectsFromArray:array];
        }
        
        
        //  [searchBar becomeFirstResponder];
      
        table.scrollEnabled =YES;
        self.view.userInteractionEnabled = YES;
        
        [table reloadData];
    }
	
    doneButton.alpha = 1;
}





//*******************************************************************************************************

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
