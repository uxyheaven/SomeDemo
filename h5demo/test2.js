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
