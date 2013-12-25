Given /the following friendships exist/ do |friendships_table|
  friendships_table.hashes.each do |friendship|
    Friendship.create(friendship)
  end
end

And /^no friendship should have friend or user id "(.*)"$/ do |user_id|
  assert (Friendship.where(user_id: user_id) + Friendship.where(friend_id: user_id)).empty?
end
