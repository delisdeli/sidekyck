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
  select(input[:end_year], from: "listing[end_time(1i)]")
  select(input[:audience], from: "listing[audience]")
  click_button("Save Listing")
end

Then(/^listing "(.*?)" should not exist$/) do |title|
  !!Listing.find_by_title(title)
end