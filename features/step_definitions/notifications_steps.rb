Given /the following notifications exist/ do |notifications_table|
  notifications_table.hashes.each do |notification|
    user = User.find_by_id(notification[:user_id])
    notification.delete("user_id")
    curr_user = user.notifications.build(notification)
    curr_user.save
  end
end

Given /^I create "(.*?)" new notifications for "(.*?)"$/ do |number, user|
  user = User.find_by_name(user)
  number.to_i.times do 
    user.notifications.build(body: "just another notification", seen: false)
    user.save(validate: false)
  end
end

And /^no notification should have user id "(.*)"$/ do |user_id|
  assert Notification.where(user_id: user_id).empty?
end

Given /^notification "(.*)" should be seen$/ do |notification_id|
  Notification.find(notification_id).seen?
end

Given /^notification "(.*)" should not be seen$/ do |notification_id|
  !Notification.find(notification_id).seen?
end
