//
//  RCCS.h
//  pintTest
//
//  Created by Alex on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCS : NSObject
+(BOOL)CheckServer:(NSString*)server;
+(void)setTempString:(NSString*)string;
+(NSString*)getTempString;
+(NSString*)findAmountRecievedPackets:(NSArray*)line;

@end
NSString* temp;

