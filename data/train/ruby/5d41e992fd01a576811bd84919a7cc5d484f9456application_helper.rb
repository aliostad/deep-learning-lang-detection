module ApplicationHelper
  def link_to_method
    @api_method = ApiList.first.api_methods.first
    api_method_desc_path( @api_method)
	end

  def link_to_api_method(method)
    if !@api_method.nil?
      class_name = "#{@api_method.id == method.id ? "selected" : ""} #{method.description.present? ? "" : "yet_to_complete"} method_def"
    end
    link_to method.name, api_method_desc_path(method.id), :class => class_name, :id => "m_#{method.id}"
  end

  def get_first_api_method
    return ApiMethod.first.id
  end
end
