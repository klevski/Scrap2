//
//  LinksTable.m
//  Scrap2
//
//  Created by Kelsey Levine on 5/24/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "LinksTable.h"


@implementation LinksTable

@synthesize elements, parent, theRoot, eventIDStr;

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [elements count];
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
    
    NSArray *temp = [[elements objectAtIndex:indexPath.row] componentsSeparatedByString:@"~+~"];
    
    NSLog(@"this is temp: %@", temp);
    
    cell.textLabel.text = [temp objectAtIndex:1];
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	
    return cell;
}






#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	[parent updateLink:[elements objectAtIndex:indexPath.row]:YES];

}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEditing:NO animated:YES];
}


- (IBAction) doneBtnPushed:(id)sender {
    NSLog(@"in here");
    if (table.editing) {
        NSLog(@"it is already editing");
        addButton.alpha = 1;
        doneLbl.alpha = 0;
        [self setEditing:NO animated:YES];
    } else {
        NSLog(@"begin editing");
        addButton.alpha = 0;
        doneLbl.alpha = 1;
        [self setEditing:YES animated:YES];
    }
}


//to add new links
- (IBAction) plusBtnPushed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Link" 
                                       message:@""
                                      delegate:self 
                             cancelButtonTitle:@"Cancel" 
                             otherButtonTitles: @"Enter", nil];	
	
	[alert addTextFieldWithValue: @"" label: @"Link Description"];
    [alert addTextFieldWithValue: @"" label: @"Link"];
    
    UITextField *newLinkTxt = [alert textFieldAtIndex:0];
	
	newLinkTxt.keyboardType = UIKeyboardTypeAlphabet;
	newLinkTxt.keyboardAppearance = UIKeyboardAppearanceAlert;
	newLinkTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UITextField *hyplinkTxt = [alert textFieldAtIndex:1];
    hyplinkTxt.keyboardType = UIKeyboardTypeURL;
	hyplinkTxt.keyboardAppearance = UIKeyboardTypeURL;
	hyplinkTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    hyplinkTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
	
	[alert show];
	[alert release];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
  
        UITextField *linkDescTxt = [actionSheet textFieldAtIndex:0];
    
        int linkLength = [linkDescTxt.text length];
        NSRange linkRange = NSMakeRange(0,linkLength);
        NSString *fullLinkDesc = [linkDescTxt.text stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:linkRange];
    
        UITextField *linkTxt = [actionSheet textFieldAtIndex:1];
        NSString *hyperlink = linkTxt.text;

        //********To test if it is a valid hyperlink***********
        
        NSString *withHttp = [NSString stringWithFormat:@"http://%@", hyperlink];
        //******************************************************
        
        if ([hyperlink rangeOfString:@"http://"].location != NSNotFound) {
           
            
            //Add it to the database
            NSString *addLinkSite = [NSString stringWithFormat:@"http://%@/AddEventLink.php?mUser=%@&mPassword=%@&EventID=%@&link=%@&linkDesc=%@",
                                        [theRoot.serverInfo objectAtIndex:0],
                                        [theRoot.serverInfo objectAtIndex:3],
                                        [theRoot.serverInfo objectAtIndex:4],
                                        eventIDStr,hyperlink, fullLinkDesc];
            
            NSError *error;
            
            //returns linkID so can return it to parent
            NSString *addLink = [NSString stringWithContentsOfURL: 
                                    [NSURL URLWithString:
                                     addLinkSite]
                                                            encoding:NSASCIIStringEncoding error:&error];
            
            //Add it to parent list
            [parent addLink:[NSString stringWithFormat:@"%@~+~%@~+~%@", hyperlink, linkDescTxt.text, addLink]];
            
            
            //add it to the elements
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elements];
            [tempMute addObject:[NSString stringWithFormat:@"%@~+~%@~+~%@", hyperlink, linkDescTxt.text, addLink]];
            [elements release];
            elements = tempMute;
            
            [table reloadData];
            
            
        } else {
            //Add withHttp to the database
            //Add it to the database
            NSString *addLinkSite = [NSString stringWithFormat:@"http://%@/AddEventLink.php?mUser=%@&mPassword=%@&EventID=%@&link=%@&linkDesc=%@",
                                     [theRoot.serverInfo objectAtIndex:0],
                                     [theRoot.serverInfo objectAtIndex:3],
                                     [theRoot.serverInfo objectAtIndex:4],
                                     eventIDStr,withHttp, fullLinkDesc];
            
            NSError *error;
            
            //returns linkID so can return it to parent
            NSString *addLink = [NSString stringWithContentsOfURL: 
                                 [NSURL URLWithString:
                                  addLinkSite]
                                                         encoding:NSASCIIStringEncoding error:&error];
            
            
            //add it to the elements
            NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elements];
            [tempMute addObject:[NSString stringWithFormat:@"%@~+~%@~+~%@", withHttp, linkDescTxt.text,addLink]];
            [elements release];
            elements = tempMute;
            
            [table reloadData];
            
            //Add it to parent list
            [parent addLink:[NSString stringWithFormat:@"%@~+~%@~+~%@", withHttp, linkDescTxt.text, addLink]];     
        
        }        
    }
}


// so we can make it eliminate the possibility to delete rows.
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewCellEditingStyleDelete;
	
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return YES;
	
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [table setEditing:editing animated:YES];
	
}



- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	//need to delete the link from table and from database
    
	
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *linkID = [[[elements objectAtIndex:indexPath.row] componentsSeparatedByString:@"~+~"] objectAtIndex:2];
        
        NSLog(@"linkID: %@", linkID);
        
        //remove from table
        NSMutableArray *tempMute = [[NSMutableArray alloc] initWithArray:elements];
        [tempMute removeObjectAtIndex:indexPath.row];
        elements = tempMute;
        
        if (indexPath.row == 0) {
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        } else if (indexPath.row == [elements count]-1) {
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        } else {
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
        //remove from database
        NSString *deleteLinkSite = [NSString stringWithFormat:@"http://%@/DeleteEventLink.php?mUser=%@&mPassword=%@&EventID=%@&linkID=%@",
                                 [theRoot.serverInfo objectAtIndex:0],
                                 [theRoot.serverInfo objectAtIndex:3],
                                 [theRoot.serverInfo objectAtIndex:4],
                                 eventIDStr,linkID];

        NSError *error;
        
        NSString *deleteLink = [NSString stringWithContentsOfURL: 
                             [NSURL URLWithString:
                              deleteLinkSite]
                                                     encoding:NSASCIIStringEncoding error:&error];
        
        [parent removeLinkatIndex:indexPath.row];
        
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
