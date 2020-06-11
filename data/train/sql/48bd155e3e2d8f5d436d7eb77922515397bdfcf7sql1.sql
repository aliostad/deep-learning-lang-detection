SELECT DISTINCT `T1_foaf_Person_view`.`foaf_name2`, `T2_foaf_Person_view`.`foaf_mbox`, 
`T1_foaf_Person_view`.`foaf_name`, `T3_skos_Concept_view`.`ID`, `T1_foaf_Person_view`.`ID` 
FROM `foaf_Person_conf_research_interests_view` AS `T3_-1842382083`, `foaf_Person_view` AS `T1_foaf_Person_view`, 
`skos_Concept_view` AS `T3_skos_Concept_view`, `skos_Concept_view` AS `T4_skos_Concept_view`, 
`foaf_Person_view` AS `T2_foaf_Person_view` 
WHERE (`T1_foaf_Person_view`.`ID` = `T3_-1842382083`.`ID_foaf_Person` 
AND `T1_foaf_Person_view`.`foaf_name2` IS NOT NULL AND `T1_foaf_Person_view`.`foaf_name` IS NOT NULL 
AND `T2_foaf_Person_view`.`ID` = `T3_-1842382083`.`ID_foaf_Person` AND `T2_foaf_Person_view`.`foaf_mbox` IS NOT NULL 
AND `T3_-1842382083`.`conf_research_interests` = `T3_skos_Concept_view`.`ID` 
AND `T3_skos_Concept_view`.`ID` = `T4_skos_Concept_view`.`ID` 
AND `T4_skos_Concept_view`.`skos_prefLabel` = 'E-Business' AND `T4_skos_Concept_view`.`skos_prefLabel` IS NOT NULL);