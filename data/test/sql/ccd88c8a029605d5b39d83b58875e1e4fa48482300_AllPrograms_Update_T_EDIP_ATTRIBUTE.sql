/** ADD AreaRowSize columns **/
IF(
	NOT EXISTS (
		SELECT *
		FROM syscolumns
		WHERE syscolumns.id = (	SELECT sysobjects.id
						FROM sysobjects
						WHERE name = 'T_EDIP_ATTRIBUTE'
				      )
		 AND syscolumns.name = 'AreaRowsSize'
	)
)
BEGIN
	--Alter The table
	ALTER TABLE T_EDIP_ATTRIBUTE
	ADD AreaRowsSize int;
END
GO
UPDATE T_EDIP_ATTRIBUTE
SET AreaRowsSize=2 WHERE editType = 'area';


/** Set NULL ReadOnly attribute to 0 **/
UPDATE T_EDIP_ATTRIBUTE
SET ReadOnly = 0 
WHERE ReadOnly IS NULL
