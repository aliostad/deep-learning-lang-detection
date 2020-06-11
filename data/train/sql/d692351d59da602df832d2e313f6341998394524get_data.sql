-- Get all of the updates
SELECT
  "nps_cartodb_polygon_view"."cartodb_id",
  ST_AsGeoJSON(ST_Transform("nps_cartodb_polygon_view"."the_geom", 4326))::text AS "the_geom",
  "nps_cartodb_polygon_view"."class",
  "nps_cartodb_polygon_view"."name",
  "nps_cartodb_polygon_view"."places_created_at",
  "nps_cartodb_polygon_view"."places_id",
  "nps_cartodb_polygon_view"."places_updated_at",
  "nps_cartodb_polygon_view"."superclass",
  "nps_cartodb_polygon_view"."tags",
  "nps_cartodb_polygon_view"."type",
  "nps_cartodb_polygon_view"."unit_code",
  "nps_cartodb_polygon_view"."version"
FROM
  "nps_cartodb_polygon_view"
WHERE
  "nps_cartodb_polygon_view"."cartodb_id" = ANY({{changes}});

