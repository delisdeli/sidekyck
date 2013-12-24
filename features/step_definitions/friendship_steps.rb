Given /the following friendships exist/ do |friendships_table|
  friendships_table.hashes.each do |friendship|
    Friendship.create(friendship)
  end
end