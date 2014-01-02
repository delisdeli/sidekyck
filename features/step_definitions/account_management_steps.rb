Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    make_admin = false
    if user[:admin] == "true"
      make_admin = true
    end
    user.delete("admin")
    #user['has_new_message'] = false
    curr_user = User.create!(user)
    curr_user.admin = true if make_admin
    curr_user.save
  end
end

Then /^user "(.*?)" should not exist$/ do |user|
  !User.find_by_name(user)
end
