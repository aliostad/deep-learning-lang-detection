module Manage

  module FormHelper
    include SimpleForm::ActionViewExtensions::FormHelper

    OPTIONS = {
      wrapper: :foundation,
      class: 'custom'
    }

    def manage_form_for(record, options={}, &block)
      simple_form_for(record, options.merge(Manage::FormHelper::OPTIONS), &block)
    end

    def manage_fields_for(record_name, record_object = nil, options = {}, &block)
      simple_fields_for(record_name, record_object = nil, options.merge(Manage::FormHelper::OPTIONS), &block)
    end

  end

end
