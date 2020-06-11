(function () {
  var dispatchArray = new Array();

  function Dispatcher() {
  }

  Dispatcher.next = function (path, fn) {
    if (fn) {
      dispatchArray.push({path:path, fn:fn});
    }

    return Dispatcher;
  };

  Dispatcher.dispatch = function (currentPath) {
    for (var i = 0, len = dispatchArray.length; i < len; i++) {
      var obj = dispatchArray[i];
      var match = currentPath.match(obj.path);
      if (match) {
        obj.fn(match);
      }
    }
  };

  window.Dispatcher = Dispatcher;
})();
