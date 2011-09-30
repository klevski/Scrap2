//
//  DocImageView.h
//  Scrap2
//
//  Created by Kelsey Levine on 5/23/11.
//  Copyright 2011 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DocImageView : UIViewController {
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *shadow;
    IBOutlet UILabel *border;
    IBOutlet UILabel *bottomCover;
    NSString *imageViewStr;
}


@property (nonatomic, retain) NSString *imageViewStr;

@end
