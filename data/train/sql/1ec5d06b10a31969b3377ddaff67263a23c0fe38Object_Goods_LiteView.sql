-- View: Object_Goods_LiteView

DROP VIEW IF EXISTS Object_Goods_LiteView;

CREATE OR REPLACE VIEW Object_Goods_LiteView AS
    SELECT
        Id
       ,GoodsName
       ,GoodsCodeInt
       ,NDSKindId
       ,NDSKindName
       ,NDS
    FROM
        Object_Goods_View
    WHERE
        ObjectId in (Select id from Object Where DescId = zc_Object_Retail());--= lpGet_DefaultValue('zc_Object_Retail', Null::Integer)::Integer;
ALTER TABLE Object_Goods_LiteView  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 03.09.15                                                          *
 26.05.16                                                          *
 
*/

-- тест
-- SELECT * FROM Object_Goods_LiteView
