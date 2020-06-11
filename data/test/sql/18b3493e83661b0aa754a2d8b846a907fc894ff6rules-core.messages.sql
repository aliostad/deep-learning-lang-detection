CREATE OR REPLACE RULE rule_archive_message AS
	ON UPDATE TO core.messages WHERE new.msg_status NOT IN ('NEW', 'ROUTED', 'SENT') DO INSTEAD
(

	-- Insert updated message into archive
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

	-- Remove message from core.messages
	DELETE FROM core._messages_queue WHERE _messages_queue.id = old.id;

);

COMMENT ON RULE rule_archive_message ON core.messages IS 'Archive messages';

CREATE OR REPLACE RULE rule_enqueue_messages AS
	ON INSERT TO core.messages WHERE new.msg_status IN ('NEW', 'ROUTED', 'SENT') DO INSTEAD
	
	INSERT INTO core._messages_queue (
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
	)  VALUES (
		new.refer_id,
		new.uuid,
		new.src_app_id,
		new.dst_app_id,
		new.src_addr,
		new.dst_addr,
		now(),
		NULL,
		new.msg_status,
		new.external_id,
		new.charging,
		new.msg_type,
		new.msg_body,
		new.prio,
		0,
		new.extra,
		new.qty
	);

COMMENT ON RULE rule_enqueue_messages ON core.messages IS 'By default insert new messages into queue partition';

