var Class3 = function (arg) {
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

var Model3 = function() {};
Model3.prototype = {
	constructor : Model3,
	save : function() {},
	fetch : function() {},
	toJSON : function() {}
};

Model3.extend = function(arg){
	var Product = function() {};
	var F = function() {
		this.constructor = Product;
	};

	F.prototype = Model3.prototype;
	Product.prototype = new F();
	for (var f in arg) {
		Product.prototype[f] = arg[f];
	};
	Product.prototype.__super__ = Model3.prototype;
	return Product;
};



module.exports = {
	createClass : Class3,
	Model: Model3
};







