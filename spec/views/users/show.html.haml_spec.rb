require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "Name",
      :email => "Email",
      :remember_token => "Remember Token",
      :password_digest => "Password Digest",
      :admin => false,
      :password_confirmation => "Password Confirmation"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Remember Token/)
    rendered.should match(/Password Digest/)
    rendered.should match(/false/)
    rendered.should match(/Password Confirmation/)
  end
end
