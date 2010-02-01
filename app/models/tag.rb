class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :posts, :through => :taggings

  def self.tag_counts
    Tag.find(:all, 
             :select => 'tags.id, tags.name, COUNT(*) as count', 
             :joins => {:taggings => :post}, 
             :group => 'tags.name',
             #     :conditions => 'post.published IS NOT NULL',
             :order => 'name')
  end

  def to_param
    name.parameterize
  end
end
