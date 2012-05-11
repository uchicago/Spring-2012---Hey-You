//
//  ViewController.h
//  HeyYou
//
//  Created by T. Binkowski on 5/10/12.
//  Copyright (c) 2012 University of Chicago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Actions
- (IBAction)downloadBigImageButton:(id)sender;

@end
