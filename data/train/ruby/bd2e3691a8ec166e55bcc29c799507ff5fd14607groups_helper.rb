module GroupsHelper

	def polititians_list(group)
		if params[:institution_id].present?
			group.polititians.filter_by_institution_id(params[:institution_id])
		else
			group.polititians
		end
	end

	def calculate_group_count(group)
		polititians_list(group).count
	end

	def calculate_group_education(group)
		total = calculate_group_count(group)
		educated = group.polititians.reduce(0){|memo, polititian| if polititian.educations.empty? then memo; else memo+1; end }
		percentage = (educated.to_f / total.to_f) * 100
		percentage.nan? ? 0 : percentage
	end

	def calculate_group_job(group)
		total = calculate_group_count(group)
		experienced = group.polititians.reduce(0){|memo, polititian| if polititian.jobs.empty? then memo; else memo+1; end }
		percentage = (experienced.to_f / total.to_f) * 100
		percentage.nan? ? 0 : percentage
	end
end

