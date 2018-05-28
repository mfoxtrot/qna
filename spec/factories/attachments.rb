FactoryBot.define do
  factory :attachment do
    file File.open("#{Rails.root}/spec/fixtures/files/file_upload_test.txt")
  end
end
