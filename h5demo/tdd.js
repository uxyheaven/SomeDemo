var should = require('should');

var XY = require('./xy');
//require('./mv_');

// 描述
describe('要有自己的框架0', function() {
	it('要有类', function() {
		var o = {};
		o.should.be.ok;
	});
});



/*  */
var Class = function (arg) {
	// body...
	return function (arg) {
		// body...
	}
}


var Class1 = function (arg) {
	var o = function() {};
	for (var f in arg) {
		o.prototype[f] = arg[f];
	};
	return o;
}

var Class2 = function (arg) {
	var o = function() {
		if (typeof this.initialize === 'function') {
			this.initialize.apply(this, arguments);
		};
	};
	for (var f in arg) {
		o.prototype[f] = arg[f];
	};
	return o;
}

//console.log(jobs.name);

describe('要有自己的框架1', function() {
	it('要有类', function() {
		var Person = new Class();
		var jobs = new Person();
		// Person.should.be.ok;
		jobs.should.be.ok;
	});

	it('要有方法', function() {
		var Person = new Class1({
			show : function() {},
			hide : function() {}
		});
		var jobs = new Person();
		jobs.should.be.ok;
		jobs.should.have.property('show');
		jobs.should.have.property('hide');
	});

	it('要有构造函数', function(){
		var Person = new Class2({
			initialize : function (name) {
				this.name = name;
			}
		});

		var jobs = new Person ('jobs');
		jobs.name.should.eql('jobs');
	});


	it('要有自己的框架', function(){
		//  创建类
		var Person = XY.createClass();
		var jobs = new Person ();
		jobs.should.be.ok;
	});
});



describe('框架测试', function() {
	it('测试1', function(){
		var Product = XY.Model.extend({
			myMethod : function () {
			}
		});

		var order = new Product();
		console.log(typeof order.save === 'function');
		console.log(typeof order.myMethod === 'function');
	});
});








