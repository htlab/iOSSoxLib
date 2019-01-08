//
//  CreateViewController.h
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/12/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoxFramework.h"

@interface CreateViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nodeNameTextField;
- (IBAction)didPushCreateButton:(id)sender;
- (IBAction)didPushDeleteButton:(id)sender;
@end
