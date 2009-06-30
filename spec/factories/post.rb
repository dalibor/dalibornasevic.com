Factory.define :post do |f|
  f.title "My first blog post"
  f.content "This is my first blog post"
  f.tag_names "Tag1 Tag2 Tag3"
end

Factory.define :post_with_tags, :class => Post do |f|
  f.tags {|tags| [tags.association(:tag1), tags.association(:tag2), tags.association(:tag3)]}  
  f.title "My first blog post"
  f.content "This is my first blog post"
  f.tag_names "Tag1 Tag2 Tag3"
end

Factory.define :post_with_1_tag, :class => Post do |f|
  f.tags {|tags| [tags.association(:tag1)]}  
  f.title "My first blog post"
  f.content "This is my first blog post"
  f.tag_names "Tag1"
end