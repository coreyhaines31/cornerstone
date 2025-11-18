FactoryBot.define do
  factory :membership do
    association :account
    association :user
    role { "member" }
    email { user&.email || "member@example.com" }
    accepted_at { Time.current }
  end
end
