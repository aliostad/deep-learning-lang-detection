/**
 * Main application routes
 */

'use strict';

module.exports = function(app) {

    app.use('/api/users', require('./api/user'));
    app.use('/api/categories', require('./api/category'));
    app.use('/api/foods', require('./api/food'));
    app.use('/api/tables', require('./api/table'));
    app.use('/api/taxes', require('./api/tax'));
    app.use('/api/discounts', require('./api/discount'));
    app.use('/api/orders', require('./api/order'));


    /*    app.use('/auth', require('./auth'));
        app.use('/api/users', require('./api/user'));
        app.use('/api/foods', require('./api/food'));
        app.use('/api/images', require('./api/image'));
        app.use('/api/taxes', require('./api/tax'));
        app.use('/api/discounts', require('./api/discount'));
        app.use('/api/tables', require('./api/table'));
        app.use('/api/orders', require('./api/order'));
        app.use('/api/things', require('./api/thing'));
        app.use('/api/updates', require('./api/update'));*/

    app.route('/:url(api|auth)/*')
        .get(function (req, res) {
            res.json({
                message: 'Hello dog!!!'
            })
        });

    app.route('/*')
        .get(function( req, res) {
            res.json({
                message: 'Hello dog!!!'
            })
        });
};
