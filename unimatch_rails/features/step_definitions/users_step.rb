When(/^I click register$/) do
  click_link("register");
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |input, value|
  fill_in(input, :with => value)
end

When(/^submit register form$/) do
  click_button("Signup")
end

Then(/^I should see the welcome message for "(.*?)"$/) do |usr|
  expect($session).to have_content("Hello, " + usr)
end

When(/^I log in as "(.*?)" "(.*?)"$/) do |name, pass|
  fill_in("email", :with => name)
  fill_in("password", :with => pass)
  click_button("login")

end

When(/^I click logout$/) do
  click_link("logout")
end

Then(/^I should not see the welcome message for "(.*?)"$/) do |usr|
  page.should have_content("Hello, " + usr)
end

Then(/^I should see the message "(.*?)"$/) do |message|
  page.should have_content(message)
end
