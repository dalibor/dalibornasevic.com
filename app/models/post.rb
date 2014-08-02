class Post < ActiveRecord::Base

  # Attributes
  attr_accessible :title, :content, :tag_names, :publish, :published_at
  attr_writer :tag_names

  # Validations
  validates :title, :presence => true
  validates :content, :presence => true

  # Associations
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  belongs_to :editor

  # Callbacks
  before_save :reset_published_at, :unless => Proc.new {|m| m.publish }
  after_save :assign_tags

  # Scopes
  scope :published, where({:publish => true})

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def self.posts_by_year
    select("published_at, COUNT(*) AS total").
    group("YEAR(published_at)").
    where('published_at IS NOT NULL').
    order('published_at DESC')
  end

  private
  def assign_tags
    if tag_names
      self.tags = tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end

  def reset_published_at
    self.published_at = nil
  end
end
