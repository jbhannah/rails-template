FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
