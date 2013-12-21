require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "MyString",
      :email => "MyString",
      :remember_token => "MyString",
      :password_digest => "MyString",
      :admin => false,
      :password_confirmation => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_path(@user), "post" do
      assert_select "input#user_name[name=?]", "user[name]"
      assert_select "input#user_email[name=?]", "user[email]"
      assert_select "input#user_remember_token[name=?]", "user[remember_token]"
      assert_select "input#user_password_digest[name=?]", "user[password_digest]"
      assert_select "input#user_admin[name=?]", "user[admin]"
      assert_select "input#user_password_confirmation[name=?]", "user[password_confirmation]"
    end
  end
end