editor = Editor.first
Post.all.each do |post|
  post.editor = editor
  post.publish = true
  post.save!
end
