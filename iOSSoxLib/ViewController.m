//
//  ViewController.m
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 2015/06/08.
//  Copyright (c) 2015年 Takuro Yonezawa. All rights reserved.
//
// This is start point of iOSSoxLib demonstrations.
// If you would like to show all XMPP message, please open SoxConnection.m and comment in
// [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
// and comment out
// [DDLog addLogger:[DDTTYLogger sharedInstance]];
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    AppDelegate *appDelegate;
    BOOL isAnonymousLogin;
}

@synthesize serverTextField;
@synthesize jidTextField;
@synthesize passTextField;
@synthesize soxDeviceArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //for text editing (especially for hiding keyboard when return key is pressed
    serverTextField.delegate = self;
    jidTextField.delegate =self;
    passTextField.delegate=self;
    
    //for test
    soxDeviceArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPushAnonymousLoginButton:(id)sender {
    
    isAnonymousLogin = YES;
    [self login];
    
}

- (IBAction)didPushLoginWithJIDButton:(id)sender {
    
    isAnonymousLogin = NO;
    [self login];
    
}

-(void)login{
    if(isAnonymousLogin){
        //anonymous login
        if(appDelegate.soxConnection==nil){
            appDelegate.soxConnection = [[SoxConnection alloc] initWithAnonymousUser:[serverTextField text]];
        }else{
            [appDelegate.soxConnection setServerAndUserAndPassword:[serverTextField text] :@"" :@""];
        }
    }else{
        //login with JID and Password
        if(appDelegate.soxConnection==nil){
            appDelegate.soxConnection = [[SoxConnection alloc] initWithJIDandPassword:[serverTextField text] :[jidTextField text] :[passTextField text]];
        }else{
            [appDelegate.soxConnection setServerAndUserAndPassword:[serverTextField text] :[jidTextField text] :[passTextField text]];
        }
    }
    
    if([appDelegate.soxConnection connect]){
        //move to menu view
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }else{
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:@"Cannot Login"
         message:@"Please Check User&Password"
         delegate:nil
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil
         ];
        [alert show];
        [appDelegate.soxConnection disconnect];
        
    }
    
    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Navigation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [[segue identifier] isEqualToString:@"loginSegue"] ) {
        MenuViewController *nextViewController = [segue destinationViewController];
        nextViewController.isAnonymousLogin = isAnonymousLogin;
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TextField Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //hide keyboard
    [self.view endEditing:YES];
    
    return YES;
}

@end
