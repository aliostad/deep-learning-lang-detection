var widgetController;
var preferencesController;


function main( ) {
	preferencesController = createPreferencesController();
	widgetController      = createWidgetController(preferencesController);

	connect(widget, "show",      widgetController, widgetController.start);
	connect(widget, "hide",      widgetController, widgetController.stop);
	connect(widget, "showBack",  widgetController, widgetController.stop);
	connect(widget, "showFront", widgetController, widgetController.start);
	connect(widget, "showFront", preferencesController, preferencesController.update);
}

function sliderUpdated( event ) {
	replaceChildNodes("sliderValue", event.target.value);
}