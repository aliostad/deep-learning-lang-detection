-- Get all of the updates
SELECT
  "nps_cartodb_point_view"."cartodb_id",
  ST_AsGeoJSON(ST_Transform("nps_cartodb_point_view"."the_geom", 4326))::text AS "the_geom",
  "nps_cartodb_point_view"."class",
  "nps_cartodb_point_view"."name",
  "nps_cartodb_point_view"."places_created_at",
  "nps_cartodb_point_view"."places_id",
  "nps_cartodb_point_view"."places_updated_at",
  "nps_cartodb_point_view"."superclass",
  "nps_cartodb_point_view"."tags",
  "nps_cartodb_point_view"."type",
  "nps_cartodb_point_view"."unit_code",
  "nps_cartodb_point_view"."version"
FROM
  "nps_cartodb_point_view"
WHERE
  "nps_cartodb_point_view"."cartodb_id" = ANY({{changes}});

