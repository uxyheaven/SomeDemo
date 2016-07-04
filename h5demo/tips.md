# tips
* 对象也是function
* 即时函数

## 模式
* 黑板
* 微核

## 前端
### V
* html + css
* 模板
* jscore
* 更新

### M
* 字面量
* 构造器

### *
* C
* P
* VM

## 模板
* 字符串模板--正则, handlebars, 
* dom模板
* 虚拟dom模板, rn

## Function的视角
### fun是一个函数
### fun作为一个构造器

## OO的视角
### 字面量
```
var o1 = {
	name : 'jobs',
	getName : function  (name) {
		return this.name;
	}
}
```

### 构造器

#### 中间过程 : 封装作用域
```
var factory = (function() {
	// private
	var getName = function() {
		return this.name;
	};

	// public
	return function(name) {
		this.name = name;
		this.getName = getName;
	};
})();
```

#### 中间过程 : 重用
```
var proto = {
	getName : function() {
		return this.name;
	};
}

var factory = function(name) {
	this.name = name;
};

var o1 = {};
o1.__proto__ = proto;
factory.call(o1, 'jobs');


var o2 = {};
o2.__proto__ = proto;
factory.call(o2, 'gates');
```

#### 最终结果
```
var Person = function(name) {
	this.name = name;
};

Person.prototype = {
	getName : function() {
		return this.name;
	}
};

var o1 = new Person('jobs');
```


## 面向对象
* 角色
* 职责
* 协作


## 圣杯模式
## backbone
## 书
* JS高级编程
* JAVASCRIPT语言精髓与编程实践 周爱民

