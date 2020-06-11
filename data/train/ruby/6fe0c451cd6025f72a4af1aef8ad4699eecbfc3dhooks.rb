require 'fileutils'

def clear_api_directory
  if Dir.exists?(Rails.application.config.api_collections_location)
    FileUtils.remove_dir(Rails.application.config.api_collections_location)
  end
end

# delete the api created collections before and after each test which makes them
Before('@api_create_collection, @api_edit_collection, @api_add_item, @api_update_item, @api_delete_item, @api_add_document, @api_delete_document') do
  Rails.application.config.api_collections_location = "#{Rails.root}/test/api/collections"
  clear_api_directory
end

After('@api_create_collection, @api_edit_collection, @api_add_item, @api_update_item, @api_delete_item, @api_add_document, @api_delete_document') do
  clear_api_directory
end

# delete the ingest interface created collections before and after each test which makes them
Before('@create_collection') do
  Rails.application.config.api_collections_location = "#{Rails.root}/test/api/collections"
  clear_api_directory
end

After('@create_collection') do
  clear_api_directory
end