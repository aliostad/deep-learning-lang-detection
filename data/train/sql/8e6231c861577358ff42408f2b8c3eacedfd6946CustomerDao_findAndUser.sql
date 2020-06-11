SELECT
	CUSTOMER.CUSTOMER_ID AS CUSTOMER_ID,
	CUSTOMER.CUSTOMER_NAME AS CUSTOMER_NAME
FROM
	CUSTOMER,
	BURI_PATH_DATA_USER
/*BEGIN*/
WHERE
	/*IF dto.customerID != null*/ CUSTOMER_ID = /*dto.customerID*/0/*END*/
	/*IF dto.customerID_not != null*/AND CUSTOMER_ID != /*dto.customerID_not*/0/*END*/
	/*IF dto.customerID_large != null*/AND  /*dto.customerID_large*/0 < CUSTOMER_ID/*END*/
	/*IF dto.customerID_moreLarge != null*/AND  /*dto.customerID_moreLarge*/0 <= CUSTOMER_ID/*END*/
	/*IF dto.customerID_from != null*/AND  /*dto.customerID_from*/0 <= CUSTOMER_ID/*END*/
	/*IF dto.customerID_to != null*/AND CUSTOMER_ID <= /*dto.customerID_to*/0/*END*/
	/*IF dto.customerID_moreSmall != null*/AND CUSTOMER_ID <= /*dto.customerID_moreSmall*/0/*END*/
	/*IF dto.customerID_small != null*/AND CUSTOMER_ID < /*dto.customerID_small*/0/*END*/
	/*IF dto.customerID_isNull != null*/AND customerID is null /*END*/
	/*IF dto.customerID_isNotNull != null*/AND CUSTOMER_ID is not null/*END*/
	/*IF dto.customerID_in != null*/AND CUSTOMER_ID in /*dto.customerID_in*/(0)/*END*/

	/*IF dto.customerName_matchFull != null*/AND CUSTOMER_NAME Like /*dto.customerName_matchFull*/'%TestData%'/*END*/
	/*IF dto.customerName_matchFront != null*/AND CUSTOMER_NAME Like /*dto.customerName_matchFront*/'TestData%'/*END*/
	/*IF dto.customerName_matchBack != null*/AND CUSTOMER_NAME Like /*dto.customerName_matchBack*/'%TestData'/*END*/
	/*IF dto.customerName != null*/AND CUSTOMER_NAME = /*dto.customerName*/'TestData'/*END*/
	/*IF dto.customerName_not != null*/AND CUSTOMER_NAME != /*dto.customerName_not*/'TestData'/*END*/
	/*IF dto.customerName_large != null*/AND  /*dto.customerName_large*/'TestData' < CUSTOMER_NAME/*END*/
	/*IF dto.customerName_moreLarge != null*/AND  /*dto.customerName_moreLarge*/'TestData' <= CUSTOMER_NAME/*END*/
	/*IF dto.customerName_from != null*/AND  /*dto.customerName_from*/'TestData' <= CUSTOMER_NAME/*END*/
	/*IF dto.customerName_to != null*/AND CUSTOMER_NAME <= /*dto.customerName_to*/'TestData'/*END*/
	/*IF dto.customerName_moreSmall != null*/AND CUSTOMER_NAME <= /*dto.customerName_moreSmall*/'TestData'/*END*/
	/*IF dto.customerName_small != null*/AND CUSTOMER_NAME < /*dto.customerName_small*/'TestData'/*END*/
	/*IF dto.customerName_isNull != null*/AND CUSTOMER_NAME is null /*END*/
	/*IF dto.customerName_isNotNull != null*/AND CUSTOMER_NAME is not null/*END*/
	/*IF dto.customerName_in != null*/AND CUSTOMER_NAME in /*dto.customerName_in*/('TestData')/*END*/

	AND CUSTOMER.CUSTOMER_ID = BURI_PATH_DATA_USER.PKEY_NUM
	/*IF paths != null*/AND BURI_PATH_DATA_USER.PATH_NAME IN/*paths*/('buri.path.names')/*END*/
	/*IF userIds != null*/AND BURI_PATH_DATA_USER.BURI_USER_ID in /*userIds*/(1)/*END*/
/*END*/
/*$dto.orderList*/
