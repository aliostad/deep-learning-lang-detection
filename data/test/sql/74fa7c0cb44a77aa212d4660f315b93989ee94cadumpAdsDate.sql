from
    (
        select
            impressionid,
            adid,
            userid,
            country,
            userage,
            usersex
        from
            join ads
                on (s.songid = st.songid
                    and s.year = '${hiveconf:year}'
                    and s.month = '${hiveconf:month}'
                    and s.date = '${hiveconf:date}'
                    and s.clicked = 1)
    ) t
-- dump ads table for user ads
insert overwrite tableuser_ad_day_dump
partition (
    year = '${hiveconf:year}',
    month = '${hiveconf:month}',
    weekofyear = '${hiveconf:weekofyear}',
    logdate = '${hiveconf:date}'
)
select
    userid,
    adid,
    count(distinct impressionid)
group by
    userid,
    tagid
-- dump streams table for user demo
insert overwrite table ad_demographics_day_dump
partition (
    year = '${hiveconf:year}',
    month = '${hiveconf:month}',
    weekofyear = '${hiveconf:weekofyear}',
    logdate = '${hiveconf:date}'
)
select
    adid,
    country,
    age,
    gender,
    count(distinct impressionid)
group by
    adid,
    country,
    age,
    gender
