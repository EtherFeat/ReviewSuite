//
//  RCLib.m
//  ReviewMac
//
//  Created by Alex on 10/15/11.
//  Copyright 2011 EtherFeat. All rights reserved.
//

#import "RCLib.h"

@implementation RCLib

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
+(NSString*)getPath:(char)type{ //get path to folder extract or downloads
    NSFileManager *filemanager = [[NSFileManager alloc] init]; //create filemanager
    NSString *defpath=@"/Library/Caches/com.etherfeat.reviewclient";
    //NSDictionary *attributes;
    //[attributes setValue:[NSNumber numberWithShort:0777] forKey:NSFilePosixPermissions];
    //BOOL isDir = YES;
    //if(![filemanager fileExistsAtPath:defpath isDirectory:&isDir]){
    //    [filemanager createDirectoryAtPath:defpath withIntermediateDirectories:YES attributes:Nil error:Nil];
    //}
    //NSString *current = [filemanager currentDirectoryPath];//current directoey, where program was executed
    //NSString *current = nil;
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(
    //                                                     NSCachesDirectory, NSUserDomainMask, YES);
    //if ([paths count])
    //{
    //    NSString *bundleName =
    //    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    //    current = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    //}
    
    if (type == 'd') {
        NSString *downloads = [NSString stringWithFormat:@"%@/Cache/Downloads/",defpath];//path to foder downloads
        if(![filemanager fileExistsAtPath:downloads isDirectory:NULL]) //if folder downloads is not exist create directory downloads
        {[filemanager createDirectoryAtPath:downloads withIntermediateDirectories:true attributes:nil error:nil];}
        NSLog(@"%@",downloads);
        return downloads;
    }
    else {
        NSString *extract = [NSString stringWithFormat:@"%@/Cache/Extract/",defpath]; // path to folder extract
        if(![filemanager fileExistsAtPath:extract isDirectory:NULL]) //chcking exists
        {[filemanager createDirectoryAtPath:extract withIntermediateDirectories:true attributes:nil error:nil];} // creating directory if it is not exist
        return extract;
    }
}

+(NSString*)downloadFile:(NSString *)name url:(NSString*)server 
{
    
    NSString *path = [[NSString alloc] init]; 
    path = [NSString stringWithFormat:@"%@%@",[self getPath:'d'],name]; //getting path for download
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/review/source/%@",server,name]]; //url for download
    NSData *zipfile = [NSData dataWithContentsOfURL:url];//getting content of url to a data object
    [zipfile writeToFile:path atomically:YES];//write object to disk
    return path;}


+(void)checkDates{
    NSString*xtrDir = [self getPath:'e'];
    NSLog(@"%d items been removed",[RCFDLib removeFiles:xtrDir]);
}



@end
