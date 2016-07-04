var Person = function(name) {
	this.name = name;
};

Person.prototype = {
	getName : function() {
		return this.name;
	}
};

var o1 = new Person();