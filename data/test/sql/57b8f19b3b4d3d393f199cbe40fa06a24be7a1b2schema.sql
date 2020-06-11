

DROP TABLE density_data CASCADE;


CREATE TABLE density_data (
    dump_time       timestamp with time zone,
    group_id        integer,
    group_name      text,
    parent_id       integer,
    parent_name     text,
    client_count    integer,
    PRIMARY KEY(dump_time, group_id)
);

CREATE INDEX ON density_data (group_id, dump_time);
CREATE INDEX ON density_data (parent_id);

CREATE MATERIALIZED VIEW hour_window AS (
    SELECT
        date_trunc('hour', dump_time) AS hour,
        group_id,
        group_name,
        parent_id,
        parent_name,
        AVG(client_count) AS average_count,
        MAX(client_count) AS max_count,
        MIN(client_count) AS min_count
    FROM
        density_data
    GROUP BY
        group_id,
        group_name,
        parent_id,
        parent_name,
        date_trunc('hour', dump_time)
);
CREATE MATERIALIZED VIEW day_window AS (
    SELECT
        date_trunc('day', dump_time) AS day,
        group_id,
        group_name,
        parent_id,
        parent_name,
        AVG(client_count) AS average_count,
        MAX(client_count) AS max_count,
        MIN(client_count) AS min_count
    FROM
        density_data
    GROUP BY
        group_id,
        group_name,
        parent_id,
        parent_name,
        date_trunc('day', dump_time)
);

CREATE MATERIALIZED VIEW week_window AS (
    SELECT
        date_trunc('week', dump_time) AS week,
        group_id,
        group_name,
        parent_id,
        parent_name,
        AVG(client_count) AS average_count,
        MAX(client_count) AS max_count,
        MIN(client_count) AS min_count
    FROM
        density_data
    GROUP BY
        group_id,
        group_name,
        parent_id,
        parent_name,
        date_trunc('week', dump_time)
);

CREATE MATERIALIZED VIEW month_window AS (
    SELECT
        date_trunc('month', dump_time) AS month,
        group_id,
        group_name,
        parent_id,
        parent_name,
        AVG(client_count) AS average_count,
        MAX(client_count) AS max_count,
        MIN(client_count) AS min_count
    FROM
        density_data
    GROUP BY
        group_id,
        group_name,
        parent_id,
        parent_name,
        date_trunc('month', dump_time)
);


AlTER TABLE density_data OWNER TO adicu;
AlTER TABLE hour_window  OWNER TO adicu;
AlTER TABLE day_window   OWNER TO adicu;
AlTER TABLE week_window  OWNER TO adicu;
AlTER TABLE month_window OWNER TO adicu;

