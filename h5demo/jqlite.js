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



var o1 = {
	name : 'jobs',
	getName : function  (name) {
		return this.name;
	}
}