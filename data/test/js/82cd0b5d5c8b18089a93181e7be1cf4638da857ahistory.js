this.Ninja.module('$history', ['$controller', '$curry', '$dispatcher'], function ($controller, $curry, $dispatcher) {

    window.onpopstate = function(event) {
        $dispatcher.trigger('pageChange',  event.state);
        $controller.controller = event.state.controller;
        $controller.action = event.state.action;
    };

    var history = function(state, title, url, trigger) {
        window.history.pushState(state, title, url);

        $controller.controller = state.controller;

        $controller.action = state.action;
        $controller.url = url;

        trigger && $dispatcher.trigger('pageChange', state);
    }

    history({controller: $controller.controller, action: $controller.action}, $controller.title, $controller.url, true);

    return $curry(history);

});