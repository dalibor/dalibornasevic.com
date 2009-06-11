Factory.define :comment do |f|
  f.association :post
  f.name "Dalibor Nasevic"
  f.email "dalibor.nasevic@gmail.com"
  f.url "http://www.dalibornasevic.com"
  f.content "This is my first comment"
end
