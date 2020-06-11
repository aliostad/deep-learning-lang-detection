class ManageHoldIssue < BasePage

  wrapper_elements
  frame_element
  validation_elements

  expected_element :manage_hold_name_input

  element(:frm_popup) { |b| b.iframe(:class=>"fancybox-iframe")}

  ######################################################################################################################
  ###                                            Manage Hold Constants                                               ###
  ######################################################################################################################
  HOLD_NAME     = 0
  HOLD_CODE     = 1
  CATEGORY      = 2
  DESCRIPTION   = 3
  OWNING_ORG    = 4
  START_DATE    = 5
  END_DATE      = 6
  AUTHORIZATION = 7
  ACTIONS       = 8

  ######################################################################################################################
  ###                                   Create/Edit Hold Org Popup Constants                                         ###
  ######################################################################################################################
  POPUP_ACTION  = 0
  
  ######################################################################################################################
  ###                                            Manage Hold Section                                                 ###
  ######################################################################################################################
  element(:manage_hold_page) { |b| b.main(id: "KS-HoldIssue-SearchInput-Page")}
  element(:manage_hold_section) { |b| b.frm.section(id: "KS-HoldIssue-CriteriaSection")}

  element(:manage_hold_name_input) { |b| b.manage_hold_section.text_field(id: "manageHoldNameField_control")}
  element(:manage_hold_code_input) { |b| b.manage_hold_section.text_field(id: "manageHoldCodeField_control")}
  element(:manage_hold_category_select) { |b| b.manage_hold_section.select(id: "manageHoldCategoryField_control")}
  element(:manage_hold_descr_input) { |b| b.manage_hold_section.textarea(id: "manageHoldDescrField_control")}

  element(:manage_hold_search_btn) { |b| b.manage_hold_section.button(id: "show_button")}
  action(:manage_hold_search){ |b| b.manage_hold_search_btn.when_present.click}
  element(:add_hold_btn) { |b| b.manage_hold_section.button(id: "addHoldButton")}
  action(:add_hold){ |b| b.add_hold_btn.when_present.click}
  
  ######################################################################################################################
  ###                                      Manage Hold Results Table                                                 ###
  ######################################################################################################################
  element(:manage_hold_results) { |b| b.frm.div( id: "KS-HoldIssue-SearchResults")}
  element(:manage_hold_results_table) { |b| b.manage_hold_results.table}

  def get_hold_code (hold_code)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if ((row.cells[HOLD_CODE].text=~ /#{Regexp.escape(hold_code)}/))
          return row
        end
      end
    end
    return nil
  end

  def get_hold_org (hold_org)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if (row.cells[OWNING_ORG].text=~ /#{Regexp.escape(hold_org)}/)
          return row
        end
      end
    end
    return nil
  end

  def get_hold_auth (hold_auth)
    if manage_hold_results_table.exists?
      manage_hold_results_table.rows[1..-1].each do |row|
        if (row.cells[AUTHORIZATION].text=~ /#{Regexp.escape(hold_auth)}/)
          return row
        end
      end
    end
    return nil
  end

  def edit_hold (hold_name)
    loading.wait_while_present
    wait_until { manage_hold_results_table.row(text: /#{hold_name}/).present? }
    manage_hold_results_table.row(text: /#{hold_name}/).a(id: /manageHoldEditLink_line\d+/).click
  end

end