Given /the following listings exist/ do |listings_table|
  hashes = listings_table.hashes
  hashes.each do |hash|
    hash.each do |key, value|
      if value == 'TODAY'
        hash[key] = Time.now
      elsif value == 'NEVER'
        hash[key] = Time.now + 20.years
      end
    end
  end
  hashes.each do |listing|
    listing = Listing.create!(listing)
  end
end

Given(/^I create a listing with "(.*?)" input$/) do |type|
  if type == 'standard'
    input = { price: '10',
              title: 'standard listing',
              description: 'standard listing description',
              positions: '1',
              end_year: "2015",
              audience: 'everyone'}
  elsif type == 'friend-only'
    input = { price: '10',
              title: 'friend-only listing',
              description: 'friend-only listing description',
              positions: '1',
              end_year: "2015",
              audience: 'friends'}
  end
  visit path_to("create listing page")
  fill_in("listing[price]", with: input[:price])
  fill_in("listing[title]", with: input[:title])
  fill_in("listing[description]", with: input[:description])
  fill_in("listing[positions]", with: input[:positions])
  # select(input[:end_year], from: "listing[end_time(1i)]")
  select(input[:audience], from: "listing[audience]")
  click_button("Save Listing")
end

Then(/^listing "(.*?)" should not exist$/) do |title|
  !!Listing.find_by_title(title)
end

Then(/^"(.*?)" should be an applicant for listing "(.*?)"$/) do |name, title|
  Listing.find_by_title(title).applicants.include? User.find_by_name(name)
end

Then(/^"(.*?)" should not be an applicant for listing "(.*?)"$/) do |name, title|
  !Listing.find_by_title(title).applicants.include? User.find_by_name(name)
end

Given(/^"(.*?)" has applied for "(.*?)"$/) do |user_name, listing_title|
  listing = Listing.find_by_title(listing_title)
  user = User.find_by_name(user_name)
  listing.applicants.build(user_id: user.id)
  listing.save!
end

Given(/^"(.*?)" is hired for "(.*?)"$/) do |user_name, listing_title|
  steps %{
    Given "#{user_name}" has applied for "#{listing_title}"
    Given I am signed in with provider "facebook"
    And I am on the show page for listing "#{listing_title}"
    And I follow "Hire"
    And I accept the alert
    Then I should be on the show page for listing "#{listing_title}"
    And I should see "#{user_name} has been hired for this listing!"
    And listing "#{listing_title}" should have status "pending"
    And I should see "#{user_name}" after "Currently hired:"
  }
end

Then(/^listing "(.*?)" should have status "(.*?)"$/) do |listing_title, status|
  listing = Listing.find_by_title(listing_title)
  listing.status == status
end

Given(/^"(.*?)" completes listing "(.*?)"$/) do |user_name, listing_title|
  steps %{
    And I am signed in with provider "twitter"
    And I am on the show page for listing "#{listing_title}"
    And I follow "Job Complete"
    And I accept the alert
    Then I should be on the show page for listing "#{listing_title}"
    And I should see "Job complete! Waiting for customer approval."
  }
end

Then(/^"(.*?)" should be hired for "(.*?)"$/) do |user_name, listing_title|
  user_id = User.find_by_name(user_name).id
  listing = Listing.find_by_title(listing_title).services.find_by_provider_id(user_id)
  !!listing and listing.active?
end

Then(/^"(.*?)" should not be hired for "(.*?)"$/) do |user_name, listing_title|
  user_id = User.find_by_name(user_name).id
  !Listing.find_by_title(listing_title).services.find_by_provider_id(user_id)
end

Given(/^"(.*?)" quits listing "(.*?)"$/) do |arg1, listing_title|
  steps %{
    And I am signed in with provider "twitter"
    And I am on the show page for listing "#{listing_title}"
    And I follow "Quit Job"
    And I accept the alert
  }
end

Given(/^"(.*?)" approves listing "(.*?)"$/) do |arg1, arg2|
  steps %{
    And I am signed in with provider "facebook"
    And I am on the show page for listing "first listing"
    And I follow "Approve"
    And I accept the alert
  }
end

Given(/^"(.*?)" rehires me for listing "(.*?)"$/) do |arg1, arg2|
  steps %{
    And I am signed in with provider "facebook"
    And I am on the show page for listing "first listing"
    And I follow "Reject"
    And I press "Rehire"
  }
end

Given(/^"(.*?)" relists listing "(.*?)"$/) do |arg1, arg2|
  steps %{
    And I am signed in with provider "facebook"
    And I am on the show page for listing "first listing"
    And I follow "Reject"
    And I press "Relist"
  }
end
