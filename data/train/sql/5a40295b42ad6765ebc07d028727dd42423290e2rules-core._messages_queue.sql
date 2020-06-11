CREATE OR REPLACE RULE rule_archive_message_q AS
	ON UPDATE TO core._messages_queue WHERE new.msg_status NOT IN ('NEW', 'ROUTED', 'SENT') DO INSTEAD
(
	
	INSERT INTO core._messages_archive (
		id,
		refer_id,
		uuid,
		src_app_id,
		dst_app_id,
		src_addr,
		dst_addr,
		date_received,
		date_processed,
		msg_status,
		external_id,
		charging,
		msg_type,
		msg_body,
		prio,
		retries,
		extra,
		qty
	) VALUES (
		new.id,
		new.refer_id,
		new.uuid,
		new.src_app_id,
		new.dst_app_id,
		new.src_addr,
		new.dst_addr,
		old.date_received,
		now(),
		new.msg_status,
		new.external_id,
		new.charging,
		new.msg_type,
		new.msg_body,
		new.prio,
		new.retries,
		new.extra,
		new.qty
	);

 DELETE FROM core._messages_queue WHERE _messages_queue.id = old.id;

);

COMMENT ON RULE rule_archive_message_q ON core._messages_queue IS 'Move messages to archive if processed';

