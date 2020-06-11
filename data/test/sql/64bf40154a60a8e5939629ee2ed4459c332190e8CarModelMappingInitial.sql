PRINT 'Populate CarModelMapping table...'
DECLARE @tMask TABLE (Mask NVARCHAR(100), CarBrand NVARCHAR(100), NotMask NVARCHAR(100)) 
;
DECLARE @tCarModelMapping TABLE (ModelMask NVARCHAR(100), ModelNotMask NVARCHAR(100), CarBrandId INT, CarModelId INT)
;
INSERT INTO @tMask
    --Audi
    SELECT N'A4%',N'Audi',N'%Allroad' UNION ALL
    SELECT N'A6%',N'Audi',N'%Allroad' UNION ALL
    SELECT N'A8%',N'Audi',N'' UNION ALL
    --BMW
    SELECT N'1%',N'BMW',N'' UNION ALL
    SELECT N'2%',N'BMW',N'' UNION ALL
    SELECT N'3%',N'BMW',N'%Gran Turismo%' UNION ALL
    SELECT N'4%',N'BMW',N'' UNION ALL
    SELECT N'5%',N'BMW',N'%Gran Turismo%' UNION ALL
    SELECT N'6%',N'BMW',N'' UNION ALL
    SELECT N'7%',N'BMW',N'' UNION ALL
    SELECT N'8%',N'BMW',N'' UNION ALL
    --Citroen
    SELECT N'C5%',N'Citroen',N'' UNION ALL
    --Fiat
    SELECT N'Grande%',N'Fiat',N'' UNION ALL
    --Opel
    SELECT N'Astra%',N'Opel',N'' UNION ALL
    --Iveco
    SELECT N'700%',N'Iveco',N'' UNION ALL
    --Renault
    SELECT N'Scenic%',N'Renault',N'' UNION ALL
    SELECT N'Laguna%',N'Renault',N'' UNION ALL
    SELECT N'Clio%',N'Renault',N'' UNION ALL
    SELECT N'Megane%',N'Renault',N'% Scenic' UNION ALL
    --Kia
    SELECT N'Cee%',N'Kia',N'' UNION ALL
    SELECT N'Pro Cee%',N'Kia',N'' UNION ALL
    --Infinity
    SELECT N'EX%',N'Infiniti',N'' UNION ALL
    SELECT N'FX%',N'Infiniti',N'' UNION ALL
    SELECT N'G%',N'Infiniti',N'' UNION ALL
    SELECT N'JX%',N'Infiniti',N'' UNION ALL
    SELECT N'M%',N'Infiniti',N'' UNION ALL
    SELECT N'Q%',N'Infiniti',N'QX%' UNION ALL
    SELECT N'QX%',N'Infiniti',N'' UNION ALL
    --Lancia
    SELECT N'Y%',N'Lancia',N'' UNION ALL
    --Lexus
    SELECT N'CT%',N'Lexus',N'' UNION ALL
    SELECT N'ES%',N'Lexus',N'' UNION ALL
    SELECT N'GS%',N'Lexus',N'' UNION ALL
    SELECT N'GX%',N'Lexus',N'' UNION ALL
    SELECT N'HS%',N'Lexus',N'' UNION ALL
    SELECT N'IS%',N'Lexus',N'' UNION ALL
    SELECT N'LS%',N'Lexus',N'' UNION ALL
    SELECT N'LX%',N'Lexus',N'' UNION ALL
    SELECT N'NX%',N'Lexus',N'' UNION ALL
    SELECT N'RX%',N'Lexus',N'' UNION ALL
    SELECT N'SC%',N'Lexus',N'' UNION ALL
    --Peugeot
    SELECT N'407%',N'Peugeot',N'' UNION ALL
    --Mazda
    SELECT N'323%',N'Mazda',N'' UNION ALL
    --Mercedes
    SELECT N'190%',N'Mercedes',N'' UNION ALL
    SELECT N'A%',N'Mercedes',N'' UNION ALL
    SELECT N'B%',N'Mercedes',N'' UNION ALL
    SELECT N'C%',N'Mercedes',N'CL%' UNION ALL
    SELECT N'CL%',N'Mercedes',N'CL[a-Z]%' UNION ALL
    SELECT N'CLA%',N'Mercedes',N'' UNION ALL
    SELECT N'CLC%',N'Mercedes',N'' UNION ALL
    SELECT N'CLK%',N'Mercedes',N'' UNION ALL
    SELECT N'CLS%',N'Mercedes',N'' UNION ALL
    SELECT N'E%',N'Mercedes',N'' UNION ALL
    SELECT N'G%',N'Mercedes',N'GL%' UNION ALL
    SELECT N'GL%',N'Mercedes',N'GL[a-Z]%' UNION ALL
    SELECT N'GLA%',N'Mercedes',N'' UNION ALL
    SELECT N'GLC%',N'Mercedes',N'' UNION ALL
    SELECT N'GLE%',N'Mercedes',N'' UNION ALL
    SELECT N'GLK%',N'Mercedes',N'' UNION ALL
    SELECT N'ML%',N'Mercedes',N'' UNION ALL
    SELECT N'R%',N'Mercedes',N'' UNION ALL
    SELECT N'S%',N'Mercedes',N'S[a-Z]%' UNION ALL
    SELECT N'SL%',N'Mercedes',N'SL[a-Z]%' UNION ALL
    SELECT N'SLR%',N'Mercedes',N'' UNION ALL
    SELECT N'SLS%',N'Mercedes',N'' UNION ALL
    SELECT N'SLK%',N'Mercedes',N'' UNION ALL
    SELECT N'V%',N'Mercedes',N'V[a-Z]%' UNION ALL
    SELECT N'T1%',N'Mercedes',N'' UNION ALL
    SELECT N'T2%',N'Mercedes',N'' UNION ALL
    --Nissan
    SELECT N'100%',N'Nissan',N'' UNION ALL
    --SAAB
    SELECT N'9-7%',N'SAAB',N'' UNION ALL
    --Suzuki
    SELECT N'SX%',N'Suzuki',N'' UNION ALL
    SELECT N'XL%',N'Suzuki',N'Grand%' UNION ALL
    --Toyota
    SELECT N'Carina%',N'Toyota',N'' UNION ALL
    --Rover
    SELECT N'100%',N'Rover',N'' UNION ALL
    SELECT N'200%',N'Rover',N'' UNION ALL
    SELECT N'400%',N'Rover',N'' UNION ALL
    SELECT N'600%',N'Rover',N'' UNION ALL
    SELECT N'800%',N'Rover',N'' UNION ALL
    --Volkswagen
    SELECT N'Golf%',N'Volkswagen',N'%Plus%' UNION ALL 
    SELECT N'Passat%',N'Volkswagen',N'%CC%' UNION ALL
    SELECT N'T1%',N'Volkswagen',N'' UNION ALL
    SELECT N'T2%',N'Volkswagen',N'' UNION ALL
    SELECT N'T3%',N'Volkswagen',N'' UNION ALL
    SELECT N'T4%',N'Volkswagen',N'' UNION ALL
    SELECT N'T5%',N'Volkswagen',N'' UNION ALL
    --Volvo
    SELECT N'FH%',N'Volkswagen',N'' UNION ALL
    SELECT N'FM%',N'Volkswagen',N'FMX%' UNION ALL
    SELECT N'FMX%',N'Volkswagen',N'' UNION ALL
    SELECT N'FE%',N'Volkswagen',N'' UNION ALL
    SELECT N'FL%',N'Volkswagen',N'' UNION ALL
    --ГАЗ
    SELECT N'24%',N'ГАЗ',N'' UNION ALL
    SELECT N'27%',N'ГАЗ',N'' UNION ALL
    SELECT N'31%',N'ГАЗ',N'' UNION ALL
    SELECT N'32%',N'ГАЗ',N'' UNION ALL
    SELECT N'33%',N'ГАЗ',N'' 
