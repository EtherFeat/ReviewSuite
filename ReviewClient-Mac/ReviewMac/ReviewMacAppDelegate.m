//
//  ReviewMacAppDelegate.m
//  ReviewMac
//
//  Created by Alex on 9/23/11.
//  Copyright 2011 EtherFeat. All rights reserved.
//

#import "ReviewMacAppDelegate.h"


@implementation ReviewMacAppDelegate

@synthesize window;

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

-(void)setArcDir:(NSString*)path{                           //setter for ArcDir
    arcDir = path;
}
-(NSString*)getArcDir{                                      //getter for ArcDir
    return arcDir;
}

- (void)setTableViewItmes:(NSMutableArray*)tblvwitems{      //setter for TableViewItems
    tableViewItems = tblvwitems;
}
- (NSMutableArray*)getTableViewItems{                       //getter for TableViewItems
    return tableViewItems;
}
-(void)setSearchArray:(NSMutableArray *)srcar{              //setter for SearchArray
    searchArray = srcar;
}
-(NSMutableArray*)getSearchArray{                           //getter for SearchArray
    return searchArray;
}
-(void)setWorkServer:(NSString *)urlServer{
    workServer = urlServer;
}
-(NSString*)getWorkServer{
    return workServer;
}
-(void)setPassword:(NSString *)Pass{
    password = Pass;
}
-(NSString*)getPassword{
    return password;
}
-(void)setUsername:(NSString *)User{
    username = User;
}
-(NSString*)getUsername{
    return username;
}
-(void)setShareConnect:(NSString *)connectResult{
    shareConnected = connectResult;
}
-(NSString*)getShareConnect{
    return shareConnected;
}
-(void)setShareExtractPath:(NSString *)path{
    shareExtractPath = path;
}
-(NSString*)getShareExtractPath{
    return shareExtractPath;
}

- (NSString *)ExtractFiles:(NSString*)path ArchiveName:(NSString*)arcname{   //Method to extract files
    [StatusLabel setStringValue:[NSString stringWithFormat:@"Extracting archive %@  ...",arcname]];
    NSString *pathToExtract = [NSString stringWithFormat:@"%@%@",[RCLib getPath:'e'],arcname]; //String pathToExtract gets path from a method, which called from clss RCLib get Path:'e', 'e' means extract.
    if([[self getWorkServer] rangeOfString:@"smb"].location != NSNotFound){
        pathToExtract=[NSString stringWithFormat:@"%@/%@",[self getShareExtractPath],arcname];
    }
    EtherZip *arc = [[EtherZip alloc] init];//creating object of class ZipArchive
    if ([arc unzipFile: path]) { //extrcting files
        BOOL ret = [arc unzipFileTo: pathToExtract overWrite: YES];
        if (NO == ret){} [arc unzipCloseFile];
    }
     //release object
    [StatusLabel setStringValue:@"Extracted"];
    return pathToExtract;
}

- (void)addItemes:(NSMutableArray *)arrayOfItemes{ //method to add Items to TableView
    

    [self setTableViewItmes:arrayOfItemes];  //set array, which connected to TableView
    
    [tableView reloadData];                  //Reload data in tableview
}

-(void)CheckServers
{
    NSArray* servers = [[[NSBundle mainBundle]infoDictionary ] objectForKey:@"Servers"];
    int counter = 0;
    if (servers) 
    {
        for (NSString* serverToCheck in servers) 
        {
            bool reachability = [RCCS CheckServer:serverToCheck];
            if(reachability)
            {
                [self setWorkServer:serverToCheck];
                //[StatusLabel setStringValue:[NSString stringWithFormat:@"Current server is %@",serverToCheck]];
                //[self remoteStart:self];
                break;
            }
            else if(!reachability && counter<[servers count])
            {
                counter++;
                continue;
            }
            
        }
        
        if ([self getWorkServer] == (id)[NSNull null] || ([self getWorkServer].length == 0))
        {
            [StatusLabel setStringValue:@"Connection problem or servers are unreacheble!Please contact your system administrator!"];
        }
        else{
            [StatusLabel setStringValue:[NSString stringWithFormat:@"Current server is: %@",[self getWorkServer]]];
        }
    }
}

/*- (BOOL)CheckInternetConnection{

    BOOL success = false;
    const char *hostName = [[self getWorkServer] cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, hostName);
    SCNetworkConnectionFlags flags = 0;
    success = SCNetworkReachabilityGetFlags(reachability,&flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable)&&!(flags & kSCNetworkFlagsConnectionRequired);
    return isAvailable;

}*/

