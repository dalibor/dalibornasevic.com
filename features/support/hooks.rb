Before do
  # @after_current_scenario_blocks = []
  
  class ApplicationController
    def authenticate
      authenticate_or_request_with_http_basic(REALM) do |username, password|
        username == USERNAME && password == PASSWORD
      end
    end
  end
end

After do
 # if @after_current_scenario_blocks.any?
 #   @after_current_scenario_blocks.each{ |b| b.call }
 # end
 
  class ApplicationController
    def authenticate
      authenticate_or_request_with_http_digest(REALM) do |username|
        PASSWORD || false # should not return nil before rails 2.3.2-stable because of bug!!!
      end
    end
  end
end 