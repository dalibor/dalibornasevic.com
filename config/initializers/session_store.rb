# Secret key for verifying cookie session data integrity.
# Keep it out of version controll.

ActionController::Base.session = {
  :session_key => '_blog_session',
  :secret      => 'a3449cffb1f2c2b50cd679dba7d9d567660d7cf97ffea2d7f63e298c82480ad1431f69b0b2f556ad'
}
