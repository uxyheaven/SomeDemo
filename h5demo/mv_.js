var XY = XY || {};

var addFunction = function () {
};

var Model = XY.Model = function(){};

Model.prototype = {
	constructor : Model,
	save : function() {},
	fetch : function() {},
	toJSON : function() {},
	extend : addFunction
};

module.exports = Model;
