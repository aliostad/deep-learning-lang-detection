select
		Customer.customerID as customerID
	,Customer.customerName as customerName
from
	Customer
	,BuriPathDataUser
/*BEGIN*/
where
	
	/*IF dto.customerID != null*/ customerID = /*dto.customerID*/0/*END*/
	/*IF dto.customerID_not != null*/AND customerID != /*dto.customerID_not*/0/*END*/
	/*IF dto.customerID_large != null*/AND  /*dto.customerID_large*/0 < customerID/*END*/
	/*IF dto.customerID_moreLarge != null*/AND  /*dto.customerID_moreLarge*/0 <= customerID/*END*/
	/*IF dto.customerID_from != null*/AND  /*dto.customerID_from*/0 <= customerID/*END*/
	/*IF dto.customerID_to != null*/AND customerID <= /*dto.customerID_to*/0/*END*/
	/*IF dto.customerID_moreSmall != null*/AND customerID <= /*dto.customerID_moreSmall*/0/*END*/
	/*IF dto.customerID_small != null*/AND customerID < /*dto.customerID_small*/0/*END*/
	/*IF dto.customerID_isNull != null*/AND customerID is null /*END*/
	/*IF dto.customerID_isNotNull != null*/AND customerID is not null/*END*/
	/*IF dto.customerID_in != null*/AND customerID in /*dto.customerID_in*/(0)/*END*/

	
	/*IF dto.customerName_matchFull != null*/AND customerName Like /*dto.customerName_matchFull*/'%TestData%'/*END*/
	/*IF dto.customerName_matchFront != null*/AND customerName Like /*dto.customerName_matchFront*/'TestData%'/*END*/
	/*IF dto.customerName_matchBack != null*/AND customerName Like /*dto.customerName_matchBack*/'%TestData'/*END*/
	/*IF dto.customerName != null*/AND customerName = /*dto.customerName*/'TestData'/*END*/
	/*IF dto.customerName_not != null*/AND customerName != /*dto.customerName_not*/'TestData'/*END*/
	/*IF dto.customerName_large != null*/AND  /*dto.customerName_large*/'TestData' < customerName/*END*/
	/*IF dto.customerName_moreLarge != null*/AND  /*dto.customerName_moreLarge*/'TestData' <= customerName/*END*/
	/*IF dto.customerName_from != null*/AND  /*dto.customerName_from*/'TestData' <= customerName/*END*/
	/*IF dto.customerName_to != null*/AND customerName <= /*dto.customerName_to*/'TestData'/*END*/
	/*IF dto.customerName_moreSmall != null*/AND customerName <= /*dto.customerName_moreSmall*/'TestData'/*END*/
	/*IF dto.customerName_small != null*/AND customerName < /*dto.customerName_small*/'TestData'/*END*/
	/*IF dto.customerName_isNull != null*/AND customerName is null /*END*/
	/*IF dto.customerName_isNotNull != null*/AND customerName is not null/*END*/
	/*IF dto.customerName_in != null*/AND customerName in /*dto.customerName_in*/('TestData')/*END*/

	AND Customer.customerID = BuriPathDataUser.pkeyNum
	/*IF paths != null*/AND BuriPathDataUser.PathName in /*paths*/('buri.path.names')/*END*/
	/*IF userIDs != null*/AND BuriPathDataUser.BuriUserID in /*userIDs*/(1)/*END*/
	
/*END*/
/*$dto.orderList*/
