EMAIL_NAME_REGEX  = '[\w\.%\+\-]+'.freeze
DOMAIN_HEAD_REGEX = '(?:[A-Z0-9\-]+\.)+'.freeze
DOMAIN_TLD_REGEX  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
EMAIL_REGEX       = /\A#{EMAIL_NAME_REGEX}@#{DOMAIN_HEAD_REGEX}#{DOMAIN_TLD_REGEX}\z/i
URL_REGEX         = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

class Comment < ActiveRecord::Base
  include Rakismet::Model

  rakismet_attrs :author => :name,
    :author_email => :email,
    :author_url => :url,
    :comment_type => 'comment',
    :content => :content,
    :permalink => :permalink,
    :user_ip => :user_ip,
    :user_agent => :user_agent,
    :referrer => :referrer

  # Validations
  validates_presence_of :post_id, :name, :email, :content
  validates_format_of :email, :with => EMAIL_REGEX, :message => "is not an email address."
  validates_format_of :url, :with => URL_REGEX, :allow_blank => true

  # Associations
  belongs_to :post

  # Scopes
  scope :spam_comments, :conditions => { :approved => false }
  scope :valid_comments, :conditions => { :approved => true }

  # Callbacks
  before_validation :add_protocol_to_url
  before_create :check_for_spam
  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end

  def mark_as_spam!
    transaction do
      self.spam! if rakismet_key_present?
      update_attribute(:approved, false)
    end
  end

  def mark_as_ham!
    transaction do
      self.ham! if rakismet_key_present?
      update_attribute(:approved, true)
    end
  end

  private

    def add_protocol_to_url
      self.url = 'http://' + url unless url.blank? || url =~ /http/
    end

    def update_counter_cache
      self.post.comments_count = post.comments.count( :conditions => "approved = true")
      self.post.save
    end

    def check_for_spam
      if rakismet_key_present?
        self.approved = !self.spam?
      else
        self.approved = true
      end

      return true # explicitly return true TODO: check if this is still needed or rails bug is fixed
    end

    def rakismet_key_present?
      Rakismet::KEY.present?
    end
end
