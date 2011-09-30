//
//  DocumentsListView.m
//  Scrap2
//
//  Created by Kelsey Levine on 5/24/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "DocumentsListView.h"
#import "LegendViewController.h"
#import "DocImageView.h"
#import "ContractView.h"

@implementation DocumentsListView

@synthesize elementsArray, parent;

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
    
       
    
    elementsArray = [[NSMutableArray alloc] 
					 initWithObjects:
                     [[NSMutableArray alloc]
                      initWithObjects:
                      @"Steel Erection", 
                      @"Building Enclosed", 
                      @"Ready for Guests",
                      nil],
                     [[NSMutableArray alloc]
                      initWithObjects:
                      @"Architect's Contract",
                      @"Interior Finish Legend",
                      @"Unit Plans Finish Key",
                      nil],
                     nil];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[elementsArray objectAtIndex:section] count];
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
	
	
    cell.textLabel.text = [[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Fairwinds Hotel Photos";
    } else {
        return @"Residence Documents";
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //unhighlight the selection
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([[[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Interior Finish Legend"]) {
        
        LegendViewController *legend = [[LegendViewController alloc] initWithNibName:@"LegendView" bundle:nil];
        legend.title = @"Interior Finish Legend";
        [parent updateDocumentSelected:
         [[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]:
         legend];
        
    } else if ([[[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Unit Plans Finish Key"]) {
        
        DocImageView *doc = [[DocImageView alloc] initWithNibName:@"DocImageView" bundle:nil];
        doc.imageViewStr = [NSString stringWithFormat:@"FairWindsFloorPlan.png",indexPath.row+1];
        [parent updateDocumentSelected:
         [[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]:
         doc];
        
    } else if ([[[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Architect's Contract"]) {
        
        ContractView *doc = [[ContractView alloc] initWithNibName:@"ContractView" bundle:nil];
        [parent updateDocumentSelected:
         [[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]:
         doc];
        
        
    } else {
    
        DocImageView *doc = [[DocImageView alloc] initWithNibName:@"DocImageView" bundle:nil];
        doc.imageViewStr = [NSString stringWithFormat:@"FairLand%d.jpg",indexPath.row+1];
        [parent updateDocumentSelected:
         [[elementsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]:
         doc];
    }
    
	
}


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
