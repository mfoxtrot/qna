FactoryBot.define do
  factory :answer do
    body "MyText"
    association :question, factory: :question
  end

  factory :invalid_answer, class: Answer do
    body nil
    association :question, factory: :question
  end

  factory :answer_for_question, class: Answer do
    body Faker::Lorem.unique.sentence
    question
  end
end
