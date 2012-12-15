FactoryGirl.define do
  factory :attachment do |f|
    f.name 'Attachment1'
    f.attachment { File.open(File.join(Rails.root, "/spec/fixtures/rails1.png")) }
    f.association :editor
  end
end
