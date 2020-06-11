var _forEachPair = function(array, fn) {
    if (array.length % 2 !== 0) {
        throw "Cannot iterate pairs on array with odd number of members";
    }

    for (var i=0;i<array.length;i+=2) {
        fn(array[i], array[i+1]);
    }
};

/*
 * Function to create multi-methods that perform arbitrary value dispatch.
 * Now dispatch mapping is an array whose values are alternating value/function pairs
 * [v1, f1, v2, f2, v3, f3...,vn,fn]
 */
var defMulti = function(dispatchFn, defaultFn, dispatchMapping) {
    var dm = dispatchMapping || [];

    var result = function() {
        // TODO: do I want to be able to pass a 'this' to the function?  maybe indicator flag to defMulti
        var dispatchValue = dispatchFn.apply(null, arguments);
        var dispatchTarget = defaultFn;

        // NB: not using an associative array or js object since I don't want
        // dispatch values to be coerced into strings
        _forEachPair(dm, function(v,f) {
            if (v === dispatchValue) {
                dispatchTarget = f;
            }
        });


        if (dispatchTarget === undefined) {
            throw "No dispatch target for value " + dispatchValue + ", and no default specified";
        }

        return dispatchTarget.apply(null, arguments);
    };

    result._dispatchMapping = dm;
    return result;
};

/*
 * Function to add a dispatch value and target to the specified multi-method
 *
 * if I don't allow modification of multimethod after creation, dispatchMapping doesn't need
 * to be stored on the multi-method, it can just be closed over, thus not risking naming collisions with function properties
 * However, then multimethods would not be extensible to new dispatch values after creation
 */
var defMethod = function(multiMethod, value, fn) {
    multiMethod._dispatchMapping.push(value);
    multiMethod._dispatchMapping.push(fn);
};
