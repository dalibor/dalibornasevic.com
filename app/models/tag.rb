class Tag < ActiveRecord::Base

  # Associations
  has_many :taggings, :dependent => :destroy
  has_many :posts, :through => :taggings

  def self.tag_counts
    Tag.select('tags.id, tags.name, COUNT(*) as count').
             joins({:taggings => :post}).
             group('tags.name').
             where('posts.published_at IS NOT NULL').
             order('tags.name')
  end

  def to_param
    name.parameterize
  end
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

