-- View: Object_Goods_View

-- DROP VIEW IF EXISTS Object_Goods_View;

CREATE OR REPLACE VIEW Object_Goods_View AS
         SELECT 
             Object_Goods.Id           AS GoodsId
           , Object_Goods.ObjectCode   AS GoodsCode
           , Object_Goods.ValueData    AS GoodsName
          
           , Object_InfoMoney_View.InfoMoneyGroupId
           , Object_InfoMoney_View.InfoMoneyDestinationId
           , Object_InfoMoney_View.InfoMoneyId


       FROM Object AS Object_Goods

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                   
       WHERE Object_Goods.DescId = zc_Object_Goods();


ALTER TABLE Object_Goods_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 15.10.13                                        *
*/

-- òåñò
-- SELECT * FROM Object_Goods_View
