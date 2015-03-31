//
//  InstallerForReviewClientPane.m
//  InstallerForReviewClient
//
//  Created by Alex on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InstallerForReviewClientPane.h"

@implementation InstallerForReviewClientPane

- (NSString *)title
{
	return [[NSBundle bundleForClass:[self class]] localizedStringForKey:@"PaneTitle" value:nil table:nil];
}

@end
