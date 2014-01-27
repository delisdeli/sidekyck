Then(/^"(.*?)" has a balance of "(.*?)"$/) do |user_name, balance_value|
  user = User.find_by_name(user_name)
  user.balance = balance_value.to_i
  user.save!
end

Then(/^"(.*?)" should have a balance of "(.*?)"$/) do |user_name, balance_value|
  user = User.find_by_name(user_name)
  user.balance == balance_value.to_i
end