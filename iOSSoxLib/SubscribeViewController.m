//
//  SubscribeViewController.m
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/11/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import "SubscribeViewController.h"
#import "AppDelegate.h"


@interface SubscribeViewController ()

@end

@implementation SubscribeViewController{
    AppDelegate *appDelegate;
    SoxConnection *soxConnection;
    NSMutableArray *allNodeList;
}
@synthesize subTargetPicker;
@synthesize unsubTargetPicker;
@synthesize receivedDataTextView;
@synthesize subTargets;
@synthesize unsubTargets;
@synthesize soxDeviceDictionary;
@synthesize nodeToSubscribe;
@synthesize nodeToUnsubscribe;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Picker view delegate
    subTargetPicker.delegate = self;
    unsubTargetPicker.delegate = self;
    
    //initialize
    subTargets = [[NSMutableArray alloc] init];
    unsubTargets = [[NSMutableArray alloc] init];
    soxDeviceDictionary = [[NSMutableDictionary alloc] init];
    nodeToSubscribe=@"";
    nodeToUnsubscribe=@"";
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    soxConnection = appDelegate.soxConnection;
    allNodeList = [soxConnection getAllNodeList]; //get all node list
    subTargets = [allNodeList mutableCopy]; //set all node as target of subscribing
    [subTargets sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    
    //set current subscribing nodes
    NSMutableArray *alreadySubscribingNodes = [appDelegate.soxConnection getSubscribingNodes];
    for (NSString *value in alreadySubscribingNodes) {
        [self subscribe:value];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)subscribe:(NSString*) nodeName{
    SoxDevice *soxDevice = [[SoxDevice alloc] initWithSoxConnectionAndNodeName:soxConnection :nodeName ];
    [soxDevice subscribe]; //subscribe
    
    [soxDeviceDictionary setObject:soxDevice forKey:nodeName]; //add SoxDevice to Disctionary
    soxDevice.delegate = self;
    
    [subTargets removeObject:nodeName]; //remove the node from list to be subscribed
    [subTargets sortUsingSelector:@selector(caseInsensitiveCompare:)]; //sort
    [unsubTargets addObject:nodeName]; //add the node to list to be unsubscribed
    [unsubTargets sortUsingSelector:@selector(caseInsensitiveCompare:)]; //sort
    
    [subTargetPicker reloadAllComponents]; //reload subscribe target list of the picker
    [unsubTargetPicker reloadAllComponents]; //reload unsubscribe target list of the picker
}

-(void)unsubscribe:(NSString*)nodeName{
    SoxDevice *soxDevice = [soxDeviceDictionary objectForKey:nodeName];
    [soxDevice unsubscribe]; //unsubscribe
    
    [soxDeviceDictionary removeObjectForKey:nodeName]; //remove SoxDevice to Disctionary
    
    [unsubTargets removeObject:nodeName]; //remove the node from list to be unsubscribed
    [unsubTargets sortUsingSelector:@selector(caseInsensitiveCompare:)]; //sort
    [subTargets addObject:nodeName]; //add the node to list to be subscribed
    [subTargets sortUsingSelector:@selector(caseInsensitiveCompare:)]; //sort
    
    [subTargetPicker reloadAllComponents]; //reload subscribe target list of the picker
    [unsubTargetPicker reloadAllComponents]; //reload unsubscribe target list of the picker
}




- (IBAction)didPushSubscribeButton:(id)sender {
    if(![nodeToSubscribe isEqualToString:@""]){
        [self subscribe:nodeToSubscribe];
        nodeToSubscribe=@"";
    }
    
}

- (IBAction)didPushUnsubscribeButton:(id)sender {
    if(![nodeToUnsubscribe isEqualToString:@""]){
        [self unsubscribe:nodeToUnsubscribe];
        nodeToUnsubscribe=@"";
    }
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
    if(pickerView==subTargetPicker){
        return [subTargets count];
    }else if(pickerView==unsubTargetPicker){
        return [unsubTargets count];
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView==subTargetPicker){
        if([subTargets count]>0){
            return [subTargets objectAtIndex:row];
        }
    }else if(pickerView==unsubTargetPicker){
        if([unsubTargets count]>0){
            return [unsubTargets objectAtIndex:row];
        }
    }
    return nil;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    
    if(pickerView==subTargetPicker){
        if([subTargets count]>0){
            nodeToSubscribe = [subTargets objectAtIndex:selectedRow];
        }
    }else if(pickerView==unsubTargetPicker){
        if([unsubTargets count]>0){
            nodeToUnsubscribe = [unsubTargets objectAtIndex:selectedRow];
        }
    }
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
    if(pickerView==subTargetPicker){
        if([subTargets count]>0){
            [pickerLabel setText:[subTargets objectAtIndex:row]];
        }
    }else if(pickerView==unsubTargetPicker){
        if([unsubTargets count]>0){
            [pickerLabel setText:[unsubTargets objectAtIndex:row]];
        }
    }
    
    
    return pickerLabel;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark SoxDevice Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)didReceivePublishedData:(SoxData *)soxdata{
    
    NSString *dataText = @"Data from: ";
    
    if(soxdata.device!=nil){
        
        dataText = [dataText stringByAppendingString:soxdata.device.name];
        dataText = [dataText stringByAppendingString:@"\n\n"];
        
        for(TransducerValue *value in soxdata.data.transducerValueArray){
            dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"[id: %@, rawValue: %@, typedValue:%@, timestamp:%@]",value.id,value.rawValue,value.typedValue,value.timestamp]];
            dataText = [dataText stringByAppendingString:@"\n"];
        }
        
    }
    //UIView should be updated only in main thread
    dispatch_sync(dispatch_get_main_queue(), ^{
        [receivedDataTextView setText:dataText];
    });
    
}


@end
