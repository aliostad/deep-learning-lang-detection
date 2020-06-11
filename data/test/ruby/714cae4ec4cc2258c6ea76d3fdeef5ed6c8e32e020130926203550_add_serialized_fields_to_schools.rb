class AddSerializedFieldsToSchools < ActiveRecord::Migration
  def change
  	add_column :schools, :api_basic_info, :text     
		add_column :schools, :api_awards, :text
		add_column :schools, :api_calendar, :text
		add_column :schools, :api_description, :text
		add_column :schools, :api_extra_curricular, :text
		add_column :schools, :api_facilities, :text
		add_column :schools, :api_grades, :text
		add_column :schools, :api_hours, :text
		add_column :schools, :api_languages, :text
		add_column :schools, :api_partners, :text
		add_column :schools, :api_photos, :text
  end
end
