//
//  Ball.h
//  WriteLeanPrograms
//
//  Created by XingYao on 15/10/16.
//  Copyright © 2015年 XingYao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    RED = 1,
    GREEN,
} ProductColor;

@interface Product : NSObject

@property (nonatomic, assign) ProductColor color;
@property (nonatomic, assign) float weight;

@end
