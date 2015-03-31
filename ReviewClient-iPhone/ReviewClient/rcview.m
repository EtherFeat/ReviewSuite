//
//  reviewclientiphoneSecondViewController.m
//  ReviewClient
//
//  Created by Alex Zheludov on 5/23/12.
//  Copyright (c) 2012 ETHERFEAT. All rights reserved.
//

#import "rcview.h"
#import "rclist.h"
#import "reviewclientiphoneAppDelegate.h"
@implementation rcview
@synthesize webView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  // self
  }

- (void)viewDidUnload
{
    [self setWebView:nil];
    webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  reviewclientiphoneAppDelegate *list = (reviewclientiphoneAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSLog(@"%@",list.filepath);
  NSURL *url = [NSURL fileURLWithPath:list.filepath ];//path to a file
  NSURLRequest *request = [NSURLRequest requestWithURL:url];//creating request
  [webView loadRequest:request]; //loading request into WebView
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