- (void)getListOfFiles  //method to get list fo files from a server
{
    //if([self CheckInternetConnection]){
    NSError* error = nil; //error for method which getting content of url to string
    NSMutableArray* files;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:[NSString stringWithFormat:@"%@/review/source/current",[self getWorkServer]]]]; //url to list of files
                 //array for list of files
    NSString *content = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error] ;
                //getting content of url to a string variable
    files  = [NSMutableArray arrayWithArray:[content componentsSeparatedByString: @"\n"]];//array files gets content of string content by spliting in places separated \n
    [files removeObjectAtIndex:[files count]-1];//removing last null object from array
    [self setSearchArray:files]; //seting search array 
    [self addItemes:files];//adding items to TableView
    //}
    //else{[StatusLabel setStringValue:@"Connection problem please contact your system administrator!"];

    //}
}
- (void)BrowseShare{  //method to get list fo files from a server
    if([[self getShareConnect] isEqualToString:@"true"]){
        [self connectToShare:self];
    }
    else{
    [credWindow makeKeyAndOrderFront:self];
    [usernameField setStringValue:NSUserName()];
    }
}

- (void)BrowseExtracted:(NSString*)path{//method to get content extracted folder into TableView
    NSFileManager *fileManager = [[NSFileManager alloc]init];//create object NSFileManager
    NSMutableArray* content=[NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:path error:nil] ];//Array content getting content of folder.
    [self setSearchArray:content];//set SearchArray
    [self addItemes:content];//adding items to TAbleView
    //release object FileManager
     //Release object Content
}

- (void)openWebFile:(NSString*)path{ //View File in WebView
    [StatusLabel setStringValue:@""];
    NSURL *url = [NSURL fileURLWithPath:path];//path to a file
    NSURLRequest *request = [NSURLRequest requestWithURL:url];//creating request
    [[webView mainFrame] loadRequest:request]; //loading request into WebView
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [RCLib checkDates];
    [self CheckServers];
    NSString *dedicated = [[[NSBundle mainBundle]infoDictionary ] objectForKey:@"Dedicated"];
    if ([dedicated isEqualToString:@"true"]) {
        [self localStart:self];
        //[remotestartoutlet setEnabled:FALSE];
        [radioButtons selectCellAtRow:0 column:1];
    }
    else{
        [self remoteStart:self];
        [radioButtons selectCellAtRow:0 column:0];
    }
    
}

- (IBAction)connectToShare:(id)sender {
    NSString *userName;
    NSString *Password;
    NSArray *split = [[self getWorkServer] componentsSeparatedByString:@"//"];
    NSString *server = [split objectAtIndex:1];
    NSMutableArray* content;
    NSFileManager *fileManager = [[NSFileManager alloc]init];//create object NSFileManager
    if([[self getShareConnect] isEqualToString:@"false"] || [self getShareConnect] == (id)[NSNull null] || ([self getShareConnect].length == 0)){
    [progressIndicator startAnimation:self];
    userName=[usernameField stringValue];
        Password = [passwordWindow stringValue];
    
    [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"/Library/Caches/com.etherfeat.reviewclient/Mount/%@",server] withIntermediateDirectories:NO attributes:Nil error:Nil];
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/sbin/mount_smbfs"];
    NSString *shareconnect = [NSString stringWithFormat:@"//%@:%@@%@/review",userName,Password,server];
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: shareconnect, [NSString stringWithFormat:@"/Library/Caches/com.etherfeat.reviewclient/Mount/%@",server], nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"mount returned:\n%@", string);
    
    
    content=[NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"/Library/Caches/com.etherfeat.reviewclient/Mount/%@", server] error:nil] ];//Array content getting content of folder.
    [content removeObject:[NSString stringWithString:@"current"]];
        if(!content || !content.count){
            [self setShareConnect:@"false"];
            [StatusLabel setStringValue:@"Share is empty, please contact your system administrator. Perhaps you entered wrong credentials"];
            [StatusLabel setTextColor:[NSColor redColor]];
        }
        else{
            [self setShareConnect:@"true"];
            [self setShareExtractPath:[NSString stringWithFormat:@"/Library/Caches/com.etherfeat.reviewclient/Cache/Share/%@",server]];
            [fileManager createDirectoryAtPath:[self getShareExtractPath] withIntermediateDirectories:NO attributes:nil error:nil];
            NSString *item;
            for (item in content) {
                [self ExtractFiles:[NSString stringWithFormat:@"/Library/Caches/com.etherfeat.reviewclient/Mount/%@/%@",server,item] ArchiveName:item];
            }
            [self BrowseExtracted:[self getShareExtractPath]];
        }
        [progressIndicator stopAnimation:self];
        [credWindow orderOut:self];
        [self setSearchArray:content];//set SearchArray
        [self addItemes:content];//adding items to TAbleView
    }
    else{
        [self BrowseExtracted:[self getShareExtractPath]];
    }
    //release object FileManager
     //Release object Content
}

