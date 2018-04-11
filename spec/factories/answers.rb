FactoryBot.define do
  factory :answer do
    body Faker::Lorem.unique.sentence
    association :question, factory: :question
    association :author, factory: :user
  end

  factory :invalid_answer, class: Answer do
    body nil
    association :question, factory: :question
    association :author, factory: :user
  end

  factory :answer_for_question, class: Answer do
    body Faker::Lorem.unique.sentence
    question
    association :author, factory: :user
  end
end
