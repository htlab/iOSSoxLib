//
//  PublishViewController.h
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 6/11/15.
//  Copyright (c) 2015 Takuro Yonezawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoxFramework.h"


@interface PublishViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,SoxDeviceDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *nodePicker;
@property (weak, nonatomic) IBOutlet UITableView *publishDataSetTableView;
@property (strong,nonatomic) NSMutableArray *transducerArray;

- (IBAction)didPushPublishButton:(id)sender;
- (IBAction)didPushNodeSelectButton:(id)sender;


-(void)didFinishDeviceBinding;
-(void)didNotFinishDeviceBinding;

@end
