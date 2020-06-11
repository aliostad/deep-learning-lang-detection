SELECT     dbo.knowledge.onetsoc_code, data_value, dbo.knowledge.scale_id, dbo.knowledge.element_id, dbo.content_model_reference.element_name, dbo.content_model_reference.description
FROM         dbo.knowledge INNER JOIN
                      dbo.content_model_reference ON dbo.knowledge.element_id = dbo.content_model_reference.element_id
WHERE     (dbo.knowledge.recommend_suppress = 'Y')
UNION
SELECT     dbo.skills.onetsoc_code,data_value, dbo.skills.scale_id, dbo.skills.element_id, dbo.content_model_reference.element_name, dbo.content_model_reference.description
FROM         dbo.skills INNER JOIN
                      dbo.content_model_reference ON dbo.skills.element_id = dbo.content_model_reference.element_id
WHERE     (dbo.skills.recommend_suppress = 'Y')
UNION
SELECT     dbo.abilities.onetsoc_code,data_value, dbo.abilities.scale_id, dbo.abilities.element_id, dbo.content_model_reference.element_name, dbo.content_model_reference.description
FROM         dbo.abilities INNER JOIN
                      dbo.content_model_reference ON dbo.abilities.element_id = dbo.content_model_reference.element_id
WHERE     (dbo.abilities.recommend_suppress = 'Y')
UNION
SELECT     dbo.work_styles.onetsoc_code,data_value, dbo.work_styles.scale_id, dbo.work_styles.element_id, dbo.content_model_reference.element_name, dbo.content_model_reference.description
FROM         dbo.work_styles INNER JOIN
                      dbo.content_model_reference ON dbo.work_styles.element_id = dbo.content_model_reference.element_id
WHERE     (dbo.work_styles.recommend_suppress = 'Y')
UNION
SELECT     dbo.work_activities.onetsoc_code,data_value, dbo.work_activities.scale_id, dbo.work_activities.element_id, dbo.content_model_reference.element_name, dbo.content_model_reference.description
FROM         dbo.work_activities INNER JOIN
                      dbo.content_model_reference ON dbo.work_activities.element_id = dbo.content_model_reference.element_id
WHERE     (dbo.work_activities.recommend_suppress = 'Y')
UNION
SELECT     dbo.work_context.onetsoc_code, data_value, dbo.work_context.scale_id, dbo.work_context.element_id, dbo.content_model_reference.element_name, dbo.content_model_reference.description
FROM         dbo.work_context INNER JOIN
                      dbo.content_model_reference ON dbo.work_context.element_id = dbo.content_model_reference.element_id
WHERE     (dbo.work_context.recommend_suppress = 'Y')

