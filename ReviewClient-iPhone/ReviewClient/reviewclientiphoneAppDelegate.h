//
//  reviewclientiphoneAppDelegate.h
//  ReviewClient
//
//  Created by Alex Zheludov on 5/23/12.
//  Copyright (c) 2012 ETHERFEAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reviewclientiphoneAppDelegate : UIResponder <UIApplicationDelegate>
{
  NSString* filepath;

}
@property (strong, nonatomic) UIWindow *window;
@property (readwrite ,strong, nonatomic) NSString *filepath;


@end
