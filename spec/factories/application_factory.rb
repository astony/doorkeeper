FactoryGirl.define do
  factory :application, class: Doorkeeper.configuration.application_model.constantize do
    sequence(:name) { |n| "Application #{n}" }
    redirect_uri 'https://app.com/callback'
  end
end
