SET work_mem='64MB';
SHOW work_mem;

WITH
  personas_this_period(show_id, persona_id) AS (
    SELECT DISTINCT show_id, persona_id
    FROM twitter_interactions
      JOIN show_bindings USING (interaction_id)
      JOIN twitter_personas USING (screen_name)
    WHERE twitter_interactions.created_at >= '2011-10-17' AND twitter_interactions.created_at < '2011-10-23'
      AND show_bindings.created_at >= '2011-10-17' AND show_bindings.created_at < '2011-10-23'
  UNION ALL
    SELECT DISTINCT show_id, persona_id
    FROM facebook_interactions
      JOIN show_bindings USING (interaction_id)
      JOIN facebook_personas USING (facebook_user_id)
    WHERE facebook_interactions.created_at >= '2011-10-17' AND facebook_interactions.created_at < '2011-10-23'
      AND show_bindings.created_at >= '2011-10-17' AND show_bindings.created_at < '2011-10-23')

, personas_last_period(show_id, persona_id) AS (
    SELECT DISTINCT show_id, persona_id
    FROM twitter_interactions
      JOIN show_bindings USING (interaction_id)
      JOIN twitter_personas USING (screen_name)
    WHERE twitter_interactions.created_at >= '2011-10-10' AND twitter_interactions.created_at < '2011-10-17'
      AND show_bindings.created_at >= '2011-10-10' AND show_bindings.created_at < '2011-10-17'
  UNION ALL
    SELECT DISTINCT show_id, persona_id
    FROM facebook_interactions
      JOIN show_bindings USING (interaction_id)
      JOIN facebook_personas USING (facebook_user_id)
    WHERE facebook_interactions.created_at >= '2011-10-10' AND facebook_interactions.created_at < '2011-10-17'
      AND show_bindings.created_at >= '2011-10-10' AND show_bindings.created_at < '2011-10-17')

, all_personas(show_id, persona_id) AS (
    SELECT show_id, persona_id
    FROM personas_last_period
  UNION
    SELECT show_id, persona_id
    FROM personas_this_period)

, loyal_personas(show_id, persona_id) AS (
    SELECT show_id, persona_id
    FROM personas_last_period
  INTERSECT
    SELECT show_id, persona_id
    FROM personas_this_period)

SELECT
    show_id
  , name
  , loyal_personas_count
  , all_personas_count
  , loyalty_percentage
FROM (
    SELECT
        show_id
      , loyal_personas_count
      , all_personas_count
      , 100.0 * loyal_personas_count / all_personas_count AS loyalty_percentage
    FROM (
        SELECT show_id, COUNT(*)
        FROM loyal_personas
        GROUP BY show_id) AS loyal_counts(show_id, loyal_personas_count)
      JOIN (
        SELECT show_id, COUNT(*)
        FROM all_personas
        GROUP BY show_id) AS all_counts(show_id, all_personas_count) USING(show_id)) AS t1
  JOIN shows USING (show_id)
ORDER BY loyalty_percentage DESC
