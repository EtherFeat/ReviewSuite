//
//  rcsettings.h
//  ReviewClient
//
//  Created by Alex Zheludov on 5/23/12.
//  Copyright (c) 2012 EtherFeat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rcsettings : UIViewController{

  IBOutlet UITextField *tertiaryServerField;
  IBOutlet UITextField *secondaryServerField;
  IBOutlet UITextField *primaryServerField;
  IBOutlet UITextField *timeOutField;
}

- (IBAction)saveButton:(id)sender;
- (IBAction)cancelButton:(id)sender;


@end
