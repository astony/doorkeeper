FactoryGirl.define do
  factory :access_token, class: Doorkeeper.configuration.access_token_model.constantize do
    sequence(:resource_owner_id) { |n| n }
    application
    expires_in 2.hours

    factory :clientless_access_token do
      application nil
    end
  end
end
