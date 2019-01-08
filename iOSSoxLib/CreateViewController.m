//
//  CreateViewController.m
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/12/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import "CreateViewController.h"
#import "AppDelegate.h"

@interface CreateViewController (){
    AppDelegate *appDelegate;
    XMPPPubSub *xmppPubSub;
}

@end

@implementation CreateViewController
@synthesize nodeNameTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nodeNameTextField.delegate=self;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    xmppPubSub = appDelegate.soxConnection.xmppPubSub;
    [xmppPubSub addDelegate:self delegateQueue:dispatch_get_main_queue()];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPushCreateButton:(id)sender {
    
    NSLog(@"hello");
    NSString *nodeName = [nodeNameTextField text];
    
    Device *device = [[Device alloc]init];
    device.name = nodeName;
    device.type=@"outdoor weather";
    
    Transducer *transducer =[[Transducer alloc]init];
    transducer.name=@"temperature";
    transducer.id=@"temperature";
    transducer.units=@"celcius";
    NSMutableArray *transducers = [[NSMutableArray alloc]init];
    [transducers addObject:transducer];
    
    
    Transducer *transducer2 =[[Transducer alloc]init];
    transducer2.name=@"humidity";
    transducer2.id=@"humidity";
    transducer2.units=@"percent";
    [transducers addObject:transducer2];
    
    device.transducersArray=transducers;
    
    
    [appDelegate.soxConnection create:nodeName :device :ACCESS_MODEL_OPEN :PUBLISH_MODEL_OPEN];

    
}

- (IBAction)didPushDeleteButton:(id)sender {
    
    [appDelegate.soxConnection delete:[nodeNameTextField text]];
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPPubSub Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppPubSub:(XMPPPubSub *)sender didCreateNode:(NSString *)node withResult:(XMPPIQ *)iq{
    
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Create Succeeded!"
     message:[iq XMLString]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];

}

- (void)xmppPubSub:(XMPPPubSub *)sender didNotCreateNode:(NSString *)node withError:(XMPPIQ *)iq{
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Cannot be created.."
     message:[iq XMLString]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
}

- (void)xmppPubSub:(XMPPPubSub *)sender didDeleteNode:(NSString *)node withResult:(XMPPIQ *)iq{
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Delete Succeeded!"
     message:[iq XMLString]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
}

- (void)xmppPubSub:(XMPPPubSub *)sender didNotDeleteNode:(NSString *)node withError:(XMPPIQ *)iq{
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Cannot be deleted.."
     message:[iq XMLString]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];

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
