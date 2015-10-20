//
//  Demo.m
//  WriteLeanPrograms
//
//  Created by XingYao on 15/10/16.
//  Copyright © 2015年 XingYao. All rights reserved.
//

#import "Demo.h"
#import "ProductSpec.h"
#import "Product.h"

@interface Demo()
@property (nonatomic, strong) NSArray *products;
@end

// Product Repository: Filtering Operation
@implementation Demo

- (instancetype)init
{
    self = [super init];
    if (self) {
        Product *p1 = [[Product alloc] init];
        p1.color = RED;
        p1.weight = 5;
        
        Product *p2 = [[Product alloc] init];
        p2.color = RED;
        p2.weight = 11;
        
        Product *p3 = [[Product alloc] init];
        p3.color = RED;
        p3.weight = 5;
        
        Product *p4 = [[Product alloc] init];
        p4.color = GREEN;
        p4.weight = 5;
        
        Product *p5 = [[Product alloc] init];
        p5.color = GREEN;
        p5.weight = 10;
        
        Product *p6 = [[Product alloc] init];
        p6.color = GREEN;
        p6.weight = 5;
        _products = @[p1, p2, p3, p4, p5, p6];
    }
    return self;
}

// 需求1：在仓库中查找所有颜色为红色的产品
#pragma mark - First Attempt: Hard Code
- (NSArray *)findAllRedProducts:(NSArray *)products
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if (product.color == RED) {
            [list addObject:product];
        }
    }
    return list;
}

- (void)test1
{
    NSArray *array = [self findAllRedProducts:_products];
    NSLog(@"%s\n only red:%@", __func__, array);
}

// 需求2：在仓库中查找所有颜色为绿色的产品
#pragma mark - Second Attempt: Parameterizing
// 为了消灭硬编码，得到可重用的代码，可以引入简单的参数化设计。
- (NSArray *)findAllGreenProducts:(NSArray *)products
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if (product.color == GREEN) {
            [list addObject:product];
        }
    }
    return list;
}

- (NSArray *)findProducts:(NSArray *)products byColor:(ProductColor)color
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if (product.color == color) {
            [list addObject:product];
        }
    }
    return list;
}

// 需求3：查找所有重量小于10的所有产品
#pragma mark - Third Attempt: Parameterizing with Every Attribute You Can Think Of
- (NSArray *)findProducts:(NSArray *)products byWeith:(float)weight
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if (product.weight < weight) {
            [list addObject:product];
        }
    }
    return list;
}

- (NSArray *)findProducts:(NSArray *)products byColor:(ProductColor)color byWeith:(float)weight type:(int)type
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if ((type == 1) && product.color == color) {
            [list addObject:product];
            continue;
        }
        else if ((type == 2) && (product.weight < weight))
        {
            [list addObject:product];
            continue;
        }
    }
    return list;
}

#pragma mark - Forth Attempt: Abstracting over Criteria
// 为此需要抽取出隐藏的概念，使其遍历的算法与查找的标准能够独立地变化，互不影响。
/*
 @interface ProductSpec : NSObject
 + (BOOL)satisfy:(Product *)product;
 @end
 */
- (NSArray *)findProducts:(NSArray *)products bySpec:(ProductSpec *)spec
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if ([spec satisfy:product]) {
            [list addObject:product];
        }
    }
    return list;
}

- (void)test4
{
    NSArray *array = [self findProducts:_products
                                 bySpec:[ColorSpec specWithColor:RED]];
    NSLog(@"%s\n only red:%@", __func__, array);
}
/*
 这是经典的OO设计，如果熟悉设计模式的读者对此已经习以为常了。设计模式是好东西，但往往被滥用。为此不能依葫芦画瓢，死板照抄，而是为了得到更简单的设计而引入设计模式的，这个过程是很自然的。
 
 与大师们交流，问究此处为何引入设计模式，得到的答案：直觉。忘记所有设计模式吧，管它是不是模式，如果设计是简单的，这就是模式。
 
 另外还有一个明显的坏味道，ColorSpec和BelowWeightSpec都需要继承ProductSpec，都需要定义一个构造函数和一个私有的字段，并重写satisfy方法，这些都充斥着重复的结构。
 
 因Java缺乏闭包的支持，程序员不得不承受这样的烦恼，但此刻我们暂时不关心，继续前进。
 */


// 需求4：查找所有颜色为红色，并且重量小于10的所有产品

#pragma mrak - Firth Attempt: Composite Criteria
// 组合标准
/*
 ```
 @interface ColorAndBelowWeigthSpec : NSObject
 + (instancetype)specWithColor:(NSString *)color beloWeigth:(float)limit;
 @end
 ```
 */

