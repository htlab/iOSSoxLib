//
//  SubscribeViewController.h
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/11/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoxFramework.h"

@interface SubscribeViewController : UIViewController<UIPickerViewDelegate,SoxDeviceDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *subTargetPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *unsubTargetPicker;
@property (weak, nonatomic) IBOutlet UITextView *receivedDataTextView;
@property (strong,nonatomic) NSMutableArray *subTargets;
@property (strong,nonatomic) NSMutableArray *unsubTargets;
@property (strong,nonatomic) NSMutableDictionary *soxDeviceDictionary;
@property (strong,nonatomic) NSString *nodeToSubscribe;
@property (strong,nonatomic) NSString *nodeToUnsubscribe;

- (IBAction)didPushSubscribeButton:(id)sender;
- (IBAction)didPushUnsubscribeButton:(id)sender;

@end
