//
//  ProductSpec.m
//  WriteLeanPrograms
//
//  Created by XingYao on 15/10/16.
//  Copyright © 2015年 XingYao. All rights reserved.
//

#import "ProductSpec.h"

@implementation ProductSpec

- (BOOL)satisfy:(Product *)product
{
    return YES;
}
@end

#pragma mark -

@interface ColorSpec()
@property (nonatomic, assign) ProductColor color;
@end
@implementation ColorSpec

+ (instancetype)specWithColor:(ProductColor)color
{
    ColorSpec *spec = [[ColorSpec alloc] init];
    spec.color = color;
    return spec;
}

- (BOOL)satisfy:(Product *)product
{
    return product.color == RED;
}

@end

@interface BelowWeightSpec()
@property (nonatomic, assign) float limit;
@end

@implementation BelowWeightSpec

+ (instancetype)specWithBelowWeight:(float)limit
{
    BelowWeightSpec *spec = [[BelowWeightSpec alloc] init];
    spec.limit = limit;
    return spec;
}

- (BOOL)satisfy:(Product *)product
{
    return (product.weight < _limit);
}
@end


#pragma mark -
@interface ColorAndBelowWeigthSpec()
@property (nonatomic, assign) ProductColor color;
@property (nonatomic, assign) float limit;
@end

@implementation ColorAndBelowWeigthSpec
+ (instancetype)specWithColor:(ProductColor)color beloWeigth:(float)limit
{
    ColorAndBelowWeigthSpec *spec = [[ColorAndBelowWeigthSpec alloc] init];
    spec.color = color;
    spec.limit = limit;
    return spec;
}

- (BOOL)satisfy:(Product *)product
{
    return product.color == _color || (product.weight < _limit);
}
@end

#pragma mark -
#if (Abstracting_AndOrSpec == 0)
@interface AndSpec()
@property (nonatomic, strong) NSArray *specs;
@end

@implementation AndSpec
+ (instancetype)spec:(ProductSpec *)spec, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start( args, spec );
    NSMutableArray *mArray = [@[spec] mutableCopy];
    
    for ( ;; )
    {
        id tempSpec = va_arg( args, id );
        if (tempSpec == nil)
            break;
        
        [mArray addObject:tempSpec];
    }
    va_end( args );
    
    AndSpec *andSpec = [[AndSpec alloc] init];
    andSpec.specs = [mArray copy];
    
    return andSpec;
}

- (BOOL)satisfy:(Product *)product
{
    for (ProductSpec *spec in _specs) {
        if (![spec satisfy:product]) {
            return NO;
        }
    }
    return YES;
}
@end

@interface OrSpec ()
@property (nonatomic, strong) NSArray *specs;
@end

@implementation OrSpec

+ (instancetype)spec:(ProductSpec *)spec, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start( args, spec );
    NSMutableArray *mArray = [@[spec] mutableCopy];
    
    for ( ;; )
    {
        id tempSpec = va_arg( args, id );
        if (tempSpec == nil)
            break;
        
        [mArray addObject:tempSpec];
    }
    va_end( args );
    
    OrSpec *orSpec = [[OrSpec alloc] init];
    orSpec.specs = [mArray copy];
    
    return orSpec;
}

- (BOOL)satisfy:(Product *)product
{
    for (ProductSpec *spec in _specs) {
        if ([spec satisfy:product]) {
            return YES;
        }
    }
    return NO;
}

@end

#endif

@interface NotSpec ()
@property (nonatomic, strong) ProductSpec *spec;
@end

@implementation NotSpec

+ (instancetype)spec:(ProductSpec *)spec
{
    NotSpec *notSpec = [[NotSpec alloc] init];
    notSpec.spec = spec;
    return notSpec;
}

- (BOOL)satisfy:(Product *)product
{
    if (![_spec satisfy:product]) {
        return YES;
    }
    return NO;
}
@end

#pragma mark -

@interface CombinableSpec ()
@property (nonatomic, strong) NSArray *specs;
@end

@implementation CombinableSpec

+ (instancetype)spec:(CombinableSpec *)spec, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start( args, spec );
    NSMutableArray *mArray = [@[spec] mutableCopy];
    
    for ( ;; )
    {
        id tempSpec = va_arg( args, id );
        if (tempSpec == nil)
            break;
        
        [mArray addObject:tempSpec];
    }
    va_end( args );
    
    CombinableSpec *combinableSpec = [[CombinableSpec alloc] init];
    combinableSpec.specs = [mArray copy];
    
    return combinableSpec;
}

- (BOOL)satisfy:(Product *)product
{
    for (ProductSpec *spec in _specs) {
        if ([spec satisfy:product] == _shortcut) {
            return _shortcut;
        }
    }
    return !_shortcut;
}

@end

#if (Abstracting_AndOrSpec == 1)
@implementation AndSpec
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shortcut = NO;
    }
    return self;
}
@end

@implementation OrSpec

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shortcut = YES;
    }
    return self;
}
@end
#endif


#pragma mark -color

@implementation ProductSpec(Lambda)

+ (BOOL(^)(id p))color:(ProductColor)color
{
    return ^BOOL(id p) {return [p color] == color;};
}
+ (BOOL(^)(id p))weightBelow:(float)limit
{
   return ^BOOL(id p) {return [p weight] < limit;};
}
@end

ProductSpecBlock color(ProductColor color)
{
    return ^BOOL(id p) {return [p color] == color;};
}

ProductSpecBlock weightBelow(float limit)
{
    return ^BOOL(id p) {return [p weight] < limit;};
}








