FactoryBot.define do
  factory :vote do
    value 1
    association :user, factory: :user

  end

  factory :invalid_vote, class: Vote do
    value nil
    association :user, factory: :user
  end
end
