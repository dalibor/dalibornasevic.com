Factory.define :comment, :class => Comment do |f|
  f.post      nil
  f.name      "Dalibor Nasevic"
  f.email     "dalibor.nasevic@gmail.com"
  f.url       "http://www.dalibornasevic.com"
  f.content   "This is my first comment"
  f.approved  0
end
