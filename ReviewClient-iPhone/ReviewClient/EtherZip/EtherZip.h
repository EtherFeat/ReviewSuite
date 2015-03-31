//
//  EtherZip.h
//  ReviewMac
//
//  Created by Alex on 5/22/12.
//  Copyright (c) 2012 EtherFeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "minizip/zip.h"
#include "minizip/unzip.h"

@protocol EtherZipDelegate <NSObject>
@optional 
-(BOOL) overWriteOperation:(NSString*) file;
@end

@interface EtherZip : NSObject{

@private 
    unzFile ziparc;
    id delegate;
}
@property (nonatomic, retain) id delegate;

-(BOOL) unzipFile:(NSString*) pathToZip;
-(BOOL) unzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL) unzipCloseFile;
-(BOOL) overWrite:(NSString*) file;
@end
