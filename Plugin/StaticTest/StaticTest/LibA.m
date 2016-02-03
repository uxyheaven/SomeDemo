//
//  LibA.m
//  StaticTest
//
//  Created by Heaven on 16/2/3.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "LibA.h"

#define LibAVer @"0.0.1"

@implementation LibA

+ (void)show
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", self.class] message:LibAVer delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
    [alert show];
}

@end
