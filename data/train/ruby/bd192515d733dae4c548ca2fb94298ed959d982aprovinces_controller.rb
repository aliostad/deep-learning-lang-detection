class ProvincesController < ApplicationController

	layout 'layout_back'

	# Manage
	
		# View/Partial view
		def manage
			# Author
			authorize! :manage, Province

			# Get params
			page      =   (params[:page] || 1).to_i
			per       = (params[:per] || 30).to_i

			# Get provinces
			provinces = Province.all

			# Render result
			respond_to do |f|
				f.html {
					render 'manage',
						locals: {
							provinces:    provinces
						}
				}
				f.json {
					render json: {
						status: 0,
						result: render_to_string(
							partial: 'manage',
							formats: :html,
							locals: {
								provinces: provinces
							}
						)
					}
				}
			end
		end
	
	# / Manage

	# Change order
		
		# Handle
		# params: id, order
		def update_order
			# Author
			authorize! :manage, Province

			# Get province
			province = Province.find params[:id]

			result = province.set_order params[:order]

			render json: result
		end
	
	# / Change order
	
end
