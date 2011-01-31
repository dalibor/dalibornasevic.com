Factory.define :comment, :class => Comment do |f|
  f.post      nil
  f.name      "Pink Panter"
  f.email     "pink.panter@gmail.com"
  f.url       "http://www.pinkpanter.com"
  f.content   "This is my first comment"
  f.approved  0
end