/*
 存在两个明显的坏味道：
 - 包含and的命名往往是违背单一职责的信号灯
 - ColorAndBelowWeightSpec的实现与ColorSpec，BelowWeightSpec之间存在明显的重复
 此刻，需要寻找更本质的抽象来表达设计，and/or/not语义可以完美解决这类问题。
 - Composite Spec: AndSpec, OrSpec, NotSpec
 - Atomic Spec：ColorSpec, BeblowWeightSpec
 */
- (void)test5
{
    NSArray *array = [self findProducts:_products
                                 bySpec:[AndSpec spec:[ColorSpec specWithColor:RED], [BelowWeightSpec specWithBelowWeight:10], nil]];
    NSLog(@"%s\n red, Weight<10:%@", __func__, array);
}
/*
 但这样的设计存在两个严重的坏问道：
 - AndSpec与OrSpec存在明显的代码重复，OO设计的第一个直觉就是通过抽取基类来消除重复。
 ```
 @interface CombinableSpec : ProductSpec
 + (instancetype)spec:(ProductSpec *)spec, ...NS_REQUIRES_NIL_TERMINATION;
 @property (nonatomic, assign) BOOL shortcut;
 @end
 ```
 */

/*
- 大堆的初始化方法让人眼花缭乱
*/
- (void)test5_2
{
    NSArray *array = [self findProducts:_products
                                 bySpec:[NotSpec spec:[AndSpec spec:[ColorSpec specWithColor:RED], [BelowWeightSpec specWithBelowWeight:10], nil]]];
    NSLog(@"%s\n not(red, weight<10):%@", __func__, array);
}


#pragma mrak - Sixth Attempt: Using DSL
// 可以引入DSL改善程序的可读性，让代码更具表达力。

static ProductSpec *COLOR(ProductColor color)
{
    return [ColorSpec specWithColor:RED];
}

static ProductSpec *BELOWWEIGHT(float limit)
{
    return [BelowWeightSpec specWithBelowWeight:limit];
}

static ProductSpec *AND(ProductSpec *spec1, ProductSpec *spec2)
{
    return [AndSpec spec:spec1, spec2, nil];
}

static ProductSpec *OR(ProductSpec *spec1, ProductSpec *spec2)
{
    return [OrSpec spec:spec1, spec2, nil];
}

static ProductSpec *NOT(ProductSpec *spec)
{
    return [NotSpec spec:spec];
}

- (void)test6
{
    NSArray *array = [self findProducts:_products
                                 bySpec:NOT(AND(COLOR(RED), BELOWWEIGHT(10)))];
    NSLog(@"%s\n not(red, weight<10):%@", __func__, array);
}

#pragma mark - Seventh Attempt: Using a Lambda Expression
// 可以使用Lambda表达式改善设计，增强表达力。

- (NSArray *)findProducts:(NSArray *)products byBlock:(BOOL (^)())block
{
    NSMutableArray *list = [@[] mutableCopy];
    for (Product *product in products) {
        if (block(product)) {
            [list addObject:product];
        }
    }
    return list;
}

- (void)test7
{
    NSArray *array = [self findProducts:_products
                                byBlock:^BOOL(id p) {return [p color] == RED;}];
    NSLog(@"%s\n red:%@", __func__, array);
}
// 构造DSL，复用这些Lambda表达式
/*
 ProductSpecBlock color(ProductColor color)
 {
    return ^BOOL(id p) {return [p color] == color;};
 }
 
 ProductSpecBlock weightBelow(float limit)
 {
    return ^BOOL(id p) {return [p weight] < limit;};
 }
 */

- (void)test7_2
{
    NSArray *array = [self findProducts:_products
                                byBlock:color(RED)];
    NSLog(@"%s\n red:%@", __func__, array);
}



#pragma mark - Eighth attempt: Abstracting over Type
// 泛化类型信息，让算法更具有通用性，并进一步增强代码的可复用性。
- (void)test8
{
    // oc不支持泛型
    /*
    public static <T> List<T> filter(List<T> list, Predicate<T> p) {
        List<T> result = new ArrayList<>();
        for (T e : list) {
            if (p.test(e)) {
                result.add(e);
            }
        }
        return result;
    }
     */
}

#pragma - Ninth attempt: Using Stream
// 使用标准库
- (void)test9
{
    /*
     repo.stream()
     .filter(p -> p.getColor() == RED && p.getPrice() < 10)
     .collect(Collectors.toList());
     */
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weight > 10"];
    NSArray *array = [self.products filteredArrayUsingPredicate:predicate];
    NSLog(@"%s\n weight > 10:%@", __func__, array);
}

#pragma - Tenth attempt: Replace Java with Scala
// Scala语言是一门跨越OO和FP的一个混血儿，可以方便地与Java进行互操作。在Scala中，函数作为一等公民，可以避免像Java8为了使用Lambda还要约定Predicate的FunctionalInterface，非常自然。
- (void)test10
{
    /*
     repo.filter(p => p.color == RED && p.weight < 10)
     */
}
@end


































