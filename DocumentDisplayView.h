//
//  DocumentDisplayView.h
//  Scrap2
//
//  Created by Kelsey Levine on 6/27/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DocumentDisplayView : UIViewController {
    IBOutlet UIWebView *webView;
    NSURL *pdfUrl;
}

@property (nonatomic, retain) NSURL *pdfUrl;

@end
