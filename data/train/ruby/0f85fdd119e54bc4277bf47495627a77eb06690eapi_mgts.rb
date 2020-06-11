ActiveAdmin.register ApiMgt do

	config.filters = false

	index do
		column(:id)
		column(:affiliate_id)
		column(:clicks) { |api_mgt| api_mgt.nb_clicks }
		column(:airport) { |api_mgt| ApiMgt::AIRPORT[api_mgt.airport_id] }
		column(:pickup) { |api_mgt| "#{api_mgt.pickup_date} #{api_mgt.pickup_time}" }
		column(:dropoff) { |api_mgt| "#{api_mgt.dropoff_date} #{api_mgt.dropoff_time}" }
		column(:nb_days)
		column(:cars) { |api_mgt| api_mgt.nb_travels }
		column(:min_price) { |api_mgt| api_mgt.min_price/100 }
		column(:max_price) { |api_mgt| api_mgt.max_price/100 }
		column(:created_at)
		# column(:anticipation) { |api_mgt| (api_mgt.pickup_date - api_mgt.created_at)/1.day }
		column(:updated_at)
		default_actions
	end

end
