require 'factory_girl'

# By using the symbol ':user', we get Factory Girl to simulate the User model
FactoryGirl.define do
  sequence :email do |n|
    "person-#{n}@example.com"
  end

  sequence :username do |n|
    "testuser_#{n}"
  end

  sequence :name do |n|
    "Test Name #{n}"
  end

  factory :user do
    name
    username
    email
    password               "foobar"
    password_confirmation  "foobar"
  end

  factory :event do
    user
    name        "Flu Shot"
    event_date        Date.new(2012,5,1)
    comment     "foobar"
    event_type  "shot"
  end
end