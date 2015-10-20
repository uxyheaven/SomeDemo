//
//  ProductSpec.h
//  WriteLeanPrograms
//
//  Created by XingYao on 15/10/16.
//  Copyright © 2015年 XingYao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Product.h"

#define Abstracting_AndOrSpec 1


#pragma mark -
@interface ProductSpec : NSObject
- (BOOL)satisfy:(Product *)product;
@end


#pragma mark -
@interface ColorSpec : ProductSpec
+ (instancetype)specWithColor:(ProductColor)color;
@end

@interface BelowWeightSpec : ProductSpec
+ (instancetype)specWithBelowWeight:(float)limit;
@end


#pragma mark -
@interface ColorAndBelowWeigthSpec : NSObject 
+ (instancetype)specWithColor:(ProductColor)color beloWeigth:(float)limit;
@end

#pragma mark -
#if (Abstracting_AndOrSpec == 0)
@interface AndSpec : ProductSpec
+ (instancetype)spec:(ProductSpec *)spec, ... NS_REQUIRES_NIL_TERMINATION;
@end

@interface OrSpec : ProductSpec
+ (instancetype)spec:(ProductSpec *)spec, ... NS_REQUIRES_NIL_TERMINATION;
@end
#endif

@interface NotSpec : ProductSpec
+ (instancetype)spec:(ProductSpec *)spec;
@end

#pragma mark -
@interface CombinableSpec : ProductSpec
+ (instancetype)spec:(ProductSpec *)spec, ...NS_REQUIRES_NIL_TERMINATION;
@property (nonatomic, assign) BOOL shortcut;
@end

#if (Abstracting_AndOrSpec == 1)
@interface AndSpec : CombinableSpec
@end

@interface OrSpec : CombinableSpec
@end
#endif


#pragma mark -

@interface ProductSpec (Lambda)
+ (BOOL(^)(id p))color:(ProductColor)color;
+ (BOOL(^)(id p))weightBelow:(float)limit;
@end

typedef BOOL(^ProductSpecBlock)(id p);

extern ProductSpecBlock color(ProductColor color);
extern ProductSpecBlock weightBelow(float limit);




