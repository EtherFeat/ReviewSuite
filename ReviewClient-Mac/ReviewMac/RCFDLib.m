//
//  RCFDLib.m
//  RemoveOldFilePractice
//
//  Created by Alex on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCFDLib.h"

@implementation RCFDLib
+(NSString*)getCurrentDate{
    NSDate *date = [[NSDate alloc] init];
    NSArray *temparray = [[NSArray alloc] init];
    temparray = [[date description] componentsSeparatedByString:@" "];
    NSString* currentDate = [temparray objectAtIndex:0];
    return currentDate;
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(int)removeFiles:(NSString *)pathToFolder
{
    NSFileManager* fileManager = [[NSFileManager alloc]init];
    int amountRemovedFolders=0;
    NSError* error = nil;
    NSArray* content = [fileManager contentsOfDirectoryAtPath:pathToFolder error:&error];
    NSMutableArray* foldersToCheck = [[NSMutableArray alloc]init];
    NSLog(@"%@",content);
    
    for (NSString* item in content) {
        if ([item characterAtIndex:0]!='.') {
            
            [foldersToCheck addObject:[pathToFolder stringByAppendingPathComponent:item]];
        }
        
    }
    for(NSString* folder in foldersToCheck)
    {
        NSString* currentDate = [self getCurrentDate];
        NSString* dateOfFolder = [self getFolderLastDate:folder];
        if ([dateOfFolder isEqualToString:currentDate]!=true){
            NSLog(@"Folder at path %@ is old",folder);
            [fileManager removeItemAtPath:folder error:NULL];
            amountRemovedFolders++;
        }

    }

    return amountRemovedFolders;
}


+(NSString*)getFolderLastDate:(NSString*)path{
    NSDate *date = [[NSDate alloc] init];
    NSFileManager* fileManager = [[NSFileManager alloc]init ];
    NSArray* tempArray = [[NSArray alloc]init ];
    NSDictionary* properties = [[NSDictionary alloc] init];
    properties = [fileManager attributesOfItemAtPath:path error:NULL];
    date = [properties objectForKey:NSFileModificationDate];
    NSString* modDate = [NSString stringWithFormat:@"%@",date];
    tempArray = [modDate componentsSeparatedByString:@" "];
    modDate = [tempArray objectAtIndex:0];
    return modDate;
}

@end
