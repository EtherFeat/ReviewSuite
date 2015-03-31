//
//  RCLib.h
//  ReviewMac
//
//  Created by Alex on 10/15/11.
//  Copyright 2011 EtherFeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCFDLib.h"
#import "ReviewMacAppDelegate.h"

@interface RCLib : NSObject
+(NSString*)getPath:(char)type;
+(NSString*)downloadFile:(NSString*)name url:(NSString*)server;
+(void)checkDates;


@end
