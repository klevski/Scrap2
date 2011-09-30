//
//  DocumentDisplayView.m
//  Scrap2
//
//  Created by Kelsey Levine on 6/27/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import "DocumentDisplayView.h"


@implementation DocumentDisplayView

@synthesize pdfUrl;

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
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"pdf"]; // Giving the path as the resource and the name of the pdf to load.
    //pdfUrl = [NSURL fileURLWithPath:path]; // creating a fileurl from path
    [webView loadRequest:[NSURLRequest requestWithURL:pdfUrl]]; // Loading the url request using the url to a webview.

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
