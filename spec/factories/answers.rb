FactoryBot.define do
  factory :answer do
    body "MyText"
    association :question, factory: :question
  end

  factory :invalid_answer, class: Answer do
    body nil
    association :question, factory: :question
  end
end
