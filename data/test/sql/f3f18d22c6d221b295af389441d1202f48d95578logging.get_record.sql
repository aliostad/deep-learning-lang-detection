CREATE OR REPLACE FUNCTION logging.get_record(log_table character varying, log_seq integer)
 RETURNS SETOF log_record
AS $function$
"""
logging.get_record

"""
return_results = []
columns_processed = []

# Base GD key for storing plans for this log_table.
base_key = "logging_%s" % log_table

# Handle log_plan
log_plan_key = "%s_log_plan" % base_key
if GD.has_key(log_plan_key):
    log_plan = GD[log_plan_key]
else:
    log_plan = plpy.prepare("""
        SELECT schema_name, table_name, record_seq, modified_by, client_addr,
            query_id, date_modified, (
                SELECT event
                FROM logging."%s" b
                WHERE a.record_seq = b.record_seq
                ORDER BY seq DESC
                LIMIT 1
                ) as last_event
        FROM logging."%s" a
        WHERE seq = $1
        """ % (log_table, log_table), ["int4"])
    GD[log_plan_key] = log_plan

results = plpy.execute(log_plan, [log_seq])

if len(results) != 1:
    plpy.error("No log entry was found with that sequence number.")

record_seq = results[0]['record_seq']
schema_name = results[0]['schema_name']
table_name = results[0]['table_name']
modified_by = results[0]['modified_by']
client_addr = results[0]['client_addr']
query_id = results[0]['query_id']
date_modified = results[0]['date_modified']
last_event = results[0]['last_event']

# Handle the last_change_plan
last_change_plan_key = "%s_last_change_plan" % base_key
if GD.has_key(last_change_plan_key):
    last_change_plan = GD[last_change_plan_key]
else:
    last_change_query = """
        SELECT * FROM logging."%s"
        WHERE ROW(query_id, column_name)
            IN (
                SELECT  max(query_id) ,column_name
                FROM logging."%s"
                WHERE query_id <= $4
                GROUP BY schema_name, table_name, record_seq, column_name
                HAVING schema_name = $1 AND table_name = $2 
                    AND record_seq = $3
                ORDER BY column_name, min(query_id)
               )
        ORDER BY column_name, query_id;
    """ % (log_table, log_table)
    last_change_plan = plpy.prepare(last_change_query,
        ["text", "text", "int4", "int4"])
    GD[last_change_plan_key] = last_change_plan

last_change = plpy.execute(last_change_plan,
    [schema_name, table_name, record_seq, query_id])

for row in filter(lambda x: x['column_name'] != '', last_change):
    return_results.append({
        'seq': row['seq'],
        'column_name': row['column_name'],
        'column_value': row['new_value'],
        'modified_by': row['modified_by'],
        'client_addr': row['client_addr'],
        'query_id': row['query_id'],
        'date_modified': row['date_modified'],
        'record_seq': row['record_seq'],
        'schema_name': row['schema_name'],
        'table_name': row['table_name'],
        'event': row['event']
    })

    columns_processed.append(row['column_name'])

# Handle is_deleted_plan
#deleted_plan_key = "%s_deleted_plan" % base_key 
#if GD.has_key(deleted_plan_key):
#    is_deleted_plan = GD[deleted_plan_key]
#else:
#    is_deleted_query = """
#        SELECT event
#        FROM logging."%s"
#        WHERE record_seq = $1
#        ORDER BY seq DESC
#        LIMIT 1
#        """ % (log_table, log_table)
#    is_deleted_plan = plpy.prepare(is_deleted_query, ["int4"])
#    GD[deleted_plan_key] = is_deleted_plan
#
#event = plpy.execute(is_deleted_plan, [record_seq])[0]['event']
if last_event == 'DELETE':
    # Record was deleted. We will grab values from the DELETE record.

    # Handle final_change_plan
    final_change_plan_key = "%s_final_change_plan" % base_key
    if GD.has_key(final_change_plan_key):
        final_change_plan = GD[final_change_plan_key]
    else:
        final_change_query = """
            SELECT * FROM logging."%s"
            WHERE ROW(query_id, column_name)
                IN (
                    SELECT max(query_id) ,column_name
                    FROM logging."%s"
                    WHERE event = 'DELETE'
                    GROUP BY schema_name, table_name, record_seq, column_name
                    HAVING schema_name = $1 AND table_name = $2
                        AND record_seq = $3
                   )
            ORDER BY column_name, query_id;
            """ % (log_table, log_table)
        final_change_plan = plpy.prepare(final_change_query,
            ["text", "text", "int4"])
        GD[final_change_plan_key] = final_change_plan

    final_changes = plpy.execute(final_change_plan,
        [schema_name, table_name, record_seq])

    for row in filter(lambda x: x['column_name'] not in \
        columns_processed, final_changes):
        # Add it here
        return_results.append({
            'seq': row['seq'],
            'column_name': row['column_name'],
            'column_value': row['old_value'],
            'modified_by': row['modified_by'],
            'client_addr': row['client_addr'],
            'query_id': row['query_id'],
            'date_modified': row['date_modified'],
            'record_seq': row['record_seq'],
            'schema_name': row['schema_name'],
            'table_name': row['table_name'],
            'event': row['event']
        })

else:
    # Record still exists. Pull values from that instead.

    current_row_query = """
        SELECT * FROM "%s"."%s"
        WHERE seq = $1
        LIMIT 1
    """ % (schema_name, table_name)
    current_plan = plpy.prepare(current_row_query, ["int4"])
    current_row = plpy.execute(current_plan, [record_seq])

    columns = current_row[0].keys()
    for column in filter(lambda x: x not in columns_processed, columns):
        return_results.append({
            'seq': log_seq,
            'column_name': column,
            'column_value': current_row[0][column],
            'modified_by': modified_by,
            'client_addr': client_addr,
            'query_id': query_id,
            'date_modified': None,
            'record_seq': record_seq,
            'schema_name': schema_name,
            'table_name': table_name,
            'event': 'INSERT'
        })

return return_results

$function$ LANGUAGE plpythonu STABLE;
