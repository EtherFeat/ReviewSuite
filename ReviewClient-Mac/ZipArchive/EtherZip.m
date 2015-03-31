//
//  EtherZip.m
//  ReviewMac
//
//  Created by Alex on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EtherZip.h"
#import "zlib.h"
#import "zconf.h"


@implementation EtherZip
@synthesize delegate = delegate;



-(BOOL)unzipFile:(NSString *)pathToZip{
    ziparc = unzOpen((const char*)[pathToZip UTF8String]);
    unz_global_info  globalInfo = {0};
    if(unzGetGlobalInfo(ziparc, &globalInfo) == UNZ_OK){
        NSLog(@"%lu entries extracted",globalInfo.number_entry);
    }
    return ziparc != NULL;
}
-(BOOL) unzipFileTo:(NSString*) path overWrite:(BOOL) overwrite{
    BOOL result = YES;
    int returnVal = unzGoToFirstFile( ziparc );
	unsigned char		buffer[4096] = {0};
	NSFileManager* fileManager = [NSFileManager defaultManager];
    if( returnVal!=UNZ_OK )
	{
		
        //return some error
	}    
    do{
        returnVal=unzOpenCurrentFile(ziparc);
        if( returnVal!=UNZ_OK )
		{
            result = NO;
			unzCloseCurrentFile( ziparc );
			break;
        }
        // reading data and write to file
		int read ;
		unz_file_info	fileInfo ={0};
		returnVal = unzGetCurrentFileInfo(ziparc, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if( returnVal!=UNZ_OK )
		{
			//return error
			result = NO;
			unzCloseCurrentFile( ziparc );
			break;
		}    
        char* fileName = (char*) malloc( fileInfo.size_filename +1 );
		unzGetCurrentFileInfo(ziparc, &fileInfo, fileName, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		fileName[fileInfo.size_filename] = '\0';
        NSString * Path = [NSString  stringWithCString:fileName encoding:NSUTF8StringEncoding];
        BOOL isDirectory = NO;
        if( fileName[fileInfo.size_filename-1]=='/' || fileName[fileInfo.size_filename-1]=='\\')
			isDirectory = YES;
		free( fileName );
        if( [Path rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location!=NSNotFound )
		{// contains a path
			Path = [Path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
		NSString* fullPath = [path stringByAppendingPathComponent:Path];
        if( isDirectory )
        {
            [fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
		else
        {
            [fileManager createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if( [fileManager fileExistsAtPath:fullPath] && !isDirectory && !overwrite )
		{
			if( ![self overWrite :fullPath] )
			{
				unzCloseCurrentFile( ziparc );
				returnVal = unzGoToNextFile( ziparc );
				continue;
			}
		}
        FILE* file = fopen( (const char*)[fullPath UTF8String], "wb");
        while(file){
            read=unzReadCurrentFile(ziparc, buffer, 4096);
			if( read > 0 )
			{
				fwrite(buffer, read, 1, file );
			}
			else if( read<0 )
			{
				//error to read
				break;
			}
			else 
				break;	        
        }
        if( file )
		{
			fclose( file );
			// set the orignal datetime property
			NSDate* fileDate = nil;
			
			//{{ thanks to brad.eaton for the solution
			NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
			
			dateComponents.second = fileInfo.tmu_date.tm_sec;
			dateComponents.minute = fileInfo.tmu_date.tm_min;
			dateComponents.hour = fileInfo.tmu_date.tm_hour;
			dateComponents.day = fileInfo.tmu_date.tm_mday;
			dateComponents.month = fileInfo.tmu_date.tm_mon+1;
			dateComponents.year = fileInfo.tmu_date.tm_year;
			
			NSCalendar *gregorian = [[NSCalendar alloc] 
									 initWithCalendarIdentifier:NSGregorianCalendar];
			
			fileDate = [gregorian dateFromComponents:dateComponents] ;
			//}}
			
			
			NSDictionary* attr = [NSDictionary dictionaryWithObject:fileDate forKey:NSFileModificationDate]; //[[NSFileManager defaultManager] fileAttributesAtPath:fullPath traverseLink:YES];
			if( attr )
			{
				//		[attr  setValue:orgDate forKey:NSFileCreationDate];
				if( ![[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:fullPath error:nil] )
				{
					// cann't set attributes 
					NSLog(@"Failed to set attributes");
				}
				
			}
            
			
			
		}
		unzCloseCurrentFile(ziparc );
		returnVal = unzGoToNextFile( ziparc );    }
    while( returnVal==UNZ_OK && UNZ_OK!=UNZ_END_OF_LIST_OF_FILE );
    return  result;
}


-(BOOL) unzipCloseFile
{
	if( ziparc)
		return unzClose( ziparc )==UNZ_OK;
	return YES;
}
-(BOOL) overWrite:(NSString*) file
{
	if( delegate && [delegate respondsToSelector:@selector(OverWriteOperation)] )
		return [delegate overWriteOperation:file];
	return YES;
}


@end
