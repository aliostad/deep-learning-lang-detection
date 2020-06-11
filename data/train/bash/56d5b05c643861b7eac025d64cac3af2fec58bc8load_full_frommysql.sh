set -u
set -o errexit
set -x
export PATH=$PATH:/home/deploy/analytics_scripts/includes/shell_includes



load_full_table.sh wms_prod rtr_reservation_status_history etl rtr_reservation_status_history &
load_full_table.sh wms_prod rtr_reservation_status etl rtr_reservation_status &
load_full_table.sh wms_prod audit_package_inbound etl audit_package_inbound &

load_full_table.sh rtrbi unit_history etl unit_history &
load_full_table.sh rtrbi booking_fulfillment etl booking_fulfillment &
load_full_table.sh rtrbi inventory_time_series etl inventory_time_series &
load_full_table.sh rtrbi booker_appointment etl booker_appointment &
load_full_table.sh rtrbi ss_pricing_tests etl ss_pricing_tests & 

load_full_table.sh analytics yp_general_size_scale etl yp_general_size_scale & 
load_full_table.sh analytics yp_general_size_sku etl yp_general_size_sku & 
load_full_table.sh analytics yp_autumn_full etl yp_autumn_full &
load_full_table.sh analytics bb_channel etl bb_channel & 

load_full_table.sh rtr_prod0808 reservation_booking etl reservation_booking &
load_full_table.sh rtr_prod0808 reservation_booking_detail etl reservation_booking_detail &
load_full_table.sh rtr_prod0808 rtr_order_groups etl rtr_order_groups &
load_full_table.sh rtr_prod0808 fulfillment_seq etl fulfillment_seq &
load_full_table.sh rtr_prod0808 fulfillment etl fulfillment &
load_full_table.sh rtr_prod0808 location etl location &
load_full_table.sh rtr_prod0808 unit etl unit &
load_full_table.sh rtr_prod0808 fulfillment_detail etl fulfillment_detail &
load_full_table.sh rtr_prod0808 po_reason etl po_reason &
load_full_table.sh rtr_prod0808 track_scans etl track_scans &
load_full_table.sh rtr_prod0808 uc_order_products etl uc_order_products &
load_full_table.sh rtr_prod0808 inbound_ups_summary etl inbound_ups_summary &
load_full_table.sh rtr_prod0808 uc_zones etl uc_zones &
load_full_table.sh rtr_prod0808 shipping_method etl shipping_method &
load_full_table.sh rtr_prod0808 rtr_promotion_redemption etl rtr_promotion_redemption &
load_full_table.sh rtr_prod0808 rtr_promotion etl rtr_promotion &
load_full_table.sh rtr_prod0808 unit_note etl unit_note &
load_full_table.sh rtr_prod0808 audit_unit etl audit_unit &
load_full_table.sh rtr_prod0808 users_extra etl users_extra &
load_full_table.sh rtr_prod0808 problem etl problem &
load_full_table.sh rtr_prod0808 product_prices etl product_prices &
load_full_table.sh rtr_prod0808 showroom_request etl showroom_request &
load_full_table.sh rtr_prod0808 showroom_order etl showroom_order &
load_full_table.sh rtr_prod0808 uc_order_comments etl uc_order_comments &
load_full_table.sh rtr_prod0808 simplereservation_code_statuses etl simplereservation_code_statuses &
load_full_table.sh rtr_prod0808 reason_class etl reason_class & 
load_full_table.sh rtr_prod0808 financial_adjustment etl financial_adjustment & 


