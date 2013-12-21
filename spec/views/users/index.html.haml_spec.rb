require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :name => "Name",
        :email => "Email",
        :remember_token => "Remember Token",
        :password_digest => "Password Digest",
        :admin => false,
        :password_confirmation => "Password Confirmation"
      ),
      stub_model(User,
        :name => "Name",
        :email => "Email",
        :remember_token => "Remember Token",
        :password_digest => "Password Digest",
        :admin => false,
        :password_confirmation => "Password Confirmation"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Remember Token".to_s, :count => 2
    assert_select "tr>td", :text => "Password Digest".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Password Confirmation".to_s, :count => 2
  end
end
