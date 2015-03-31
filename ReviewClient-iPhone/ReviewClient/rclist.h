//
//  reviewclientiphoneFirstViewController.h
//  ReviewClient
//
//  Created by Alex Zheludov on 5/23/12.
//  Copyright (c) 2012 ETHERFEAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rclist : UIViewController{
    IBOutlet UITableView *tableView;
  IBOutlet UISearchBar *searchField;
    NSMutableArray *listOfItems;
    NSMutableArray *searchArray;
    NSString *arcPath;
  NSString *server;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray*listOfItems;
@property (nonatomic, retain) NSMutableArray*searchArray;
@property (readwrite, nonatomic, retain) NSString *server;
//-(void)searchField:(UISearchBar *)searchField textDidChange:(NSString *)searchText;

@end
