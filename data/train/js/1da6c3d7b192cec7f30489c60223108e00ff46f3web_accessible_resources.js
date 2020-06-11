addEventListener('message', function () {
  'use strict';
  var notify_error = function (message, url, line) {
    var expandedMessage = '', opt = {};
    expandedMessage = 'message: ' + message + '\n';
    expandedMessage += 'url: ' + url + '\n';
    expandedMessage += 'line: ' + line;
    opt = {
      type : 'basic',
      title: 'JS Error Notification',
      message: message,
      expandedMessage: expandedMessage,
      iconUrl: '/src/white-64x64.png'
    };
    postMessage(opt, location.href);
    return false;
  };
  window.onerror = notify_error;
});
