Given(/^I have entered the main page$/) do
    visit "/"
end

Given(/^I create and login as user "([^"]*)" "([^"]*)"$/) do |name, pass|
    email = name + "@test.abdn.ac.uk"
    User.create(name: name, surname: "testsurname", password: pass, email: email)
    
    visit "/"
    
    fill_in("email", :with => email)
    fill_in("password", :with => pass)
    click_button("login")
end