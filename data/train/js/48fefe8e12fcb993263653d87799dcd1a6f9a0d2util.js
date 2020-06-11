Gen = new function() {
	this.genrate = function() {
var apiName = $('#apiName').val();
var apiAttribute = $('#apiAttribute').val();
console.log(apiName+' apiAttribute '+apiAttribute);
var modelStr = dbqury(apiName,jQuery.parseJSON(apiAttribute));
$("#modelText").val(modelStr);
var apiStr = api(apiName,jQuery.parseJSON(apiAttribute));
$("#apiText").val(apiStr);
var controllerStr = controller(apiName,jQuery.parseJSON(apiAttribute));
$("#controllerText").val(controllerStr);
var htmlStr = html(apiName,jQuery.parseJSON(apiAttribute));
$("#htmlText").val(htmlStr);

}
}
