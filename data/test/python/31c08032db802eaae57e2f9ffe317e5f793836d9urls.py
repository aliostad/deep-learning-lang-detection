from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^eagleeye/$', 'sharing.staff_controller.eagle_eye'),
    (r'^kpi/$', 'sharing.staff_controller.kpi'),
    (r'^kpi_csv/$', 'sharing.staff_controller.kpi_csv'),
    (r'^count_q/$', 'sharing.staff_controller.count_query'),
    (r'^pickmeapp_orders_map/$', 'sharing.staff_controller.pickmeapp_orders_map'),
    (r'^sharing_orders_map/$', 'sharing.staff_controller.sharing_orders_map'),
    (r'^get_orders_map_data/$', 'sharing.staff_controller.get_orders_map_data'),
    (r'^passenger_csv/$', 'sharing.staff_controller.passenger_csv'),
    (r'^send_orders_data_csv/$', 'sharing.staff_controller.send_orders_data_csv'),
    (r'^send_users_data_csv/$', 'sharing.staff_controller.send_users_data_csv'),
    (r'^staff/view_passenger_orders/(?P<passenger_id>\d+)/$', 'sharing.staff_controller.view_passenger_orders'),
    (r'^staff/cancel_order/(?P<order_id>\d+)/$', 'sharing.staff_controller.cancel_order'),
    (r'^staff/cancel_billing/(?P<order_id>\d+)/$', 'sharing.staff_controller.cancel_billing'),
    (r'^staff/ride/(?P<ride_id>\d+)/$', 'sharing.staff_controller.ride_page'),
    (r'^staff/reassign_ride/$', 'sharing.staff_controller.manual_assign_ride'),
    (r'^staff/resend_to_fleet_manager/(?P<ride_id>\d+)/$', 'sharing.staff_controller.resend_to_fleet_manager'),
    (r'^staff/accept_ride/(?P<ride_id>\d+)/$', 'sharing.staff_controller.accept_ride'),
    (r'^staff/complete_ride/(?P<ride_id>\d+)/$', 'sharing.staff_controller.complete_ride'),
    (r'^staff/station_snapshot/(?P<station_id>\d+)/$', 'sharing.staff_controller.station_snapshot'),
    (r'^staff/station_snapshot_update/(?P<station_id>\d+)/$', 'sharing.staff_controller.station_snapshot_update'),
    (r'^staff/station_snapshot_img/(?P<station_id>\d+)/$', 'sharing.staff_controller.station_snapshot_img'),

    (r'^passenger/home/$', 'sharing.passenger_controller.passenger_home'),
    (r'^qr/\w+/$', 'sharing.passenger_controller.passenger_home'),
    (r'^arlozrovBridge/$', 'sharing.passenger_controller.passenger_home'),
    (r'^arlozrovCards/$', 'sharing.passenger_controller.passenger_home'),
    (r'^pg_home/$', 'sharing.passenger_controller.pg_home'),
    url(r'^user/profile/$', 'sharing.passenger_controller.user_profile', name="user_profile"),
    (r'^book_ride/$', 'sharing.passenger_controller.book_ride'),
    (r'^services/resend_voucher/(?P<ride_id>\d+)/$', 'sharing.station_controller.resend_voucher'),
    url(r'^startup_message/$', 'sharing.passenger_controller.startup_message', name="startup_message"),

#    (r'^mark_ride_not_taken_task/$', 'sharing.sharing_dispatcher.mark_ride_not_taken_task'),
#    TODO_WB: resolve conflicts with ordering.urls
    (r'^workstation/(?P<workstation_id>\d+)/$', 'sharing.station_controller.sharing_workstation_home'),
    (r'^workstation_data/$', 'sharing.station_controller.sharing_workstation_data'),
    (r'^workstation/snapshot/$', 'sharing.station_controller.snapshot'),
    (r'^workstation/exit$', 'sharing.station_controller.workstation_exit'),
    (r'^ride_viewed/(?P<ride_id>\d+)/$', 'sharing.station_controller.ride_viewed'),
    (r'^manual_dispatch_ride/(?P<ride_id>\d+)/$', 'sharing.station_controller.manual_dispatch'),
    (r'^reassign_ride/(?P<ride_id>\d+)/$', 'sharing.station_controller.reassign_ride'),
    (r'^sharing/check_auth/$', 'sharing.station_controller.workstation_auth'),

    (r'^resolve_structured_address/$', 'sharing.passenger_controller.resolve_structured_address'),

    (r'^forgot_password/$', 'sharing.passenger_controller.verify_passenger'),
    (r'^change_credentials/$', 'sharing.passenger_controller.change_credentials'),

    (r'^registration/(?P<step>\w+)/$', 'sharing.passenger_controller.registration'),
    url(r'^registration/$', 'sharing.passenger_controller.registration', name="join"),
    url(r'^login_redirect/$', 'sharing.passenger_controller.post_login_redirect', name="login_redirect"),
    url(r'^send_verification_code/$', 'sharing.passenger_controller.send_sms_verification', name="send_verification_code"),
    url(r'^register_user/$', 'sharing.passenger_controller.do_register_user', name="register_user"),
    url(r'^register_passenger/$', 'sharing.passenger_controller.do_register_passenger', name="register_passenger"),
    url(r'^login_passenger/$', 'sharing.passenger_controller.passenger_login', name="login_passenger"),

    url(r'^privacy/$', 'sharing.content_controller.privacy', name="privacy"),
    url(r'^terms/$', 'sharing.content_controller.terms', name="terms"),
    url(r'^about/$', 'sharing.content_controller.about', name="about"),
    url(r'^welcome_email/$', 'sharing.content_controller.welcome_email'),

    url(r'^my_rides/$', 'sharing.content_controller.my_rides', name="my_rides"),

    url(r'^services/get_sharing_cities/$', 'sharing.content_controller.get_sharing_cities', name="get_sharing_cities"),

    url(r'^cron/dispatch_rides/$', 'sharing.sharing_dispatcher.dispatching_cron'),



)
