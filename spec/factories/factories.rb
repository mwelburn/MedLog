# By using the symbol ':user', we get Factory Girl to simulate the User model
FactoryGirl.define do
  sequence :email do |n|
    "person-#{n}@example.com"
  end

  sequence :username do |n|
    "testuser_#{n}"
  end

  sequence :name do |n|
    "Test User #{n}"
  end

  factory :user do
    name
    username
    email
    password               "foobar"
    password_confirmation  "foobar"
  end

  factory :finger do
    user
    digit       3
    side        1
    size        4.25
    comment     "foobar"
  end
end