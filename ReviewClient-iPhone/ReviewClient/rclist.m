//
//  reviewclientiphoneFirstViewController.m
//  ReviewClient
//
//  Created by Alex Zheludov on 5/23/12.
//  Copyright (c) 2012 ETHERFEAT. All rights reserved.
//
#import "reviewclientiphoneAppDelegate.h"
#import "rclist.h"
#import "rcview.h"
#import "EtherZip/EtherZip.h"

@implementation rclist
@synthesize listOfItems, tableView,searchArray,server;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
      }

- (void)viewDidUnload
{
    tableView = nil;
    [self setTableView:nil];
  searchField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  //reviewclientiphoneAppDelegate *appDelegate = (reviewclientiphoneAppDelegate *)[[UIApplication sharedApplication] delegate]; 
  //reviewclientiphoneAppDelegate *rcdelegate = [[reviewclientiphoneAppDelegate alloc] init];
  [self checkServers];
  NSFileManager *filemanager = [[NSFileManager alloc] init];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
  NSString *settingsFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"rcsettings.plist"];
  if([filemanager fileExistsAtPath:settingsFile]){
  NSMutableDictionary *savedSettings = [[NSMutableDictionary alloc] initWithContentsOfFile: settingsFile];
    NSString *primaryServer=[savedSettings objectForKey:@"PrimaryServer"];
    if(primaryServer.length == 0 || [primaryServer isEqualToString:@""]){
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                      message:@"Please, set the primary server in settings"
                                                     delegate:nil 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles: nil];
      [alert show];
      listOfItems=nil;
      [tableView reloadData];
    }
    else{
      listOfItems = [[NSMutableArray alloc] init];
      [self getListOfFiles];
    }
  }
  else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"Please, go to settings tab and set the servers"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  if(searchBar.text.length > 0){
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    BOOL back = NO;
    for(NSString* item in searchArray){
      if ([item rangeOfString:searchBar.text].location != NSNotFound) {
        [temp addObject:item];
        //NSLog(@"%@",item);
      }
      if ([item rangeOfString:@".."].location != NSNotFound) {    
        back = YES;
      }
      
    }
    if (back == YES) {
      [temp insertObject:@".." atIndex:0];
    }
    for(NSString* s in temp){
      NSLog(@"%@",s);
    }
    [self setTableItems:temp];
    [tableView reloadData];
  }

  [searchBar resignFirstResponder ];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{	
	if(searchBar.text.length > 0){
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    BOOL back = NO;
    for(NSString* item in searchArray){
      if ([item rangeOfString:searchBar.text].location != NSNotFound) {
        [temp addObject:item];
        //NSLog(@"%@",item);
      }
      if ([item rangeOfString:@".."].location != NSNotFound) {    
        back = YES;
      }
      
    }
    if (back == YES) {
      [temp insertObject:@".." atIndex:0];
    }
    for(NSString* s in temp){
      NSLog(@"%@",s);
    }
    [self setTableItems:temp];
    [tableView reloadData];
  }
  else{
    [self setTableItems:searchArray];
    [tableView reloadData];
  }
}



- (void)getListOfFiles  //method to get list fo files from a server
{
    NSError* error = nil; //error for method which getting content of url to string
  NSLog(@"%@",self.server);
  if(![self.server isEqual:@""] || self.server.length !=0){
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/review/source/current",self.server]]; 
    NSString *content = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error] ;
    [self setTableItems:[NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]]];
  searchArray= [self getTableItems];
    [tableView reloadData];
  }
  else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"Servers are unreachable"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
[searchField resignFirstResponder ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem = [listOfItems objectAtIndex:[indexPath row] ];
    if([selectedItem rangeOfString:@"zip"].location !=NSNotFound || [selectedItem rangeOfString:@"ZIP"].location !=NSNotFound ){
        [self downloadAndExtract:selectedItem];
    }
    else if([selectedItem rangeOfString:@".."].location !=NSNotFound){
      searchField.text=nil;
      [self getListOfFiles];
    }
    else {
      reviewclientiphoneAppDelegate *appDelegate = (reviewclientiphoneAppDelegate *)[[UIApplication sharedApplication] delegate]; 
      appDelegate.filepath = [NSString stringWithFormat:@"%@/%@",[self getArcPath],selectedItem];
      [self.tabBarController setSelectedIndex:1];
    }
}



- (void)downloadAndExtract:(NSString *)name{
    NSError* error = nil;
    NSString* temp = NSTemporaryDirectory();
    NSString* extractDir = [NSString stringWithFormat:@"%@extract/%@",temp,name];
   [self setArcPath:extractDir];
    temp = [NSString stringWithFormat:@"%@%@",temp,name];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/review/source/%@",self.server,name]]; //url for download
    NSData *zipfile = [NSData dataWithContentsOfURL:url];//getting content of url to a data object
    [zipfile writeToFile:temp atomically:YES];//write object to disk
    EtherZip *arc = [[EtherZip alloc] init];
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    BOOL isDir;
    if(![filemanager fileExistsAtPath:extractDir isDirectory:&isDir]){
        [filemanager createDirectoryAtPath:extractDir withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"creting error \n %@",error);
    }
    if ([arc unzipFile: temp]) { //extrcting files
        BOOL ret = [arc unzipFileTo: extractDir overWrite: YES];
        if (NO == ret){} [arc unzipCloseFile];
    }
    [filemanager removeItemAtPath:temp error:&error];
    NSLog(@"removing error \n %@",error);
  NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[filemanager contentsOfDirectoryAtPath:extractDir error:&error]];
  [tempArray insertObject:@".." atIndex:0];
  searchArray= tempArray;
  [self setTableItems:tempArray];
  searchField.text = nil;
    [tableView reloadData];
    NSLog(@"reading error \n %@",error);
    NSLog(@"%@",[filemanager contentsOfDirectoryAtPath:extractDir error:nil]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self getTableItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.textLabel.text=[[self getTableItems] objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)checkServers{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
  NSString *settingsFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"rcsettings.plist"];
  NSMutableDictionary *savedSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
  double timeOut = [[savedSettings objectForKey:@"PingTimeOut"] doubleValue];
  for(NSString* key in savedSettings){
    if([key rangeOfString:@"Server"].location !=NSNotFound){
      NSLog(@"%@ pp",key);
      if(![[savedSettings objectForKey:key] isEqualToString:@""] || [[savedSettings objectForKey:key]length] != 0) {
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[savedSettings objectForKey:key]]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:timeOut];
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        //NSLog(@"%@",theConnection);  
          if (theConnection) {
          self.server = [savedSettings objectForKey:key];
          NSLog(@"%@",self.server);
          break;
        }
        else{
          NSLog(@"%@ server is unreachable",self.server);
        }
      }
    }
  }
}
-(void)setTableItems:(NSMutableArray*)items{                           //setter for ArcDir
    listOfItems = items;
}
-(NSMutableArray*)getTableItems{                                      //getter for ArcDir
    return listOfItems;
}
-(void)setArcPath:(NSString*)path{                           //setter for ArcDir
    arcPath = path;
}
-(NSString*)getArcPath{                                      //getter for ArcDir
    return arcPath;
}

@end
