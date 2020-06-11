drop table new_properties_final;

create table new_properties_final as (
	select 
		np.id as id,
		regexp_replace(regexp_replace(regexp_replace(lower(concat(np.new_unit_number, '-', np.new_street_number, '-', np.new_street_direction, '-', np.new_street_name, '-', c.name, '-', uid)), ' ', '-', 'g'), '--', '-', 'g'), '--', '-', 'g') as slug,
		regexp_replace(regexp_replace(regexp_replace(lower(concat(np.new_street_number, '-', np.new_street_direction, '-', np.new_street_name, '-', c.name)), ' ', '-', 'g'), '--', '-', 'g'), '--', '-', 'g') as parcel_slug,
		regexp_replace(regexp_replace(regexp_replace(regexp_replace(lower(concat(c.name, '/', np.new_street_direction, '-', np.new_street_name)), ' ', '-', 'g'), '--', '-', 'g'), '--', '-', 'g'), '/-', '/') as street_slug,
		lower(concat(c.name, '/', np.postal_code)) as postal_code_slug,
		np.new_street_number as street_number,
		np.new_street_name as street_name,
		np.new_street_direction as street_direction,
		np.new_unit_number as unit_number,
		np.city_id as city_id,
		np.postal_code as postal_code,
		regexp_replace(concat(np.new_unit_number, '-', np.new_street_number, ' ', np.new_street_name, ', ', c.name, ', ', p.code, ' ', postal_code, ', ', co.name), '  ', ' ', 'g') as formatted_address,
		np.latitude as latitude,
		np.longitude as longitude,
		np.geocode_source as geocode_source,
		np.geocode_type as geocode_type,
		np.geocode_status as geocode_status,
		np.new_legal_type as legal_type,
		np.new_strata_fee as strata_fee,
		np.new_property_tax as property_tax,
		np.new_year_built as year_built,
		np.new_floor_area as floor_area,
		np.new_bedroom as bedroom,
		np.new_bathroom as bathroom,
		np.new_assessed_type as assessed_type,
		np.new_lot_size as lot_size,
		np.created_at as created_at,
		np.updated_at as updated_at,
		np.new_den as den,
		np.new_normalized_type as normalized_type,
		np.parcel as parcel,
		np.published as published,
		np.new_lot_frontage as lot_frontage,
		np.new_lot_depth as lot_depth,
		np.use_point_for_street_view as use_point_for_street_view,
		np.matchable as matchable,
		np.uid as uid,
		np.dup_id as dup_id
	from new_properties_dups_deleted np, cities c, provinces p, countries co
	where np.city_id = c.id and 
		c.province_id = p.id and 
		p.country_id = co.id
	);

update new_properties_final
	set slug = substring(slug from 2)
	where slug ~~ '-%' or slug ~~ ' %';
update new_properties_final
	set parcel_slug = substring(parcel_slug from 2)
	where parcel_slug ~~ '-%' or parcel_slug ~~ ' %';
update new_properties_final
	set street_slug = substring(street_slug from 2)
	where street_slug ~~ '-%' or street_slug ~~ ' %';
update new_properties_final
	set postal_code_slug = substring(postal_code_slug from 2)
	where postal_code_slug ~~ '-%' or postal_code_slug ~~ ' %';
update new_properties_final
	set formatted_address = substring(formatted_address from 2)
	where formatted_address ~~ '-%' or formatted_address ~~ ' %';
	