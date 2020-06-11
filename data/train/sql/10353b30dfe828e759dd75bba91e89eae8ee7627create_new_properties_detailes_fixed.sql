drop table new_properties_detailes_fixed;

create table new_properties_detailes_fixed as
(
select * from 
new_properties_dup_id
left join property_details
using (dup_id)
);

update new_properties_detailes_fixed
	set new_legal_type = legal_type
	where new_legal_type is null and legal_type is not null;

update new_properties_detailes_fixed
	set new_strata_fee = strata_fee
	where new_strata_fee is null and strata_fee is not null;

update new_properties_detailes_fixed
	set new_property_tax = property_tax
	where new_property_tax is null and property_tax is not null;

update new_properties_detailes_fixed
	set new_year_built = year_built
	where new_year_built is null and year_built is not null;

update new_properties_detailes_fixed
	set new_floor_area = floor_area
	where new_floor_area is null and floor_area is not null;

update new_properties_detailes_fixed
	set new_bedroom = bedroom
	where new_bedroom is null and bedroom is not null;

update new_properties_detailes_fixed
	set new_bathroom = bathroom
	where new_bathroom is null and bathroom is not null;

update new_properties_detailes_fixed
	set new_assessed_type = assessed_type
	where new_assessed_type is null and assessed_type is not null;

update new_properties_detailes_fixed
	set new_lot_size = lot_size
	where new_lot_size is null and lot_size is not null;

update new_properties_detailes_fixed
	set new_den = den
	where new_den is null and den is not null;

update new_properties_detailes_fixed
	set new_normalized_type = normalized_type
	where new_normalized_type is null and normalized_type is not null;

update new_properties_detailes_fixed
	set new_lot_frontage = lot_frontage
	where new_lot_frontage is null and lot_frontage is not null;

update new_properties_detailes_fixed
	set new_lot_depth = lot_depth
	where new_lot_depth is null and lot_depth is not null;