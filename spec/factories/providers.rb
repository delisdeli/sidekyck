# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider do
    name "MyString"
    uid "MyString"
    user nil
  end
end
