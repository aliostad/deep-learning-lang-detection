response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Home'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Contracts'),URL('default','contract')==URL(),URL('default','contract'),[]),
(T('About'),URL('default','about')==URL(),URL('default','about'),[]),
(T('Contact'),URL('default','contact')==URL(),URL('default','contact'),[]),
#(T('Building'),URL('default','building_manage')==URL(),URL('default','building_manage'),[]),
#(T('Floor'),URL('default','floor_manage')==URL(),URL('default','floor_manage'),[]),
#(T('Apartment'),URL('default','apartment_manage')==URL(),URL('default','apartment_manage'),[]),
#(T('Apartment Type'),URL('default','apartment_type_manage')==URL(),URL('default','apartment_type_manage'),[]),
#(T('User Info'),URL('default','user_info_manage')==URL(),URL('default','user_info_manage'),[]),
#(T('Contract'),URL('default','contract_manage')==URL(),URL('default','contract_manage'),[]),
#(T('Semester'),URL('default','semester_manage')==URL(),URL('default','semester_manage'),[]),
#(T('Parking'),URL('default','parking_manage')==URL(),URL('default','parking_manage'),[]),
#(T('Request'),URL('default','request_manage')==URL(),URL('default','request_manage'),[]),
#(T('Request Comments'),URL('default','request_comments_manage')==URL(),URL('default','request_comments_manage'),[]),
#(T('Request Type'),URL('default','request_type_manage')==URL(),URL('default','request_type_manage'),[]),
#(T('Room'),URL('default','room_manage')==URL(),URL('default','room_manage'),[]),
#(T('Room Type'),URL('default','room_type_manage')==URL(),URL('default','room_type_manage'),[]),
#(T('T Building'),URL('default','t_building_manage')==URL(),URL('default','t_building_manage'),[]),
#(T('T Floor'),URL('default','t_floor_manage')==URL(),URL('default','t_floor_manage'),[]),
#(T('T Apartment'),URL('default','t_apartment_manage')==URL(),URL('default','t_apartment_manage'),[]),
#(T('T Apartment Type'),URL('default','t_apartment_type_manage')==URL(),URL('default','t_apartment_type_manage'),[]),
#(T('T User Info'),URL('default','t_user_info_manage')==URL(),URL('default','t_user_info_manage'),[]),
#(T('T Contract'),URL('default','t_contract_manage')==URL(),URL('default','t_contract_manage'),[]),
#(T('T Semester'),URL('default','t_semester_manage')==URL(),URL('default','t_semester_manage'),[]),
#(T('T Parking'),URL('default','t_parking_manage')==URL(),URL('default','t_parking_manage'),[]),
#(T('T Request'),URL('default','t_request_manage')==URL(),URL('default','t_request_manage'),[]),
#(T('T Request Comments'),URL('default','t_request_comments_manage')==URL(),URL('default','t_request_comments_manage'),[]),
#(T('T Request Type'),URL('default','t_request_type_manage')==URL(),URL('default','t_request_type_manage'),[]),
#(T('T Room'),URL('default','t_room_manage')==URL(),URL('default','t_room_manage'),[]),
#(T('T Room Type'),URL('default','t_room_type_manage')==URL(),URL('default','t_room_type_manage'),[]),
]
