MERGE INTO [BegemotProductSet] old
   USING [BegemotProductSet] new 
      ON old.[Article] = new.[Article]
         AND old.CopyInfo is null
		 and new.CopyInfo = 'import' 
		 and (old.[Count] <> new.[Count]
		 or old.[RetailPrice] <> new.[RetailPrice]
		 or old.[WholeSalePrice]<> new.[WholeSalePrice]
		 or old.[Active] = 0)

WHEN MATCHED THEN
   UPDATE 
      SET
		old.CopyInfo = 'mod',
		old.[Count] = new.[Count],
		old.[RetailPrice] = new.[RetailPrice],
		old.[WholeSalePrice]= new.[WholeSalePrice],
		old.[Active] = 1;
		