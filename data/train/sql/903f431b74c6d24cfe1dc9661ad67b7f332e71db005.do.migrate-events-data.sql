DO $$
  BEGIN
    PERFORM * FROM schemaversion WHERE name = 'migrate-events-data';

    IF NOT FOUND THEN

      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      DECLARE
        event RECORD;
        attendanceObject RECORD;
        ticket_string character varying;
        sessionId character varying;
      BEGIN
        FOR event in SELECT * FROM cd_events
        LOOP
            sessionId := uuid_generate_v4();
            ticket_string := '{"name": "General Admission", "type": "other", "quantity":'||event.capacity||'}';
            INSERT INTO cd_sessions (id, name, description, event_id, tickets, status) VALUES (sessionId, 'General', 'General Session', event.id, array[ticket_string::json], 'active');
            UPDATE cd_applications SET ticket_name = 'General Admission', ticket_type = 'other', session_id = sessionId, created = NOW() WHERE event_id = event.id; 
            FOR attendanceObject in SELECT * FROM cd_attendance WHERE event_id = event.id AND attended = TRUE
            LOOP
                UPDATE cd_applications SET attendance = (array_append(attendance, attendanceObject.event_date)::timestamp with time zone[]) WHERE event_id = event.id AND user_id = attendanceObject.user_id;
            END LOOP;
        END LOOP;
      END;
    ELSE
      RAISE NOTICE 'events data has already been migrated.';
      END IF;
  END;
$$