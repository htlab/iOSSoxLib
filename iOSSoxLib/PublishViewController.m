//
//  PublishViewController.m
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/11/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import "PublishViewController.h"
#import "AppDelegate.h"

@interface PublishViewController ()

@end

@implementation PublishViewController{
    
    AppDelegate *appDelegate;
    SoxConnection *soxConnection;
    NSMutableArray *allNodeList;
    NSString *nodeToPublish;
    SoxDevice *soxDevice;
    NSDate *date;
    XMPPPubSub *xmppPubSub;

}

@synthesize publishDataSetTableView;
@synthesize nodePicker;
@synthesize transducerArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //delegate setting
    nodePicker.delegate = self;
    [publishDataSetTableView setDataSource:self];
    [publishDataSetTableView setDelegate:self];
    
    //initialize
    transducerArray = [[NSMutableArray alloc]init];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    soxConnection = appDelegate.soxConnection;
    xmppPubSub = soxConnection.xmppPubSub;
    [xmppPubSub addDelegate:self delegateQueue:dispatch_get_main_queue()]; //just for getting publish result message
    
    //get all node list
    allNodeList = [soxConnection getAllNodeList];
    [allNodeList sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //for xmpp data timestamp
    date = [[NSDate alloc]init];
    
    self.publishDataSetTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
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

- (IBAction)didPushPublishButton:(id)sender {

    
    NSMutableArray *transducerValues = [[NSMutableArray alloc]init];

    //set values
    for(int i=0;i<[transducerArray count];i++){
        TransducerValue *tValue = [[TransducerValue alloc]init];
        tValue.id = [[transducerArray objectAtIndex:i] id]; //get ID
        
        UITableViewCell *cell = [publishDataSetTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *valueField = (UITextField*)[cell viewWithTag:2]; //get textfield
        
        tValue.rawValue = [valueField text];
        tValue.typedValue = [valueField text];
        tValue.timestamp = [date xmppDateTimeString];

        [transducerValues addObject:tValue];
    }

    Data *data = [[Data alloc]init];
    data.transducerValueArray = transducerValues;
    
    [soxDevice publish:data];
   
}

- (IBAction)didPushNodeSelectButton:(id)sender {
    
    
    soxDevice = [[SoxDevice alloc] initWithSoxConnectionAndNodeName:soxConnection :nodeToPublish ];

    transducerArray = [soxDevice.device.transducersArray mutableCopy];
    
    [publishDataSetTableView reloadData];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data Picker
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
    return [allNodeList count];
   
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [allNodeList objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    
    nodeToPublish = [allNodeList objectAtIndex:selectedRow];
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 180 , 20);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }
    
    //set label size
    [pickerLabel setText:[allNodeList objectAtIndex:row]];
    
    return pickerLabel;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([transducerArray count]==0){
        return 0;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    if([transducerArray count]==0){
        return 0;
    }else{
        return [transducerArray count]+1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    //publish button
    if(indexPath.row==[transducerArray count]){
        cell = [publishDataSetTableView dequeueReusableCellWithIdentifier:@"publishButtonCell"];
    }else{

        cell =  [publishDataSetTableView dequeueReusableCellWithIdentifier:@"transducerCell"];
        Transducer *transducer = [transducerArray objectAtIndex:indexPath.row];
        UILabel *transducerLabel = (UILabel*)[cell viewWithTag:1];
        transducerLabel.text = transducer.name;
        
        UILabel *unitLabel = (UILabel*)[cell viewWithTag:3];
        unitLabel.text = transducer.units;
        
    }
    
    return cell;
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPPubSub Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)xmppPubSub:(XMPPPubSub *)sender didPublishToNode:(NSString *)node withResult:(XMPPIQ *)iq{
    
    
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Data Published"
     message:[iq XMLString]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
    
}
- (void)xmppPubSub:(XMPPPubSub *)sender didNotPublishToNode:(NSString *)node withError:(XMPPIQ *)iq{
    
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Data Cannot Published"
     message:[iq XMLString]
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
}



@end
