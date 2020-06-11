-- View: Object_Contract_InvNumber_Key_View

CREATE OR REPLACE VIEW Object_Contract_InvNumber_Key_View
AS
  SELECT Object_Contract_ContractKey_View.ContractKeyId
       , Object_Contract_ContractKey_View.ContractId
       , Object_Contract_ContractKey_View.ContractId_Key

       , Object_Contract_InvNumber_View.ContractCode
       , Object_Contract_InvNumber_View.InvNumber
       , Object_Contract_InvNumber_View.InfoMoneyId
       , Object_Contract_InvNumber_View.ContractTagId
       , Object_Contract_InvNumber_View.ContractTagCode
       , Object_Contract_InvNumber_View.ContractTagName
       , Object_Contract_InvNumber_View.ContractStateKindId
       , Object_Contract_InvNumber_View.ContractStateKindCode
       , Object_Contract_InvNumber_View.ContractStateKindName
       , Object_Contract_InvNumber_View.isErased
  FROM Object_Contract_ContractKey_View
       LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = Object_Contract_ContractKey_View.ContractId_Key
  ;

ALTER TABLE Object_Contract_InvNumber_Key_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 26.04.14                                        *
*/

-- òåñò
-- SELECT * FROM Object_Contract_InvNumber_Key_View