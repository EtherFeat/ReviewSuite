//
//  RCCS.m
//  pintTest
//
//  Created by Alex on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCCS.h"

@implementation RCCS
+(void)setTempString:(NSString*)string{
    temp = string;
}
+(NSString*)getTempString{
    return temp;
}

+(BOOL)CheckServer:(NSString *)server{
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/sbin/ping"];
    NSArray *spliting = [server componentsSeparatedByString:@"//"];
    server = [spliting objectAtIndex:1];
    NSArray *arguments = [NSArray arrayWithObjects:@"-c",@"3",server, nil];
    [task setArguments:arguments];
    NSPipe* pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle* file = [pipe fileHandleForReading];
    [task launch];
    NSData* data = [file readDataToEndOfFile];
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    NSArray *resultArray = [result componentsSeparatedByString:@"\n"];
    NSString* resultLine = [[NSString alloc]init ]; 
    for(NSString* line in resultArray)
    {
        if ([line rangeOfString:@"packets transmitted"].location != NSNotFound && [line rangeOfString:@"packets received"].location != NSNotFound)
        {
            resultLine = line;
            break;
        }
    }    
    NSLog(@"%@",resultLine);
    
    NSString*amountOfRecievedPackets = [self findAmountRecievedPackets:[resultLine componentsSeparatedByString:@","]];
    NSLog(@"%@",amountOfRecievedPackets);
    if([amountOfRecievedPackets intValue]>0)
        return YES;
    else return NO;
    
}

+(NSString*)findAmountRecievedPackets:(NSArray *)line{
    @try {
        NSString* tempString = [line objectAtIndex:1];
    NSLog(@"%@",tempString);
    NSArray* tempArray = [tempString componentsSeparatedByString:@" "];
    
        [self setTempString:[tempArray objectAtIndex:1]];
    }
    @catch (NSException *exception) {
        [self setTempString:@"0"];
    }
   
    
    return [self getTempString];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end
