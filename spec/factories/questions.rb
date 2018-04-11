FactoryBot.define do
  factory :question do
    title Faker::Lorem.unique.sentence
    body Faker::Lorem.unique.paragraph
    association :author, factory: :user
  end

  factory :invalid_question, class: Question do
    title Faker::Lorem.unique.sentence
    body nil
    association :author, factory: :user
  end

  factory :question_with_answers, class: Question do
    title Faker::Lorem.unique.sentence
    body Faker::Lorem.unique.paragraph
    association :author, factory: :user

    after(:create) do |question_with_answers, evaluator|
      create_list(:answer_for_question, 10, question: question_with_answers)
    end
  end
end
