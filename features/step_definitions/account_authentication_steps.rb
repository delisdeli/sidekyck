Given /I am logged in as "(.*)"$/ do |name|
  user = User.find_by_name(name)
  self.current_user = user
end

Given /^I am signed in with provider "(.*)"$/ do |provider|
  visit "/auth/#{provider.downcase}"
end

And /^there should only be one user "(.*)"$/ do |user|
  User.where(name: user).count == 1
end