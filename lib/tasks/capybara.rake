namespace :capy do
   desc "Remove temporary capybara web pages"
   task :clean do
     Dir[File.join(Rails.root, 'capybara-*.html')].each { |file| system "rm #{file}" }
   end
end

