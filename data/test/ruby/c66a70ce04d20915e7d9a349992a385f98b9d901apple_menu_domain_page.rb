# encoding: utf-8

class AppleMenuDomainPage
  include PageObject
  
  PageObject.javascript_framework = :jquery


  #link :manage_visibility_domain, :text => 'Manage item visibility per domain'
  #link :manage_visibility_domain, :index => 6
  #element :manage_visibility_domain, :fieldset, :id => 'edit-manage'
  #element :manage_visibility_domain, :fieldset, :css => 'a:link {color: #2FA6E5;}'
  #hidden_field :manage_visibility_domain, :name => 'form_id'
  
  #span :manage_visibility_domain, :class => 'fieldset-title'

  def manage_visibility
   # wait_for_ajax
   # sleep(5)
   # manage_visibility_domain
   self.execute_script("$('#edit-manage').trigger('click');")
            
    #self.manage_visibility_domain.inspect
    #manage_visibility_domain
    #navigate_to BASE_URL + term_initial
    #edit_term
  end



  #def manage_visibility_domain_values()
  #  manage_visibility_domain = {}
  #    manage_visibility_domain.span_elements.each do |span|
  #
  #    other_roles_element.span_elements.each do |span|
  #        other_roles[span.label_element.text] = span.checkbox_element.checked?
  #    end
  #    return other_roles
  #end

end
