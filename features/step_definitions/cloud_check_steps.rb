
Then /^I should see a link to "([^\"]*)" with text "([^\"]*)"$/ do |url, text|
  response_body.should have_selector("a[href='#{ path_to(url) || url }']") do |element|
    element.should contain(text)
  end
end
