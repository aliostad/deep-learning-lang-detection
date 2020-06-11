SELECT
	CUSTOMER.CUSTOMER_ID AS CUSTOMER_ID,
	CUSTOMER.CUSTOMER_NAME AS CUSTOMER_NAME
FROM
	CUSTOMER,
	BURI_PATH_DATA
/*BEGIN*/
WHERE
	/*IF dto.customerId != null*/ CUSTOMER_ID = /*dto.customerId*/0/*END*/
	/*IF dto.customerId_not != null*/AND CUSTOMER_ID != /*dto.customerId_not*/0/*END*/
	/*IF dto.customerId_large != null*/AND  /*dto.customerId_large*/0 < CUSTOMER_ID/*END*/
	/*IF dto.customerId_moreLarge != null*/AND  /*dto.customerId_moreLarge*/0 <= CUSTOMER_ID/*END*/
	/*IF dto.customerId_from != null*/AND  /*dto.customerId_from*/0 <= customerId/*END*/
	/*IF dto.customerId_to != null*/AND CUSTOMER_ID <= /*dto.customerId_to*/0/*END*/
	/*IF dto.customerId_moreSmall != null*/AND CUSTOMER_ID <= /*dto.customerId_moreSmall*/0/*END*/
	/*IF dto.customerId_small != null*/AND CUSTOMER_ID < /*dto.customerId_small*/0/*END*/
	/*IF dto.customerId_isNull != null*/AND CUSTOMER_ID IS NULL/*END*/
	/*IF dto.customerId_isNotNull != null*/AND CUSTOMER_ID IS NOT NULL/*END*/
	/*IF dto.customerId_in != null*/AND CUSTOMER_ID IN/*dto.customerId_in*/(0)/*END*/

	/*IF dto.customerName_matchFull != null*/AND CUSTOMER_NAME LIKE/*dto.customerName_matchFull*/'%TestData%'/*END*/
	/*IF dto.customerName_matchFront != null*/AND CUSTOMER_NAME LIKE/*dto.customerName_matchFront*/'TestData%'/*END*/
	/*IF dto.customerName_matchBack != null*/AND CUSTOMER_NAME LIKE/*dto.customerName_matchBack*/'%TestData'/*END*/
	/*IF dto.customerName != null*/AND CUSTOMER_NAME = /*dto.customerName*/'TestData'/*END*/
	/*IF dto.customerName_not != null*/AND CUSTOMER_NAME != /*dto.customerName_not*/'TestData'/*END*/
	/*IF dto.customerName_large != null*/AND  /*dto.customerName_large*/'TestData' < CUSTOMER_NAME/*END*/
	/*IF dto.customerName_moreLarge != null*/AND  /*dto.customerName_moreLarge*/'TestData' <= CUSTOMER_NAME/*END*/
	/*IF dto.customerName_from != null*/AND  /*dto.customerName_from*/'TestData' <= CUSTOMER_NAME/*END*/
	/*IF dto.customerName_to != null*/AND CUSTOMER_NAME <= /*dto.customerName_to*/'TestData'/*END*/
	/*IF dto.customerName_moreSmall != null*/AND CUSTOMER_NAME <= /*dto.customerName_moreSmall*/'TestData'/*END*/
	/*IF dto.customerName_small != null*/AND CUSTOMER_NAME < /*dto.customerName_small*/'TestData'/*END*/
	/*IF dto.customerName_isNull != null*/AND CUSTOMER_NAME IS NULL/*END*/
	/*IF dto.customerName_isNotNull != null*/AND CUSTOMER_NAME IS NOT NULL/*END*/
	/*IF dto.customerName_in != null*/AND CUSTOMER_NAME IN/*dto.customerName_in*/('TestData')/*END*/

	AND CUSTOMER.CUSTOMER_ID = BURI_PATH_DATA.PKEY_NUM
	/*IF paths != null*/AND BURI_PATH_DATA.PATH_NAME IN/*paths*/('buri.path.names')/*END*/	
/*END*/
/*$dto.orderList*/
