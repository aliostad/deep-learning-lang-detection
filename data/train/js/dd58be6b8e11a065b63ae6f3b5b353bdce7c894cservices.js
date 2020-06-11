'use strict';

module.exports = {
    'services': [
        {
            'name': 'bar.service.A',
            'service': require('./ServiceA')
        },
        {
            'name': 'bar.service.B',
            'service': require('./ServiceB'),
            'arguments': [
                '@bar.service.C'
            ]
        },
        {
            'name': 'bar.service.C',
            'service': require('./ServiceC'),
            'arguments': [
                '@bar.service.A',
                '@bar.service.D'
            ]
        },
        {
            'name': 'bar.service.D',
            'service': require('./ServiceD'),
            'arguments': [
                '@bar.service.A',
                '@bar.service.B'
            ]
        }
    ]
};
