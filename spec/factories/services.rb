# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    listing nil
    status "MyString"
    start_time "2014-01-04 13:32:36"
    completion_time "2014-01-04 13:32:36"
    customer_id 1
    provider_id 1
  end
end
