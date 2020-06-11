module Admin::EventsHelper
	def registration_text_form_column(record, input_name)
		fckeditor_textarea( :record, :registration_text, :toolbarSet => 'Simple', :name=> input_name, :width => "800px", :height => "400px" )
	end
	
	def description_form_column(record, input_name)
		text_area( :record, :description, :rows => "6", :cols => "50" )
	end



	def registration_text_column(record)
		sanitize(record.registration_text)
	end
	
	def manage_type_column(record)
		manage_type = record.manage_type
        if manage_type.nil? or manage_type == 0
            "N/A"
        elsif manage_type == Event::BASIC or manage_type == Event::RD
            Event::MGT_TYPE[manage_type]
        else
            "Nazim"
        end
	end

  def manage_type_form_column(record, input_name)
		select(:record, "manage_type", {"None" => 0, "Basic" => 1, "RD" => 2}, {})
	end
	
	#def distance_unit_form_column(record, input_name)
	#	fckeditor_textarea( :record, :registration_text, :toolbarSet => 'Simple', :name=> input_name, :width => "800px", :height => "400px" )
	#end
	
	#def distance_unit_column(record)
	#	Race::DISTANCE_UNITS[record.distance_unit]
	#end
end
