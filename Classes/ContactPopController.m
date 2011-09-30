//
//  ContactPopController.m
//  Scrap2
//
//  Created by Kelsey Levine on 5/9/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "ContactPopController.h"
#import "OverlayViewController.h"

@implementation ContactPopController

@synthesize people, table, parent, theRoot, finalList, indexArray;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSError *error;
	copyList = [[NSMutableArray alloc] init];
	self.table.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searching = NO;
	letUserSelectRow = YES;
	indexArray = [[NSMutableArray alloc] init];
	
	NSString *getContacts = [NSString stringWithFormat:@"http://%@/GetContacts.php?mUser=%@&mPassword=%@",
								[theRoot.serverInfo objectAtIndex:0], 
								[theRoot.serverInfo objectAtIndex:3],
								[theRoot.serverInfo objectAtIndex:4]];
	
	//ContactName~+~ContactID
	NSString *contacts = [NSString stringWithContentsOfURL: 
						   [NSURL URLWithString:
							getContacts]
							encoding:NSASCIIStringEncoding error:&error];
	
	NSRange lastsquiggle = [contacts rangeOfString:@"~-~" options:NSBackwardsSearch];
	
	if (lastsquiggle.location != NSNotFound) {
		people = [[contacts substringToIndex:
				   lastsquiggle.location]
				  componentsSeparatedByString:@"~-~"];
	} else {
		people = [contacts componentsSeparatedByString:@"~-~"];
	}
	
	[people retain];
	[indexArray addObject:@"{search}"];
	
	finalList = [self generateFinalList:[[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]init], nil]:0:[people count]:[[people objectAtIndex:0] substringToIndex:1]];
	
	[finalList retain];
	
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyList removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.table.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		[self.table insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.table.scrollEnabled = NO;
	}
	
	[self.table reloadData];
}



- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	//searching = YES;
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSMutableArray *array in finalList)
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


- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.table.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.table reloadData];
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	//CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, 10, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.cpController = self;
	
	[self.table insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	
	searching = YES;
	letUserSelectRow = NO;
	self.table.scrollEnabled = NO;
	
	//Add the done button.
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
	//										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	//										   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if(searching) {
		return nil;
	} else {
		return indexArray;
	}

}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	[self doneSearching_Clicked:nil];
	
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

- (NSMutableArray *) generateFinalList:(NSMutableArray *)soFar:(int)index:(int)total:(NSString *)letter {
	
	
	if (index == total) {
        if ([[indexArray objectAtIndex:[indexArray count]-1] caseInsensitiveCompare:letter]!=NSOrderedSame) {
            [indexArray addObject:[letter capitalizedString]];
        }
		return soFar;
	} else if ([[[people objectAtIndex:index] substringToIndex:1] caseInsensitiveCompare:letter]!=NSOrderedSame) {
		[soFar addObject:[[NSMutableArray alloc] initWithObjects:
						  [people objectAtIndex:index], nil]];
		[indexArray addObject:[letter capitalizedString]];
		return [self generateFinalList:soFar :index+1 :total :[[people objectAtIndex:index] substringToIndex:1]];
	
	} else {
		
		[[soFar objectAtIndex:[soFar count]-1] addObject:[people objectAtIndex:index]];
		return [self generateFinalList:soFar :index+1 :total :letter];
		
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    if (searching)
		return 1;
	else
		return [finalList count];

}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	if (searching) {
		return [copyList count];
	} else {
		return [[finalList objectAtIndex:section] count];
	}
		
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (searching) {
		return @"";
	} else {
		return [[[[finalList objectAtIndex:section] objectAtIndex:0] substringToIndex:1] capitalizedString];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	if (!searching) {
		NSArray *temp = [finalList objectAtIndex:indexPath.section];
		
		cell.textLabel.text = [[temp objectAtIndex:indexPath.row] substringToIndex:
							   [[temp objectAtIndex:indexPath.row] rangeOfString:@"~+~"].location];
	} else {
		cell.textLabel.text = [[copyList objectAtIndex:indexPath.row] substringToIndex:
							   [[copyList objectAtIndex:indexPath.row] rangeOfString:@"~+~"].location];
	}

	
	
	
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *contact;
	if (!searching) {
		// normal table view population
		contact=[[finalList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	} else {
		contact = [copyList objectAtIndex:indexPath.row];
	}

	[self doneSearching_Clicked:nil];
	[parent changeContact:contact:YES];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)viewWillUnload {
    [self doneSearching_Clicked:nil];
}

- (void)dealloc {
    [super dealloc];
}


@end
