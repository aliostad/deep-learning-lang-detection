exports.controllers = {
	Controller: require('./dat/controllers/Controller'),
	StringController: require('./dat/controllers/StringController'),
	BooleanController: require('./dat/controllers/BooleanController'),
	FunctionController: require('./dat/controllers/FunctionController'),
	NumberControllerBox: require('./dat/controllers/NumberControllerBox'),
	NumberController: require('./dat/controllers/NumberController'),
	NumberControllerSlider: require('./dat/controllers/NumberControllerSlider'),
	OptionController: require('./dat/controllers/OptionController'),
	ColorController: require('./dat/controllers/ColorController')
};

exports.dom = {
	CenteredDiv:require('./dat/dom/CenteredDiv'),
	dom: require('./dat/dom/dom')
};

exports.color = {
    math: require('./dat/color/math'),
    interpret: require('./dat/color/interpret'),
    Color: require('./dat/color/Color')
};

exports.gui = require('./dat/gui/GUI');

