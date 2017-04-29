FactoryGirl.define do
  factory :user, class: Doorkeeper.configuration.user_model.constantize do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "test_#{n}@test.com" }
    password 'password'
    password_confirmation 'password'
  end
end
