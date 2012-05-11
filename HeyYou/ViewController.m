//
//  ViewController.m
//  HeyYou
//
//  Created by T. Binkowski on 5/10/12.
//  Copyright (c) 2012 University of Chicago. All rights reserved.
//

#import "ViewController.h"
#import "GTMHTTPFetcher.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize dateLabel;
@synthesize nameField;
@synthesize nameLabel;
@synthesize bigImage;
@synthesize spinner;

/*******************************************************************************
 * @method      <# method #>
 * @abstract    <# abstract #>
 * @description <# description #>
 *******************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Register our custom notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNotification:) name:@"mobi.uchicago.date" object:nil];
 
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(theKeyboardAppeared:)
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(theKeyboardDisappeared:)
                                                 name:UIKeyboardDidHideNotification
                                               object:self.view.window];
}

- (void)viewDidAppear:(BOOL)animated
{
}


- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [self setNameField:nil];
    [self setNameLabel:nil];
    [self setBigImage:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Notifications
/*******************************************************************************
 * @method      postNotification
 * @abstract    Post on background thread using Grand Central Dispatch
 * @description <# description #>
 *******************************************************************************/
- (void)postNotification
{
   
}

/*******************************************************************************
 * @method      gotNotification
 * @abstract    Method called by Notification Center when mobi.uchicago.date is received
 * @description <# description #>
 *******************************************************************************/
- (void)gotNotification:(NSNotification *)notif {

    NSLog(@">>>> Notification Center Recieved: %@",notif);
    NSDate *dateObject = (NSDate*)[notif object];

    // Update UI; needs be on main thread
    //[self performSelectorOnMainThread:@selector(updateLabel:) withObject:[dateObject description] waitUntilDone:YES];
    self.dateLabel.text = [NSString stringWithFormat:@"Image Downloaded on %@",
                           [dateObject description]];
}

/*******************************************************************************
 * @method      updateLabel
 * @abstract    <# abstract #>
 * @description <# description #>
 *******************************************************************************/
- (void)updateLabel:(NSString*)theString
{
    self.dateLabel.text = theString;
}

#pragma mark - System Notifications
/*******************************************************************************
 * @method      theKeyboardAppeared/Disappeared
 * @abstract    Move the date label so it is not obstructed by the keyboard
 * @description <# description #>
 *******************************************************************************/
- (void)theKeyboardAppeared:(id)sender
{
    NSLog(@"Keyboard Appeared");
    self.dateLabel.center = CGPointMake(160,150);
}

- (void)theKeyboardDisappeared:(id)sender
{
    NSLog(@"Keyboard Appeared");
    self.dateLabel.center = CGPointMake(160,420);
}

#pragma mark - Text Field Delegate
/*******************************************************************************
 * @method      textFieldShouldReturn:
 * @abstract    Return button is hit
 *******************************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField*)sender
{
    [sender resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text Field Begins");
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    NSLog(@"String:%@",sender.text);
    self.nameLabel.text = [NSString stringWithFormat:@"Hello: %@",sender.text];
    [self scheduleNotification:sender.text];
}

#pragma mark - Push Notifications
/*******************************************************************************
 * @method          scheduleNotification
 * @abstract        Local notification that fires 25 seconds after being set
 * @description     <# Description #>
 ******************************************************************************/
- (void)scheduleNotification:(NSString*)theName
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:25]; // fire in 25 seconds
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = [NSString stringWithFormat:@"Hey %@!  It's a minute later",theName];
    localNotif.alertAction = @"View";  	// Set the action button text	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 111;
	
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
	
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSLog(@">>>> Local Notification Scheduled:\n%@",localNotif);
}

#pragma mark - Download image in background
/*******************************************************************************
 * @method          downloadBigImageButton:
 * @abstract        When tapped call download method
 * @description     <# Description #>
 ******************************************************************************/
- (IBAction)downloadBigImageButton:(id)sender 
{
    [self downloadBigImage];
}

/*******************************************************************************
 * @method      downloadBigImage
 * @abstract    Download image from URL using Google GTM-HTTP Fetcher
 * @description The UIActivityIndicator (spinner) starts when called and stops when the image is downloaded
 *******************************************************************************/
- (void)downloadBigImage
{
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/home/images/ipad_hero.jpg"];
    [self.spinner startAnimating];

    GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:[NSURLRequest requestWithURL:url]];
    [myFetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if (error != nil) {
            // Log error
            NSLog(@"ERROR:%@",error);
        } else {
            // Update the UIImageView image property with the downloaded image
            NSLog(@"Image downloaded ");
            sleep(3); // Simulate bad internet connection
            
            // Convert data to image
            UIImage *image = [UIImage imageWithData:retrievedData];
            self.bigImage.image = image;
            
            [self.spinner stopAnimating];
            
            // Send Notification that we received the image
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mobi.uchicago.date" object:[NSDate date]];
            
        }
    }];
}


@end
 


