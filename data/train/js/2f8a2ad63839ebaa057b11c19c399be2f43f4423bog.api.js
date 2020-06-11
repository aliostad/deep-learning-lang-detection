var bog = bog || {};
bog.api = {
    uri: {
        base: {
            pub: '',
            dash: '/dash'
        },
        auth: {
            isAuthenticated: '/auth/api/isauthenticated',
            logout: '/auth/api/logout'
        },
        search: {

        },
        profile: 'api/profile/',

        donations: 'api/donations/',
        donation: 'api/donation/',

        events: '/api/data/events/',
        event: '/api/data/event/',

        event_types: '/api/event_types/',
        event_type: '/api/event_type/',

        event_statuses: 'api/event/statuses/',

        solicitations: 'api/solicitations/',
        solicitation: 'api/solicitation/'
    }
};
