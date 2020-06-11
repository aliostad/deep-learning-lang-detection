select *
from
(
        -- Lane changes to the right
        select
          l.subject as "subject",
          l.start as "lane_change_start",
          l.cross as "lane_change_cross",
          l.end as "lane_change_end",
          _flash.on,
          _flash.off,
          _flash.duration,
          l.start - _flash.on as "turnsignal_onset",
          l.end - _flash.off as "turnsignal_offset",
          l.direction,
          l.start_lane,
          l.end_lane

        from "2009-onrd-pta".lanechanges l, lateral (
          select
            min(unique_unix_timestamp) as "on",
            max(unique_unix_timestamp) as "off",
            max(unique_unix_timestamp) - min(unique_unix_timestamp) as "duration"
          from "2009-onrd-pta".daq d
          where d.subject_id = l.subject and
          d.unique_unix_timestamp between
            ( select greatest(max(_inner.end), l.start - 10)
              from "2009-onrd-pta".lanechanges _inner
              where _inner.end < l.start
              and _inner.subject = l.subject
            )
            and
            ( select least(min(_inner.start), l.end + 10)
              from "2009-onrd-pta".lanechanges _inner
              where _inner.start > l.end
              and _inner.subject = l.subject
            )
            and d.turn_indicator_flash = 2
        ) _flash

        where l.direction = 'R'

        union

        -- Lane changes to the left
        select
          l.subject as "subject",
          l.start as "lane_change_start",
          l.cross as "lane_change_cross",
          l.end as "lane_change_end",
          _flash.on,
          _flash.off,
          _flash.duration,
          l.start - _flash.on as "turnsignal_onset",
          l.end - _flash.off as "turnsignal_offset",
          l.direction,
          l.start_lane,
          l.end_lane

        from "2009-onrd-pta".lanechanges l, lateral (
          select
            min(unique_unix_timestamp) as "on",
            max(unique_unix_timestamp) as "off",
            max(unique_unix_timestamp) - min(unique_unix_timestamp) as "duration"
          from "2009-onrd-pta".daq d
          where d.subject_id = l.subject and
          d.unique_unix_timestamp between
            ( select greatest(max(_inner.end), l.start - 10)
              from "2009-onrd-pta".lanechanges _inner
              where _inner.end < l.start
              and _inner.subject = l.subject
            )
            and
            ( select least(min(_inner.start), l.end + 10)
              from "2009-onrd-pta".lanechanges _inner
              where _inner.start > l.end
              and _inner.subject = l.subject
            )
            and d.turn_indicator_flash = 1
        ) _flash

        where l.direction = 'L'
) _result
order by subject, lane_change_start