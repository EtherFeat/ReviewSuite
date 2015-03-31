//
//  RCFDLib.h
//  RemoveOldFilePractice
//
//  Created by Alex on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RCFDLib : NSObject

+(int)removeFiles:(NSString*)pathToFolder;
+(NSString*)getCurrentDate;
+(NSString*)getFolderLastDate:(NSString*)path;


@end
