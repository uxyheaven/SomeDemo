# 开场
今天, 我们将从一个小功能开始, 先去不假思索的实现它

* Product Repository: Filtering Operation

# Code start
有一个产品库, 我们要对它做过滤操作.

第一个需求并不复杂.

* 需求1：在仓库中查找所有颜色为`红色`的产品

## First Attempt: Hard Code
我们先用最简单的方式去实现它, 硬编码

```
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
```
如果这个世界是永恒静止的，这样的实现无可厚非，但世界往往并非如此。

紧接着,第二个需求来了

* 需求2：在仓库中查找所有颜色为`绿色`的产品

## Second Attempt: Parameterizing
`Copy-Paste`是大部分程序员最容易犯的毛病，为此引入了大量的重复代码。

```
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
```
为了消灭硬编码，得到可重用的代码，可以引入简单的`参数化`设计。

```
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
```

终于可以放心了, 这个时候我们的产品经理怎么可能让你舒服呢,需求3又来了

* 需求3：查找所有重量小于10的所有产品

## Third Attempt: Parameterizing with Every Attribute You Can Think Of
大部分程序员依然会使用`Copy-Paste`解决这个问题，拒绝`Copy-Paste`的陋习，最具实效的一个反馈就是让这个快捷键失效，从而在每次尝试`Copy-Paste`时提醒自己做更好的设计。

```
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
```

为了消除两者重复的代码，通过简单的`参数化`往往不能完美解决这类问题，相反地会引入过度的复杂度和偶发成本。


```
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
```
日常工作中，这样的实现手法非常普遍，函数的参数列表随着需求增加不断增加，函数逻辑承担的职责越来越多，逻辑也变得越来越难以控制。

- 通过参数配置应对变化的设计往往都是失败的设计
- 易于导致复杂的逻辑控制，引发额外的偶发复杂度

## Forth Attempt: Abstracting over Criteria
为此需要抽象，使其遍历的算法与查找的标准能够独立地变化，互不影响。

```
@interface ProductSpec : NSObject
- (BOOL)satisfy:(Product *)product;
@end
```

此刻`filter`的算法逻辑得到封闭，当然函数名需要重命名，使其算法实现更加具有普遍性。

```
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
```

通过可复用的类来封装各种变化，让变化的因素控制在最小的范围内。

```
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
```

用户的接口也变得简单多了，而且富有表现力。

```
[self findProducts:_products bySpec:[ColorSpec specWithColor:RED]];
```

这是经典的`OO`设计，如果熟悉设计模式的读者对此已经习以为常了。设计模式是好东西，但往往被滥用。为此不能依葫芦画瓢，死板照抄，而是为了得到更简单的设计而引入设计模式的，这个过程是很自然的。

与大师们交流，问究此处为何引入设计模式，得到的答案：直觉。忘记所有设计模式吧，管它是不是模式，如果设计是简单的，这就是模式。

另外还有一个明显的坏味道，ColorSpec和BelowWeightSpec都需要继承ProductSpec，都需要定义一个构造函数和一个私有的字段，并重写satisfy方法，这些都充斥着重复的结构。

是不是觉得目前的写法已经够用了? 莫急, 让我们来看看下个需求

* 需求4：查找所有颜色为红色，并且重量小于10的所有产品

## Firth Attempt: Composite Criteria
按照既有的代码结构，往往易于设计出类似ColorAndBelowWeightSpec的实现。

```
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
```

存在两个明显的坏味道：

- 包含`and`的命名往往是违背单一职责的信号灯
- `ColorAndBelowWeightSpec`的实现与`ColorSpec`，`BelowWeightSpec`之间存在明显的重复

此刻，需要寻找更本质的抽象来表达设计，`and/or/not`语义可以完美解决这类问题。

- Composite Spec: AndSpec, OrSpec, NotSpec
- Atomic Spec：ColorSpec, BeblowWeightSpec

```
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
```

```
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

```

```
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

```

可以通过`AndSpec`组合`ColorSpec`, `BelowWeightSpec`来实现需求，简单漂亮，并且富有表达力。

```
[self findProducts:_products bySpec:[AndSpec spec:[ColorSpec specWithColor:RED], [BelowWeightSpec specWithBelowWeight:10], nil]];
```

但这样的设计存在两个严重的坏问道：

- `AndSpec`与`OrSpec`存在明显的代码重复，`OO`设计的第一个直觉就是通过抽取基类来消除重复。

```
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
    
    CombinableSpec *combinableSpec = [[self alloc] init];
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
```

```
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
```

```
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
```

* 大堆的`初始化方法`让人眼花缭乱

```
[self findProducts:_products bySpec:[NotSpec spec:[AndSpec spec:[ColorSpec specWithColor:RED], [BelowWeightSpec specWithBelowWeight:10], nil]]];
```

## Sixth Attempt: Using DSL
可以引入DSL改善程序的可读性，让代码更具表达力。

我们先添加一些DSL:

```
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
```

这样我们的代码表现起来就是这样的

```
[self findProducts:_products bySpec:NOT(AND(COLOR(RED), BELOWWEIGHT(10)))];
```

## Seventh Attempt: Using a Lambda Expression
可以使用Block改善设计，增强表达力。

```
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
```

代码现在开起来是这个样子

```
[self findProducts:_products byBlock:^BOOL(id p) {return [p color] == RED;}];
```

构造DSL，复用这些Block

```
ProductSpecBlock color(ProductColor color)
{
    return ^BOOL(id p) {return [p color] == color;};
}

ProductSpecBlock weightBelow(float limit)
{
    return ^BOOL(id p) {return [p weight] < limit;};
}
```

```
- (void)test7_2
{
    [self findProducts:_products byBlock:color(RED)];
}
```

## Eighth attempt: Using NSPredicate
还可以使用标准库

```
[self.products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"weight > 10"]];
```

# 结束
Dome在 WriteLeanPrograms目录下

<https://github.com/uxyheaven/SomeDemo>

今天的编码就到此为止了, 这篇文章本是Horance所写, 笔者将其用OC实现了一遍.如果咱们不是iOS Developer的话, 还是有其他attempt的, 如`泛型`.


# 作者介绍
* 刘光聪，程序员，敏捷教练，开源软件爱好者，目前供职于中兴通讯无线研究院，具有多年大型遗留系统的重构经验，对面向对象，函数式，大数据等领域具有浓厚的兴趣。
	* github: <https://github.com/horance-liu>
	* email: <horance@outlook.com>	
* 邢尧, 资深开发工程师, iOS Developer, 开源软件爱好者, 追求真理比占有真理更加难能可贵
	* Github: <https://github.com/uxyheaven>
	* Blog: <http://blog.csdn.bet/uxyheaven>

