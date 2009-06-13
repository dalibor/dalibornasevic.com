class Post < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :content
  
  has_many :comments


  def to_param
    "#{id}-#{title.parameterize}"
  end
end
