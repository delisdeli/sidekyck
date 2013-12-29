require 'spec_helper'

describe "listings/show" do
  before(:each) do
    @listing = assign(:listing, stub_model(Listing,
      :price => "9.99",
      :instructions => "MyText",
      :title => "Title",
      :requirements => "MyText",
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    rendered.should match(/MyText/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/Status/)
  end
end
