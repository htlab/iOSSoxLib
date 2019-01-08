//
//  MenuViewController.m
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/11/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController{
    AppDelegate *appDelegate;
    SoxConnection *soxConnection;
}
@synthesize isAnonymousLogin;
@synthesize serverLabel;
@synthesize userLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    soxConnection = appDelegate.soxConnection;
    [serverLabel setText:[soxConnection server]];
    [userLabel setText:[soxConnection jid]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didPushSubscribeButton:(id)sender {
    
    [self performSegueWithIdentifier:@"subscribeSegue" sender:self];

    
}

- (IBAction)didPushPublishButton:(id)sender {
    [self performSegueWithIdentifier:@"publishSegue" sender:self];

}

- (IBAction)didPushCreateButton:(id)sender {
    if([userLabel.text isEqualToString:@""]){
        
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:@"Anonymous Cannot Create"
         message:@"please login with JID"
         delegate:nil
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil
         ];
        [alert show];
    }else{
        [self performSegueWithIdentifier:@"createSegue" sender:self];
    }
}

@end
