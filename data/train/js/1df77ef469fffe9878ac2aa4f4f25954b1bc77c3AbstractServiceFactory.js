/**
 * @class AbstractServiceFactory
 *
 * @author: darryl.west@roundpeg.com
 * @created: 8/13/14 9:03 AM
 */
const dash = require('lodash' ),
    IndexPageService = require( '../services/IndexPageService' ),
    WebStatusService = require( '../services/WebStatusService' );

const AbstractServiceFactory = function(options) {
    'use strict';

    const factory = this,
        log = options.log,
        createLogger = options.createLogger;

    let services = {};

    /**
     * creates a single instance of IndexPageService
     *
     * @returns the index page service
     */
    this.createIndexPageService = function() {
        let service = services[ IndexPageService.SERVICE_NAME ];

        if (!service) {
            log.info('create index page service');

            const opts = dash.clone( options );
            opts.log = createLogger( IndexPageService.SERVICE_NAME );

            service = new IndexPageService( opts );

            services[ IndexPageService.SERVICE_NAME ] = service;
        }

        return service;
    };

    /**
     * creates a single instance of WebStatusService
     *
     * @returns the service instance
     */
    this.createWebStatusService = function() {
        let service = services[ WebStatusService.SERVICE_NAME ];

        if (!service) {
            log.info('create web status service');

            const opts = dash.clone( options );
            opts.log = createLogger( WebStatusService.SERVICE_NAME );

            // TODO : replace with a real data service to query os and stats
            opts.dataService = {};

            service = new WebStatusService( opts );

            services[ WebStatusService.SERVICE_NAME ] = service;
        }

        return service;
    };

    // constructor validations
    if (!log) {
        throw new Error('service factory must be constructed with a log');
    }
    if (!createLogger) {
        throw new Error('service factory must be constructed with a create logger method');
    }
};

AbstractServiceFactory.extend = function(child, options) {
    'use strict';
    const parent = new AbstractServiceFactory( options );

    dash.extend( child, parent );

    return parent;
};

module.exports = AbstractServiceFactory;
