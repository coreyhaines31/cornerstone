FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Account #{n}" }
    sequence(:slug) { |n| "account-#{n}" }
    subscription_status { "trialing" }
  end
end
