def authenticate_with_http_basic(username, password, realm)
  request.env['HTTP_AUTHORIZATION'] = "Basic #{Base64.encode64("#{username}:#{password}")}"
end
