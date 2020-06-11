Given /^the following manage_searches:$/ do |manage_searches|
  ManageSearch.create!(manage_searches.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) manage_search$/ do |pos|
  visit manage_searches_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Given /^I redirect to the search path$/ do
  visit search_stores_path
end


Given /^the page should contain the result of my search video$/ do
  visit search_stores_path
  Then %{I am on the the search path }
  text="video"
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
   end
 
end

Then /^I should see the following manage_searches:$/ do |expected_manage_searches_table|
  expected_manage_searches_table.diff!(tableish('table tr', 'td,th'))
end
