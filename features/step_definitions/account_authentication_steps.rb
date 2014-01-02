Given /the following providers exist/ do |providers_table|
  providers_table.hashes.each do |provider|
    provider = Provider.create!(provider)
  end
end

Given /I am logged in as "(.*)"$/ do |name|
  user_id = User.find_by_name(name).id
  page.driver.browser.manage.add_cookie(:name => "user_id", :value => user_id)
end

Given /^I am signed in with provider "(.*)"$/ do |provider|
  visit "/auth/#{provider.downcase}"
end

And /^there should only be one user "(.*)"$/ do |user|
  User.where(name: user).count == 1
end

Then /^there should be "(.*)" users$/ do |count|
  User.all.count == count.to_i
end
