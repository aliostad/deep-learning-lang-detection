(function(API) {

    /** Resolve naming conflict */
    API.public.noConflict = function(ns) {
        this[API.ns] = ns;
        return API.public;
    }.bind(this, this[API.ns]);

    /** Extender */
    API.public.extend = function(callback) {
        callback.call({}, API.public, API.private);
    };

    /** Return public api */
    if (module && module.exports) {
        module.exports = API.public;
    } else {
        this[API.ns] = API.public;
    }

}).call(this, {
    ns: 'sherlock',
    public: {},
    private: {}
});
