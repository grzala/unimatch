When(/^I click register$/) do
  find('#register').click
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |input, value|
  fill_in(input, :with => value)
end

When(/^submit register form$/) do
  find('#register').click
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
  first("#logout").click
end

When(/^I click login/) do
  first("#login").click
end

Then(/^I should see the message "(.*?)"$/) do |message|
  page.should have_content(message)
end

Then(/^I should not see the message "(.*?)"$/) do |message|
  page.should_not have_content(message)
end

Then(/^I should see the logout link$/) do 
  #more than one logout link (because mobile)
  logouts = page.all('a#logout')
  
  #at least one visible
  visible = false
  logouts.each do |logout|
    if logout.visible?
      visible = true
      break
    end
  end
  expect(visible).to be
end
