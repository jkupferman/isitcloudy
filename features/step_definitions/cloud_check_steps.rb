When /^I visit "([^\"]*)"$/ do |arg1|
  visit arg1
end

Then /^I should see a link to "([^\"]*)" with text "([^\"]*)"$/ do |url, text|
  check_link url,text
end

Then /^I should see a link to "([^\"]*)"$/ do |url|
  check_link url
end


Then /^I should see a form with a "([^\"]*)" field$/ do |type|
  response_body.should have_selector("form") do |element|
    element.should have_selector("input[type='#{type}']")
  end
end

Then /^I should see a form with a "([^\"]*)" element$/ do |type|
  response_body.should have_selector("form") do |element|
    element.should have_selector(type)
  end
end

Then /^I should see a "([^\"]*)" button$/ do |name|
  response_body.should have_selector("form") do |element|
    element.should have_selector("input", :type => 'submit', :value => name) 
  end
end

# Checks if the url is actually a specified path so that both
# can use the same steps.
def path_url url
  begin
    path_to(url)
  rescue RuntimeError
    url
  end
end

def check_link url,text=nil
  response_body.should have_selector("a[href='#{path_url(url)}']") do |element|
    element.should contain(text) unless text.nil?
  end
end
