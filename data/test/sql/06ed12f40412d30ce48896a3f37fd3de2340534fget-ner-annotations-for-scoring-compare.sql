SELECT  0 as `user`,
        `document_view`.`id` as `view_id`,
        `document_view`.`section_id`,
        `document_view`.`completed`,
        `ner_ann`.`start`,
        `ner_ann`.`type_idx`,
        `ner_ann`.`text`

FROM `document_view`

INNER JOIN `document_annotation`
  ON `document_annotation`.`view_id` = `document_view`.`id` AND `document_annotation`.`content_type_id` = {ct_id}

LEFT JOIN `entity_recognition_entityrecognitionannotation` as `ner_ann`
  ON `ner_ann`.`id` = `document_annotation`.`object_id`

WHERE `document_view`.`id` IN ({user_view_ids})

UNION ALL

SELECT  1 as `user`,
        `document_view`.`id` as `view_id`,
        `document_view`.`section_id`,
        `document_view`.`completed`,
        `ner_ann`.`start`,
        `ner_ann`.`type_idx`,
        `ner_ann`.`text`

FROM `document_view`

INNER JOIN `document_annotation`
  ON `document_annotation`.`view_id` = `document_view`.`id` AND `document_annotation`.`content_type_id` = {ct_id}

LEFT JOIN `entity_recognition_entityrecognitionannotation` as `ner_ann`
  ON `ner_ann`.`id` = `document_annotation`.`object_id`

WHERE `document_view`.`id` IN ({gm_view_ids})
