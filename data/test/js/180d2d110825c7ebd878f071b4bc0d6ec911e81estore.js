var R = require("./reducers/index");
var store = Redux.createStore(R.Reducer);

var dispatch = function(type, context) {
    melange.store.dispatch({
        type: type,
        context: context,
    });
}

var goto = function(route, data) {
    // random default string
    var name = "_";
    if (route !== undefined) {
        name = route.name;
    }
    
    dispatch(R.actions.url.update, {
        route: name,
        data: data,
    });
}

module.exports = {
    actions: R.actions,
    dispatch: dispatch,
    goto: goto,
    store: store,
}
