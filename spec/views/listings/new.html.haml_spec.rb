require 'spec_helper'

describe "listings/new" do
  before(:each) do
    assign(:listing, stub_model(Listing,
      :price => "9.99",
      :instructions => "MyText",
      :title => "MyString",
      :requirements => "MyText",
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new listing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", listings_path, "post" do
      assert_select "input#listing_price[name=?]", "listing[price]"
      assert_select "textarea#listing_instructions[name=?]", "listing[instructions]"
      assert_select "input#listing_title[name=?]", "listing[title]"
      assert_select "textarea#listing_requirements[name=?]", "listing[requirements]"
      assert_select "input#listing_status[name=?]", "listing[status]"
    end
  end
end
