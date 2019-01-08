//
//  MenuViewController.h
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/11/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoxFramework.h"

@interface MenuViewController : UIViewController

@property BOOL isAnonymousLogin;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
- (IBAction)didPushSubscribeButton:(id)sender;
- (IBAction)didPushPublishButton:(id)sender;
- (IBAction)didPushCreateButton:(id)sender;

@end
