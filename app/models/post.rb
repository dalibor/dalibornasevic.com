class Post < ActiveRecord::Base

  # Validations
  validates :title, :presence => true
  validates :content, :presence => true

  # Associations
  has_many :comments
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  # Attributes
  attr_writer :publish
  attr_writer :tag_names

  # Callbacks
  before_save :reset_published_at, :unless => Proc.new {|m| m.publish }
  after_save :assign_tags

  # nil is when the post form is not submitted
  # but when the post is updated with comments cache counter
  def publish
    @publish.nil? ? published_at : @publish
  end

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  def to_param
    "#{id}-#{title.parameterize}"
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
