Given /I am logged in as "(.*)" with password "(.*)"$/ do |name, password|
  user_email = User.find_by_name(name).email
  visit path_to("the signin page")
  fill_in("session[email]", :with => user_email)
  fill_in("session[password]", :with => password)
  click_button("Sign in")
end