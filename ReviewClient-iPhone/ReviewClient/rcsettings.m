//
//  rcsettings.m
//  ReviewClient
//
//  Created by Alex Zheludov on 5/23/12.
//  Copyright (c) 2012 EtherFeat. All rights reserved.
//

#import "rcsettings.h"
#import "reviewclientiphoneAppDelegate.h"

@implementation rcsettings


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
  NSString *settingsFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"rcsettings.plist"];
  NSString *primary = [[NSString alloc] init];  
  NSString *secondary = [[NSString alloc] init]; 
  NSString *toriary = [[NSString alloc] init];
  NSString *timeOut = [[NSString alloc] init];
  NSMutableDictionary *savedSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    primary = [savedSettings objectForKey:@"PrimaryServer"];  
    secondary = [savedSettings objectForKey:@"SecondaryServer"]; 
    toriary = [savedSettings objectForKey:@"TertiaryServer"];
    timeOut = [savedSettings objectForKey:@"PingTimeOut"];
  [primaryServerField setText:primary];
  [secondaryServerField setText:secondary];
  [tertiaryServerField setText:toriary];
  [timeOutField setText:timeOut];
}
  
- (void)viewDidUnload
{
  timeOutField = nil;
  primaryServerField = nil;
  secondaryServerField = nil;
  tertiaryServerField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveButton:(id)sender {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
  NSString *settingsFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"rcsettings.plist"];
  NSMutableDictionary *savedSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
  [savedSettings setObject:primaryServerField.text forKey:@"PrimaryServer"];
  [savedSettings setObject:secondaryServerField.text forKey:@"SecondaryServer"];
  [savedSettings setObject:tertiaryServerField.text forKey:@"TertiaryServer"];
  [savedSettings setObject:timeOutField.text forKey:@"PingTimeOut"];
  [savedSettings writeToFile:settingsFile atomically:YES];
  [primaryServerField resignFirstResponder];
  [secondaryServerField resignFirstResponder];
  [tertiaryServerField resignFirstResponder];
  [timeOutField resignFirstResponder];
}

- (IBAction)cancelButton:(id)sender {
  [primaryServerField resignFirstResponder];
  [secondaryServerField resignFirstResponder];
  [tertiaryServerField resignFirstResponder];
  [timeOutField resignFirstResponder];
}
@end
