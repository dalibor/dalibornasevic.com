FactoryGirl.define do
  factory :comment do |f|
    f.name "Pink Panter"
    f.email "pink.panter@gmail.com"
    f.url "http://www.pinkpanter.com"
    f.content "This is my first comment"
    f.approved true
    f.association :post
  end
end
