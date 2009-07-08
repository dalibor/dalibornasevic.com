class Post < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :content
  
  has_many :comments
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  
  attr_writer :tag_names
  attr_writer :publish

  after_save :assign_tags
  
  before_save :check_for_publish
  
  def tag_names
    @tag_names || tags.map{|t| t.name}.join(' ') # it seems like factory girl somehow can't handle tags.map(&name).join(' ')
  end
  
  def publish
    @publish || !published_at.nil?
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end
  
  def check_for_publish
   self.published_at = nil unless publish == '1'
  end
end