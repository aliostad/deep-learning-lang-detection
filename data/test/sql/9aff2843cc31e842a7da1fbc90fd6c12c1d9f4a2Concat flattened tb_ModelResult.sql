WITH t(ModelName, Sector, ForYear, ForMonth, Accuracy, Sensitivity, Specificity, Precision) AS (
SELECT ModelName, Sector, ForYear, ForMonth, MAX(Accuracy), MAX(Sensitivity), MAX(Specificity), MAX(Precision)
FROM tb_ModelResult3
GROUP BY ModelName, Sector, ForYear, ForMonth
) 
INSERT tb_ModelResult(ModelName , Sector , ForYear , ForMonth , Accuracy , Sensitivity , Specificity, Precision, Top10SecurityIds)
SELECT t.*, (
SELECT Top10SecurityIds + ',' FROM tb_ModelResult3 a 
WHERE a.ModelName = t.ModelName AND a.Sector = t.Sector AND a.ForYear = t.ForYear AND a.ForMonth = t.ForMonth
FOR XML PATH('')
)
FROM t
ORDER BY t.ModelName, t.ForYear, t.ForMonth, t.Sector
