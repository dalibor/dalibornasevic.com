require 'digest/md5'

Given /^I am logged in$/ do
  basic_auth(USERNAME, PASSWORD)
#  header('HTTP_AUTHORIZATION', "Basic #{["#{USERNAME}:#{PASSWORD}"].pack("m*")}")
end

Given /^I have posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end

Given /^I have no posts$/ do
  Post.delete_all
end

Then /^I should have (\d+) post.?$/ do |count|
  Post.count.should == count.to_i
end

Given /^I have created posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end

private

  def authenticate_with_http_digest(user = 'admin', password = 'admin', realm = 'Application')
    unless ActionController::Base < ActionController::ProcessWithTest
      ActionController::Base.class_eval { include ActionController::ProcessWithTest }
    end
 
    @controller.instance_eval %Q(
      alias real_process_with_test process_with_test
 
      def process_with_test(request, response)
        credentials = {
          :uri => request.env['REQUEST_URI'],
          :realm => "#{realm}",
          :username => "#{user}",
          :nonce => ActionController::HttpAuthentication::Digest.nonce,
          :opaque => ActionController::HttpAuthentication::Digest.opaque,
        }
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Digest.encode_credentials(
          request.request_method, credentials, "#{password}", false
        )
        real_process_with_test(request, response)
      end
    )
  end
