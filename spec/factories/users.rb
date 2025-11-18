FactoryBot.define do
  factory :user do
    first_name { "Test" }
    last_name  { "User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Password123!" }
    confirmed_at { Time.current }

    trait :with_account do
      after(:create) do |user|
        account = create(:account)
        create(:membership, account: account, user: user, role: "owner", accepted_at: Time.current, email: user.email)
      end
    end
  end
end
