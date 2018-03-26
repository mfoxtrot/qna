FactoryBot.define do
  factory :question do
    title "MyString"
    body "MyText"
  end

  factory :invalid_question, class: Question do
    title "MyString"
    body nil
  end
end
