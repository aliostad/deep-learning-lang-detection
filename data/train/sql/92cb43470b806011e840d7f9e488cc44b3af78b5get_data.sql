-- Get all of the updates
SELECT
  "nps_cartodb_line_view"."cartodb_id",
  ST_AsGeoJSON(ST_Transform("nps_cartodb_line_view"."the_geom", 4326))::text AS "the_geom",
  "nps_cartodb_line_view"."class",
  "nps_cartodb_line_view"."name",
  "nps_cartodb_line_view"."places_created_at",
  "nps_cartodb_line_view"."places_id",
  "nps_cartodb_line_view"."places_updated_at",
  "nps_cartodb_line_view"."superclass",
  "nps_cartodb_line_view"."tags",
  "nps_cartodb_line_view"."type",
  "nps_cartodb_line_view"."unit_code",
  "nps_cartodb_line_view"."version"
FROM
  "nps_cartodb_line_view"
WHERE
  "nps_cartodb_line_view"."cartodb_id" = ANY({{changes}});

