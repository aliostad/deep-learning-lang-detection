alert("background script started");

var backgroundScriptMessage = " backgroundScriptMessage";
 
chrome.extension.onRequest.addListener(function(request, sender)
{
 alert("Background script has received a message from contentscript:'" + request.message + "'");
 returnMessage(request.message);
});
 
function returnMessage(messageToReturn)
{
 chrome.tabs.getSelected(null, function(tab) {
  var joinedMessage = messageToReturn + backgroundScriptMessage; 
  alert("Background script is sending a message to contentscript:'" + joinedMessage +"'");
  chrome.tabs.sendMessage(tab.id, {message: joinedMessage});
 });
}