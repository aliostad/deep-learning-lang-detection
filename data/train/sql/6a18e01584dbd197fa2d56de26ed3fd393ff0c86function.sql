create or replace function test_table_sample_async_scan(
    np_streams_qty integer,
    tp_view_name text DEFAULT 'test_table_view'::text,
    tp_host text DEFAULT 'localhost'::text,
    tp_database text DEFAULT current_database()::text,
    tp_user text DEFAULT current_user::text,
    tp_password text DEFAULT '123456'::text)
  returns setof record as
$BODY$
import psycopg2
import select
import math


def wait(conp_conn):
    while 1:
        sv_state = conp_conn.poll()
        if sv_state == psycopg2.extensions.POLL_OK:
            break
        elif sv_state == psycopg2.extensions.POLL_WRITE:
            select.select([], [conp_conn.fileno()], [])
        elif sv_state == psycopg2.extensions.POLL_READ:
            select.select([conp_conn.fileno()], [], [])
        else:
            raise psycopg2.OperationalError("poll() returned %s" % sv_state)


def execute_async(conp_conn, tp_query):
    wait(conp_conn)
    cv_cur = conp_conn.cursor()
    cv_cur.execute(tp_query)
    return cv_cur


def wait_operations(conpa_conns, cpa_curs):
    for nv_number in range(0, len(conpa_conns)):
        # wait and close connection
        wait(conpa_conns[nv_number])
        cpa_curs[nv_number].close()
        conpa_conns[nv_number].close()


def create_views_async(tp_conn_string, np_streams, tp_name):
    nv_rows = int(plpy.execute("select max(id) as qty from test_table tt")[0]["qty"])
    if nv_rows < np_streams:
        np_streams = nv_rows

    nv_batch_size = math.floor(nv_rows / np_streams)
    conva_conns = []
    cva_curs = []
    tv_union = tv_drop = ""
    # create connections async
    for nv_number in range(0, np_streams):
        conva_conns.append(psycopg2.connect(tp_conn_string, async=1))

    for nv_number in range(0, np_streams):
        tv_matview_query_tail = ""
        if nv_number != (np_streams - 1):
            nv_first_limit = 1 + nv_number * nv_batch_size
            nv_second_limit = 1 + (nv_number + 1) * nv_batch_size - 1
            tv_matview_query_tail += ("between %s and %s" % (nv_first_limit, nv_second_limit))
        else:
            nv_first_limit = 1 + nv_number * nv_batch_size
            tv_matview_query_tail += (">= %s" % nv_first_limit)
        tv_current_view_name = tp_name + "_" + str(nv_number + 1) + "_" + str(np_streams)
        tv_view_query = ("""create materialized view %s as
                            select tt.color,
                                   sum(tt.qty) as qty
                              from test_table tt
                             where tt.id %s
                             group by tt.color;
                         """ % (tv_current_view_name,
                                tv_matview_query_tail))
        cva_curs.append(execute_async(conva_conns[nv_number], tv_view_query))
        tv_union += ("select * from %s union all " % tv_current_view_name)
        tv_drop += ("drop materialized view %s; " % tv_current_view_name)

    wait_operations(conva_conns, cva_curs)
    return tv_union, tv_drop


# build connection string
tv_conn_string = ("host=%s dbname=%s user=%s password=%s" % (tp_host, tp_database, tp_user, tp_password))
# create views asyns and wait
tv_views_union, tv_views_drop = create_views_async(tv_conn_string,
                                                   np_streams_qty,
                                                   tp_view_name)
# get records
recav_main_records = plpy.execute(("""select tt.color,
                                             sum(tt.qty)::integer as qty
                                        from (%s) tt
                                       group by tt.color
                                       order by qty desc;
                                   """ % tv_views_union[0:-11]))
# drop matviews
plpy.execute(tv_views_drop)
# return records
return recav_main_records
$BODY$
  language plpython3u volatile
  cost 100;
