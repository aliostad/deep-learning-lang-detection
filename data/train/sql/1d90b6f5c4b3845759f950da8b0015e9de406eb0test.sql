

SELECT C.id, ROUND((R.carrier_rate+1700*R.carrier_extra_rate),4) AS charge, ROUND(((R.carrier_rate + 1700 *R.carrier_extra_rate) * (100 + CF.percentage) / 100 + CF.fixed_value),4) AS charge_factor, Z.*, R.* 
FROM ps_zone_info Z, ps_carrier_info C, ps_parcel_rate R, ps_invoice_info_nav NAV, ps_cost_factor CF WHERE 1 AND NAV.invoiceNo='SI1450869' AND C.id=4 AND C.id=Z.carrier_id AND R.zone_abbreviation=Z.zone_abbreviation AND Z.postcode=NAV.postcode AND 1700 BETWEEN R.weight_min AND R.weight_max AND CF.carrier_id=C.id AND R.carrier_id=4 GROUP BY C.carrier_name ORDER BY C.id ASC