- (IBAction)cancelConnection:(id)sender {
    [credWindow orderOut:self];
}

- (IBAction)remoteStart:(id)sender { //action for Remote radio button
    if([[self getWorkServer]rangeOfString:@"http"].location !=NSNotFound){
    [self getListOfFiles];//calling method get list of files which showing files in tableview
    [Label setStringValue:@"Remote root"];
    }
    else{
        [self BrowseShare];//calling method to browse share
        [Label setStringValue:@"Share root"];
    }
}

- (IBAction)localStart:(id)sender { //action for Local radio button
    [self BrowseExtracted:[RCLib getPath:'e']];  //calling method for browse extracted folder
    [Label setStringValue:@"Local root"];
}

- (IBAction)updateFilter:(id)sender { //actiong for search in tableview
    NSString *filter = [searchField stringValue];//content of searchfied
    NSMutableArray *result = [[NSMutableArray alloc]init];//array with result
    if (filter == (id)[NSNull null] || filter.length == 0) {[self addItemes:[self getSearchArray]];}  //if filter is empty add items of search array to tableview
    else{
    for (NSString *itemForSearch in [self getSearchArray]) { //loop for each item in searcharray
        if ([itemForSearch rangeOfString:filter].location !=NSNotFound) { //if item contain filter add item to result array
            [result addObject:itemForSearch];
        }
    }
        [self addItemes:result]; //add items to tableview
        
        
    }
     //release 
     //release
}

- (IBAction)tableViewSelected:(id)sender { //action for changes in tableview
    NSString *selectedItem = [searchArray objectAtIndex:[sender selectedRow] ]; //name of selected item
    if ([selectedItem rangeOfString:@".zip"].location != NSNotFound || [selectedItem rangeOfString:@".ZIP"].location != NSNotFound) { //if name of selected item contain zip
            
      if ([self returnSelected] == 0) { //if remote radio button selected
        if([[self getWorkServer] rangeOfString:@"http"].location != NSNotFound){
          [StatusLabel setStringValue:[NSString stringWithFormat:@"Downloading file %@",selectedItem]];
          [self setArcDir: [NSString stringWithString:[self ExtractFiles:[RCLib downloadFile:selectedItem url:[self getWorkServer]] ArchiveName:selectedItem] ]];     //Method in method.  Method extract calling method download
          [self BrowseExtracted:[self getArcDir]]; //browsing extracted
          [Label setStringValue:selectedItem]; 
        }
        else{
          [self setArcDir:[NSString stringWithFormat:@"%@/%@",[self getShareExtractPath],selectedItem]];    //extract archive from mounted volume
          [self BrowseExtracted:[self getArcDir]]; //browsing extracted
          [Label setStringValue:selectedItem];
          }   
        }
            
      else {
                [self BrowseExtracted:[NSString stringWithFormat:@"%@%@",[RCLib getPath:'e'],selectedItem]];//if selected local radio button, browsing folder wtih name extracted
                [self setArcDir:[NSString stringWithFormat:@"%@%@",[RCLib getPath:'e'],selectedItem]];
                [Label setStringValue:selectedItem];
            }

        }
        else {NSLog(@"Open file in browser"); //view file in browser
            [self openWebFile:[NSString stringWithFormat:@"%@/%@",[self getArcDir],selectedItem] ];
    
        }
    }
   



- (int)numberOfRowsInTableView:(NSTableView *)tableView { //method for connecting array with tableview
    NSMutableArray *items = [self getTableViewItems];
    return (int)[items count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row {//another method to connect array with tableview
    NSMutableArray *items = [self getTableViewItems];
    return [items objectAtIndex:row];
}

- (NSInteger)returnSelected{//method which return which radui button was selected
        NSInteger *row, *column;
        radio = [radioButtons selectedCell];
        [radioButtons getRow:&row column:&column ofCell:radio];
        return column;
}

@end
