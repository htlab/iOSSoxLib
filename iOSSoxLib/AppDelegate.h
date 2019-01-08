//
//  AppDelegate.h
//  iOSSoxLib
//
//  Created by Takuro Yonezawa on 2015/06/08.
//  Copyright (c) 2015年 Takuro Yonezawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoxFramework.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    SoxConnection *soxConnection;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) SoxConnection *soxConnection;

@end

