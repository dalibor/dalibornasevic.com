class Editor < ActiveRecord::Base

  # Attributes
  attr_accessible :name, :email, :password, :password_confirmation
  attr_accessor :password

  # Validations
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  # Callbacks
  before_save :encrypt_password

  def self.authenticate(email, password)
    editor = find_by_email(email)
    if editor && editor.password_hash == BCrypt::Engine.hash_secret(password, editor.password_salt)
      editor
    else
      nil
    end
  end

  def display_name
    name || email
  end

  private

    def encrypt_password
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end

end
