-- Name: raw.nav_purchase_order
-- Created: 2015-06-18 16:27:12
-- Updated: 2015-06-18 16:27:12

CREATE VIEW raw.nav_purchase_order AS
/* 	"nav_test.Outfittery GmbH$Purch_ Rcpt_ Header" h; for active POs */

WITH initial AS
(
SELECT
	h."document type",
	h."no_",
	h."doc_ no_ occurrence",
	h."Document Date",
	h."Order Date",
	h."Buy-from Vendor Name",
	h."Buy-from Vendor No_",
	h."Due Date"
FROM
	/* active purchase order */
	/* document type 0 = quote; 1 = order; 2 = manual invoice; 3 = credit note; 4 = blanket order; 5 = return po */
	"nav_test.Outfittery GmbH$Purchase Header Archive" h
WHERE h."version no_" = 1
),

revised AS
( /* not sure revised header info is needed */
SELECT
/* document no_ = purchase_order_id */
	max_version."document type", max_version."no_", max_version."doc_ no_ occurrence", max_version."version no_", h."Due Date"
	/*, h."Document Date", h."Order Date" */
FROM
	/* active purchase order */
	/* document type 0 = quote; 1 = order; 2 = manual invoice; 3 = credit note; 4 = blanket order; 5 = return po */
	(SELECT
		"document type", "no_", "doc_ no_ occurrence", MAX("version no_") "version no_"
	FROM
		"nav_test.Outfittery GmbH$Purchase Header Archive"
	GROUP BY 1,2,3
	) max_version
	INNER JOIN
	"nav_test.Outfittery GmbH$Purchase Header Archive" h
 		 ON h."document type" = max_version."document type"
		AND h.no_ = max_version.no_
		AND	h."doc_ no_ occurrence" = max_version."doc_ no_ occurrence"
		AND h."version no_" = max_version."version no_"
),

received AS
(
SELECT
/* "order no_" = purchase_order_id */
	h."order no_",
	MIN(h."posting date") date_received_min,
	MAX(h."posting date") date_received_max
FROM
	"nav_test.Outfittery GmbH$Purch_ Rcpt_ Header" h
GROUP BY 1
),

invoiced AS
(
SELECT
/* "order no_" = purchase_order_id */
	h."order no_",
	MIN(h."posting date") date_invoiced_min,
	MAX(h."posting date") date_invoiced_max
FROM
	"nav_test.Outfittery GmbH$Purch_ Inv_ Header" h
GROUP BY 1
),

returned AS
(
SELECT
/* "order no_" = purchase_order_id */
	h."return order no_",
	MIN(h."posting date") date_returned_min,
	MAX(h."posting date") date_returned_max
FROM
	"nav_test.Outfittery GmbH$return shipment Header" h
GROUP BY 1
),

credit AS
(
SELECT
/* "order no_" = purchase_order_id */
	h."return order no_",
	MIN(h."posting date") date_credit_min,
	MAX(h."posting date") date_credit_max
FROM
	"nav_test.Outfittery GmbH$Purch_ cr_ memo Hdr_" h
GROUP BY 1
)




/* MAIN BODY */

SELECT
	initial."no_" AS order_no,
	/* is the following correct: ? */
	initial."Document Date" AS document_date,
	initial."Order Date" AS order_date,
	initial."Buy-from Vendor No_" AS vendor_no,
	initial."Buy-from Vendor Name" AS vendor_name,
	initial."Due Date" AS date_due_initial,
	revised."Due Date" AS date_due_revised,
	received.date_received_min,
	received.date_received_max,	
	invoiced.date_invoiced_min,
	invoiced.date_invoiced_max,
	returned.date_returned_min,
	returned.date_returned_max,	
	credit.date_credit_min,
	credit.date_credit_max
	/*
	date fulfilled
	date cancelled
	date due
	date updated
	*/
FROM
	initial
	LEFT JOIN
	revised
		 ON initial."document type" 		= revised."document type"
		AND initial."no_"					= revised."no_"
		AND initial."doc_ no_ occurrence" 	= revised."doc_ no_ occurrence"
	LEFT JOIN
	received
		 ON initial."no_"					= received."order no_"
	LEFT JOIN
	invoiced
		 ON initial."no_"					= invoiced."order no_"
	LEFT JOIN
	returned
		 ON initial."no_"					= returned."return order no_"
	LEFT JOIN
	credit
		 ON initial."no_"					= credit."return order no_"		
	
	
/* possible good stuff in "nav_test.Outfittery GmbH$Vendor" 
"nav_test.Outfittery TEST$Country_Region" */
		
/*
SELECT
	"document type" , "no_"
FROM
	active purchase order
	"nav_test.Outfittery GmbH$Purchase Header" h

just link the two above to the archive header

*/


