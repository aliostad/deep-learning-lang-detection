/**
 * @mixin
 * @description
 *
 * Mixin which allows to specify the service name when creating an error instance.
 */
Subclass.Error.Option.Service = function()
{
    function ServiceOption()
    {
        return {
            /**
             * The name of service
             *
             * @type {(string|undefined)}
             */
            _service: undefined
        };
    }

    /**
     * Sets/returns service name
     *
     * @method service
     * @memberOf Subclass.Error.Option.Service
     *
     * @param {string} [service]
     *      The name of the service
     *
     * @returns {Subclass.Error}
     */
    ServiceOption.prototype.service = function(service)
    {
        if (!arguments.length) {
            return this._service;
        }
        if (service && typeof service != 'string') {
            throw new Error('Specified invalid service name. It must be a string.');
        }
        this._service = service;

        return this;
    };

    /**
     * Checks whether the service option was specified
     *
     * @method hasService
     * @memberOf Subclass.Error.Option.Service
     *
     * @returns {boolean}
     */
    ServiceOption.prototype.hasService = function()
    {
        return this._service !== undefined;
    };

    return ServiceOption;
}();