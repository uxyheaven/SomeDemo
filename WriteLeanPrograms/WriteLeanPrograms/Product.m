//
//  Ball.m
//  WriteLeanPrograms
//
//  Created by XingYao on 15/10/16.
//  Copyright © 2015年 XingYao. All rights reserved.
//

#import "Product.h"

@implementation Product

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@",@(_color), @(_weight)];
}
@end
