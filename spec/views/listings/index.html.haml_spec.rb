require 'spec_helper'

describe "listings/index" do
  before(:each) do
    assign(:listings, [
      stub_model(Listing,
        :price => "9.99",
        :instructions => "MyText",
        :title => "Title",
        :requirements => "MyText",
        :status => "Status"
      ),
      stub_model(Listing,
        :price => "9.99",
        :instructions => "MyText",
        :title => "Title",
        :requirements => "MyText",
        :status => "Status"
      )
    ])
  end

  it "renders a list of listings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
