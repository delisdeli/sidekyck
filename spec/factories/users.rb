# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
    remember_token "MyString"
    password_digest "MyString"
    admin false
    password_confirmation "MyString"
  end
end
