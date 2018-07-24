FactoryBot.define do
  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    commentable_type 'Question'
    body Faker::Lorem.unique.sentence
    user
  end

  factory :answer_comment, class: Comment do
    association :commentable, factory: :answer
    commentable_type 'Answer'
    body Faker::Lorem.unique.sentence
    user
  end
end
