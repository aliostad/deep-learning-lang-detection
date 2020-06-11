module ApiEnumerationsHelper

  def render_api_enumeration(api, enumeration)
    api.enumeration do
      api.id(enumeration.id)
      api.name(enumeration.name)
      api.position(enumeration.position)
      api.is_default(enumeration.is_default)
      api.type(enumeration.type)
      api.active(enumeration.active)
      api.project_id(enumeration.project_id)
      api.parent_id(enumeration.parent_id)
      api.easy_color_scheme(enumeration.easy_color_scheme)
      api.internal_name(enumeration.internal_name)
      api.easy_external_id(enumeration.easy_external_id)
    end
  end

end
