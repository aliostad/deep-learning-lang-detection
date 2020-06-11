# -*- coding: utf-8 -*-

#from django.db.models import Q

from string import Template

reportSQLDict = {
   'genotype_report': Template("""
SELECT
    api_questionnaireob.obid,
    subjectname,
    qstudy.name AS QStudy,
    cohort,
    att_key,
    att_value
FROM api_biosubject
LEFT JOIN api_questionnaireob
    ON api_questionnaireob.biosubject_id = api_biosubject.obid
LEFT JOIN api_genotypeob
    ON api_genotypeob.biosubject_id = api_biosubject.obid
LEFT JOIN api_study AS qstudy
    ON qstudy.obid = api_questionnaireob.study_id
WHERE cohort='$cohort'
--    AND surveystudy.study='$study'
$limit
"""),
   'genotype_extract': Template("""
SELECT
    subjectname,
    cohort,
    genotypeobserved,
    finalgenotype
FROM api_biosubject
LEFT JOIN api_genotypeob
    ON api_genotypeob.biosubject_id = api_biosubject.obid
$limit
"""),
    'genotype_lg_extract': Template("""
SELECT
    subjectname,
    cohort,
    genotypeobserved
FROM api_biosubject
LEFT JOIN api_genotypeob_lg
    ON api_genotypeob_lg.biosubject_id = api_biosubject.obid
$limit
"""),
   'questionnaire_extract': Template("""
SELECT
    subjectname,
    cohort,
    att_key,
    att_value
FROM api_biosubject
LEFT JOIN api_questionnaireob
    ON api_questionnaireob.biosubject_id = api_biosubject.obid
$limit
"""),
}



