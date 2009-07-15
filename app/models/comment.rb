EMAIL_NAME_REGEX  = '[\w\.%\+\-]+'.freeze
DOMAIN_HEAD_REGEX = '(?:[A-Z0-9\-]+\.)+'.freeze
DOMAIN_TLD_REGEX  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
EMAIL_REGEX       = /\A#{EMAIL_NAME_REGEX}@#{DOMAIN_HEAD_REGEX}#{DOMAIN_TLD_REGEX}\z/i

class Comment < ActiveRecord::Base
  belongs_to :post, :counter_cache => true

  class << self
    attr_writer :minimum_wait_time
    
    def minimum_wait_time
      @minimum_wait_time || 15
    end
  end
  
  validates_presence_of :post_id, :name, :email, :content
  validates_format_of :email, :with => EMAIL_REGEX, :message => "is not an email address."
  validates_format_of :url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true
  
  before_validation :add_protocol_to_url
  
  def add_protocol_to_url
  	self.url = 'http://' + url unless url.blank? || url =~ /http/
  end
 

  
end
