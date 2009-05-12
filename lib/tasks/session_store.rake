file 'config/initializers/session_store.rb' do
  path = File.join(RAILS_ROOT, 'config', 'initializers', 'session_store.rb')
  File.open(path, 'w') do |f|
    f.write <<"EOD"
# Secret key for verifying cookie session data integrity.
# Keep it out of version controll.

ActionController::Base.session = {
  :session_key => '_blog_session',
  :secret      => '#{ActiveSupport::SecureRandom.hex(40)}'
}
EOD
  end
end
