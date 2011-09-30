//
//  personPopController.m
//  Scrap2
//
//  Created by Kelsey Levine on 4/26/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "personPopController.h"


@implementation personPopController

@synthesize people, table, parent, theRoot;


- (void)viewDidLoad {
[super viewDidLoad];
	
	//serverInfo: $ServerIPAddress~-~$ServerUserName~-~$ServerPassword~-~$MysqlUserName~-~$MysqlPassword
	NSString *getPMIDSite = [NSString stringWithFormat:@"http://%@/GetProjectPMID.php?mUser=%@&mPassword=%@&ProjectID=%@",
							   [theRoot.serverInfo objectAtIndex:0], 
							   [theRoot.serverInfo objectAtIndex:3],
							   [theRoot.serverInfo objectAtIndex:4],
							   theRoot.projectID];
	
	NSError *error;
	
	
	
	
	//EventName~+~EventID~+~EventDescription
	NSString *PMID = [NSString stringWithContentsOfURL: 
						[NSURL URLWithString:
						 getPMIDSite]
						encoding:NSASCIIStringEncoding error:&error];
	
	
	
	NSString *getPMIDGroup = [NSString stringWithFormat:@"http://%@/GetPMIDGroup.php?mUser=%@&mPassword=%@&PMID=%@",
							 [theRoot.serverInfo objectAtIndex:0], 
							 [theRoot.serverInfo objectAtIndex:3],
							 [theRoot.serverInfo objectAtIndex:4],
							 PMID];
	
	
	
	
	//EventName~+~EventID~+~EventDescription
	NSString *PMIDGroup = [NSString stringWithContentsOfURL: 
					  [NSURL URLWithString:
					   getPMIDGroup]
					encoding:NSASCIIStringEncoding error:&error];
	
	NSLog(@"PMIDGroup: %@", PMIDGroup);
	
	
	
	NSRange lastsquiggle = [PMIDGroup rangeOfString:@"~-~" options:NSBackwardsSearch];
	
	if (lastsquiggle.location != NSNotFound) {
		people = [[PMIDGroup substringToIndex:
						 lastsquiggle.location]
						componentsSeparatedByString:@"~-~"];
	} else {
		people = [PMIDGroup componentsSeparatedByString:@"~-~"];
	}
	
	[people retain];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [people count];
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
    
    NSRange separater = [[people objectAtIndex:indexPath.row] rangeOfString:@"~+~"];
    cell.textLabel.text = [[people objectAtIndex:indexPath.row] substringToIndex:separater.location];
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	[parent changePersonAssigned:[people objectAtIndex:indexPath.row]:YES];
	

	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
