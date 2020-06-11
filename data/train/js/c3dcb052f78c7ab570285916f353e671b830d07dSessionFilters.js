Ext.define('ELUNA2015.view.SessionFilters', {
    extend: 'Ext.form.Panel',
    xtype: 'sessionfilters',

    config: {
        fullscreen: true,
        height: '100%',
        items: [
            {
                xtype: 'fieldset',
                title: 'Session Filters',
                items: [
                    {
                        xtype: 'multiselectfield',
                        options: [
                            {
                                text: 'Show Plenary Sessions',
                                value: 'show_plenary'
                            },
                            {
                                text: 'Show Alma Sessions',
                                value: 'show_alma'
                            },
                            {
                                text: 'Show Primo Sessions',
                                value: 'show_primo'
                            },
                            {
                                text: 'Show Aleph Sessions',
                                value: 'show_aleph'
                            },
                            {
                                text: 'Show Voyager Sessions',
                                value: 'show_voyager'
                            },
                            {
                                text: 'Show SFX Sessions',
                                value: 'show_sfx'
                            },
                            {
                                text: 'Show MetaLib Sessions',
                                value: 'show_metalib'
                            },
                            {
                                text: 'Show Other Sessions',
                                value: 'show_other'
                            },
                            {
                                text: 'Show 15th September Sessions',
                                value: 'show_15_september'
                            },
                            {
                                text: 'Show 16th September Sessions',
                                value: 'show_16_september'
                            },
                            {
                                text: 'Show 17th September Sessions',
                                value: 'show_17_september'
                            },
                            {
                                text: 'Show Conference Sessions',
                                value: 'show_conference'
                            },
                            {
                                text: 'Show Systems Seminar Sessions',
                                value: 'show_systems_seminar'
                            }
                        ]
                    }
                ]
            }
        ]
    }
});