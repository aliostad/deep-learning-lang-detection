# NEW=10721
# OLD=17081


update Server set customer_id=NEW where customer_id=OLD;
update ServerGroup set customer_id=NEW where customer_id=OLD;
update CompoundService set customer_id=NEW where customer_id=OLD;
update Contact set customer_id=NEW where customer_id=OLD;
update ContactGroup set customer_id=NEW where customer_id=OLD;
update CustomerAttribute set customer_id=NEW where customer_id=OLD;
update CustomerLog set customer_id=NEW where customer_id=OLD;
update Invoice set customer_id=NEW where customer_id=OLD;
update Transaction set customer_id=NEW where customer_id=OLD;
update MaintenanceSchedule set customer_id=NEW where customer_id=OLD;
update MaintenancePeriod set customer_id=NEW where customer_id=OLD;
update NotificationSchedule set customer_id=NEW where customer_id=OLD;
update PaypalProfile set customer_id=NEW where customer_id=OLD;
update PublicReport set customer_id=NEW where customer_id=OLD;
update RemoteAgent set customer_id=NEW where customer_id=OLD;
update APIUser set customer_id=NEW where customer_id=OLD;
update TemplateFragment set customer_id=NEW where customer_id=OLD;

