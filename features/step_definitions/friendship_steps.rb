Given /the following friendships exist/ do |friendships_table|
  friendships_table.hashes.each do |friendship|
    Friendship.create(friendship)
  end
end

And /^no friendship should have friend or user id "(.*)"$/ do |user_id|
  assert (Friendship.where(user_id: user_id) + Friendship.where(friend_id: user_id)).empty?
end

Then /^there should be a friendship between "(.*)" and "(.*)"$/ do |user1, user2|
  user1 = User.find_by_name(user1)
  user2 = User.find_by_name(user2)
  assert (Friendship.exists?(user_id: user1, friend_id: user2, status: 'accepted'))
end

Given(/^"(.*?)" and "(.*?)" are friends$/) do |name1, name2|
  user1 = User.find_by_name(name1)
  user2 = User.find_by_name(name2)
  user1.friendships.build(friend_id: user2.id, status: 'accepted')
  user2.friendships.build(friend_id: user1.id, status: 'accepted')
  user1.save!
  user2.save!
end