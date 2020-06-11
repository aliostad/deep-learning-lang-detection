from django.core.urlresolvers import reverse

def steps_nav(user, selected, bid=-1):
    
    all_steps = [
            #'text'         
            #   'styling_class(es)',    
            #       'links_to'
            #           'permission_required'
            #               'selected'
            ['Load Roster', 
                '',  
                    reverse('tourney:manage_roster'),
                        'staff',
                            'manage_roster',
            ],
            ['New Bracket', 
                '',  
                    reverse('tourney:new_bracket'),
                        'staff',
                            'new_bracket',
            ],
            ['Choose Bracket', 
                '',  
                    reverse('tourney:choose_bracket'),
                        'staff',
                            'choose_bracket',
            ],
            ['Clone Bracket', 
                '',  
                    reverse('tourney:bracket:clone_bracket', kwargs={'bracket': bid}),
                        'staff',
                            'clone_bracket',
            ],
            ['Manage Bracket', 
                '',  
                    reverse('tourney:bracket:manage_bracket', kwargs={'bracket': bid}),
                        'staff',
                            'manage_bracket',
            ],
            ['Manage Competitors', 
                '',  
                    reverse('tourney:bracket:manage_competitors', kwargs={'bracket': bid}),
                        'staff',
                            'manage_competitors',
            ],
            ['Manage Judges', 
                '',  
                    reverse('tourney:bracket:manage_judges', kwargs={'bracket': bid}),
                        'staff',
                            'manage_judges',
            ],
            ['Review Bracket', 
                '',  
                    reverse('tourney:bracket:review_bracket', kwargs={'bracket': bid}),
                        'staff',
                            'review_bracket',
            ],
        ]

    steps_nav = []
    for nn in all_steps:
        # style the selected option
        if nn[4] == selected:
            nn[1] = 'current'
        # permission?
        if nn[3] == 'any':
            steps_nav.append(nn)
        elif nn[3] == 'staff' and user.is_staff:
            steps_nav.append(nn)

    return steps_nav