;
-- Honda Stream
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Strea M',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Honda' AND cm.Name = N'Stream'
;
--BMW E46
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'E46',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'BMW' AND cm.Name = N'3-Series'
;
--BMW E60
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'E60',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'BMW' AND cm.Name = N'5-Series'
;
--BMW E65
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'E65',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'BMW' AND cm.Name = N'7-Series'
;
--BMW 5-Series Gran Turismo
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'%F07%',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'BMW' AND cm.Name = N'5-Series Gran Turismo'
--Citroen Xsara Picasso
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Picasso',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Citroen' AND cm.Name = N'Xsara Picasso'
;
--Dodge Grand Caravan
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Grand-Caravan',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Dodge' AND cm.Name = N'Grand Caravan'
;
--Audi A6 Allroad
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Allroad',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Audi' AND cm.Name = N'A6 Allroad'
;
--Suzuki XL7
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Grand Vitara XL7',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Suzuki' AND cm.Name = N'XL7'
;
--Mercedes T1 -- Cyrillic T symbol
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Т1%',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Mercedes' AND cm.Name = N'T1'
;
--Kia Cee'd -- Cyrillic C symbol
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Сее%',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Kia' AND cm.Name = N'Cee''d'

INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'Сee%',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Kia' AND cm.Name = N'Cee''d'
;
--Hyundai H-1
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'H1',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Hyundai' AND cm.Name = N'H-1'
;
--Iveco 49-10
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'4910',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Iveco' AND cm.Name = N'49-10'
;
-- Mazda CX-5 / CX-7 / CX-9 
INSERT INTO @tCarModelMapping (ModelMask,ModelNotMask,CarBrandId,CarModelId)
SELECT  N'CX5',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Mazda' AND cm.Name = N'CX-5'
UNION ALL
SELECT  N'CX7',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Mazda' AND cm.Name = N'CX-7'
UNION ALL
SELECT  N'CX9',N'',cb.CarBrandId,cm.CarModelId
FROM    dbo.CarModel cm JOIN dbo.CarBrand cb ON cb.CarBrandId = cm.CarBrandId
WHERE   cb.Name = N'Mazda' AND cm.Name = N'CX-9'
;
INSERT INTO @tCarModelMapping
    (
	    ModelMask,
	    ModelNotMask,
        CarBrandId,
	    CarModelId
    )
SELECT  t.Mask, 
        t.NotMask, 
        cb.CarBrandId,
        cm.CarModelId 
FROM dbo.CarBrand AS cb
JOIN dbo.CarModel AS cm ON cm.CarBrandId = cb.CarBrandId
JOIN @tMask t ON t.CarBrand = cb.Name AND cm.Name LIKE t.Mask AND cm.Name NOT LIKE t.NotMask
;
INSERT INTO dbo.CarModelMapping
    (
	    ModelMask,
	    ModelNotMask,
        CarBrandId,
	    CarModelId
    )
SELECT  t.ModelMask,
	    t.ModelNotMask,
        t.CarBrandId,
	    t.CarModelId
FROM @tCarModelMapping t
LEFT JOIN dbo.CarModelMapping AS cmm 
    ON  cmm.ModelMask = t.ModelMask
    AND cmm.ModelNotMask = t.ModelNotMask
    AND cmm.CarBrandId = t.CarBrandId
    AND cmm.CarModelId = t.CarModelId
WHERE cmm.CarModelMappingId IS NULL
;    
