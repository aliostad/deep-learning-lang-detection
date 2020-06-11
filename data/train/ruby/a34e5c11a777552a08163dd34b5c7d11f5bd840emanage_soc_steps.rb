Given /^the SOC is valid for "(.*?)" for the term "(\d+)"$/ do |currentState,term|
  @manageSoc = make ManageSoc, :term_code=>term
  @manageSoc.search
  @manageSoc.check_state_change_button_exists currentState
end

When /^I "(.*?)" the SOC and press "(.*?)" on the confirm dialog$/ do |newState,confirmStateChange|
  @manageSoc.change_action newState, confirmStateChange
end

Then /^I verify that "(.*?)" button is enabled for next action$/ do |nextState|
  @manageSoc.check_state_change_button_exists nextState
end