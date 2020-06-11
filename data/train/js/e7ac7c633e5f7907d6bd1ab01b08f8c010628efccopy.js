var _copy_dispatch = {};
_copy_dispatch[Array] = function _copy_Array(x) { return x };
_copy_dispatch[Boolean] = function _copy_Boolean(x) { return x };
_copy_dispatch[Date] = function _copy_Date(x) { return x };
_copy_dispatch[Error] = function _copy_Error(x) { return x };
_copy_dispatch[EvalError] = function _copy_EvalError(x) { return x };
_copy_dispatch[Function] = function _copy_Function(x) { return x };
_copy_dispatch[Math] = function _copy_Math(x) { return x };
_copy_dispatch[Number] = function _copy_Number(x) { return x };
_copy_dispatch[Object] = function _copy_Object(x) { return x };
_copy_dispatch[RangeError] = function _copy_RangeError(x) { return x };
_copy_dispatch[ReferenceError] = function _copy_ReferenceError(x) { return x };
_copy_dispatch[RegExp] = function _copy_RegExp(x) { return x };
_copy_dispatch[String] = function _copy_String(x) { return x };
_copy_dispatch[SyntaxError] = function _copy_SyntaxError(x) { return x };
_copy_dispatch[TypeError] = function _copy_TypeError(x) { return x };
_copy_dispatch[URIError] = function _copy_URIError(x) { return x };

_copy_dispatch[Array] = function _copy_Array(x) {
    return x.map(function(value) {return value});
}

_copy_dispatch[Object] = function _copy_Object(object) {
    return extend({}, object);
}

_copy_dispatch['Instance'] = function _copy_Instance(o) {
    var obj = type('Empty', object);
    obj.prototype.constructor = o.constructor;
    obj = new obj();
    extend(obj, o);
    obj['__name__'] = o['__name__'];
    obj['__module__'] = o['__module__'];
    obj['__class__'] = o['__class__'];
    return obj;
}

function copy(x) {
    if (typeof(x) === 'undefined') return undefined;
    if (x === null) return null;
    if (callable(x['__copy__']))
        return x.__copy__(x);

    var cls = type(x);

    var copier = _copy_dispatch[cls];
    if (copier)
        return copier(x);
    
    if (x instanceof cls) return _copy_dispatch['Instance'](x);
    return x;
}

/* Deepcopy */

var _deepcopy_dispatch = {};
_deepcopy_dispatch[Array] = function _deepcopy_Array(x) { return x };
_deepcopy_dispatch[Boolean] = function _deepcopy_Boolean(x) { return x };
_deepcopy_dispatch[Date] = function _deepcopy_Date(x) { return x };
_deepcopy_dispatch[Error] = function _deepcopy_Error(x) { return x };
_deepcopy_dispatch[EvalError] = function _deepcopy_EvalError(x) { return x };
_deepcopy_dispatch[Function] = function _deepcopy_Function(x) { return x };
_deepcopy_dispatch[Math] = function _deepcopy_Math(x) { return x };
_deepcopy_dispatch[Number] = function _deepcopy_Number(x) { return x };
_deepcopy_dispatch[Object] = function _deepcopy_Object(x) { return x };
_deepcopy_dispatch[RangeError] = function _deepcopy_RangeError(x) { return x };
_deepcopy_dispatch[ReferenceError] = function _deepcopy_ReferenceError(x) { return x };
_deepcopy_dispatch[RegExp] = function _deepcopy_RegExp(x) { return x };
_deepcopy_dispatch[String] = function _deepcopy_String(x) { return x };
_deepcopy_dispatch[SyntaxError] = function _deepcopy_SyntaxError(x) { return x };
_deepcopy_dispatch[TypeError] = function __deepcopy_TypeError(x) { return x };
_deepcopy_dispatch[URIError] = function _deepcopy_URIError(x) { return x };

_deepcopy_dispatch[Array] = function _deepcopy_array(x) {
    return x.map(function(value) {return deepcopy(value)});
}

_deepcopy_dispatch[Object] = function _deepcopy_array(object) {
    return extend({}, object);
}

function deepcopy(x) {
    if (typeof(x) === 'undefined') return undefined;
    if (x === null) return null;
    if (callable(x['__deepcopy__']))
        return x.__deepcopy__(x);
    
    var cls = type(x);

    var copier = _deepcopy_dispatch[cls];
    if (copier)
        return copier(x);
    return copy(x);
}

publish({ 
    copy: copy, 
    deepcopy: deepcopy 
});