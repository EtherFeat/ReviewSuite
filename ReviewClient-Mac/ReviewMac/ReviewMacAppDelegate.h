//
//  ReviewMacAppDelegate.h
//  ReviewMac
//
//  Created by Alex on 9/23/11.
//  Copyright 2011 EtherFeat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EtherZip.h"
#import <WebKit/WebKit.h>
#import "RCLib.h"
#import "RCCS.h"
#import <SystemConfiguration/SystemConfiguration.h>
@interface ReviewMacAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *__strong window;
    IBOutlet NSTableView *tableView;
    IBOutlet NSSearchField *searchField;    
    IBOutlet WebView *webView;

    IBOutlet NSButtonCell *remotestartoutlet;
    IBOutlet NSPanel *credWindow;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSTextFieldCell *StatusLabel;
    IBOutlet NSTextField *Label;
    IBOutlet NSButtonCell *radio;
    IBOutlet NSMatrix *radioButtons;
    IBOutlet NSTextField *usernameField;
    IBOutlet NSSecureTextField *passwordWindow;
    NSString *arcDir;
    NSMutableArray *tableViewItems;
    NSMutableArray *searchArray;
    NSString* workServer;
    NSString* password;
    NSString* username;
    NSString* shareConnected;
    NSString* shareExtractPath;
}
- (IBAction)connectToShare:(id)sender;
- (IBAction)cancelConnection:(id)sender;
- (IBAction)remoteStart:(id)sender;
- (IBAction)localStart:(id)sender;
- (IBAction)updateFilter:(id)sender;
- (IBAction)tableViewSelected:(id)sender;
- (NSInteger)returnSelected;
- (void)setArcDir:(NSString*)arDir;
- (NSString*)getArcDir;
- (void)setTableViewItmes:(NSMutableArray*)tblvwitems;
- (NSMutableArray*)getTableViewItems;
- (void)setSearchArray:(NSMutableArray*)srcar;
- (NSMutableArray*)getSearchArray;
- (NSString *)ExtractFiles:(NSString*)path ArchiveName:(NSString*)arcname;
- (NSInteger)returnSelected;
- (void)openWebFile:(NSString*)path;
- (void)BrowseExtracted:(NSString*)path;
- (void)BrowseShare;
- (void)getListOfFiles;
- (void)addItemes:(NSMutableArray *)arrayOfItemes;
- (NSString *)ExtractFiles:(NSString*)path ArchiveName:(NSString*)arcname;
- (void)setWorkServer:(NSString*)urlServer;
- (NSString*)getWorkServer;
- (void)setPassword:(NSString*)Pass;
- (NSString*)getPassword;
- (void)setUsername:(NSString*)User;
- (NSString*)getUsername;
- (void)setShareConnect:(NSString*)connectResult;
- (NSString*)getShareConnect;
- (void)setShareExtractPath:(NSString*)path;
- (NSString*)getShareExtractPath;
- (void)CheckServers;
//- (BOOL)CheckInternetConnection;
@property (strong) IBOutlet NSWindow *window;

@end
