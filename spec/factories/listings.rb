# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing do
    price "9.99"
    instructions "MyText"
    title "MyString"
    start_time "2013-12-27 23:05:09"
    end_time "2013-12-27 23:05:09"
    requirements "MyText"
    status "MyString"
  end
end
