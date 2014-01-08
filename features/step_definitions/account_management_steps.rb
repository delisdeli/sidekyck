Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    make_admin = false
    if user[:admin] == "true"
      make_admin = true
    end
    user.delete("admin")
    curr_user = User.create!(user)
    curr_user.admin = true if make_admin
    curr_user.save
  end
end

Then /^user "(.*?)" should not exist$/ do |user|
  !User.find_by_name(user)
end

And /^"(.*?)" is an admin user$/ do |user|
  user = User.find_by_name(user)
  user.admin = true
  user.save
end
