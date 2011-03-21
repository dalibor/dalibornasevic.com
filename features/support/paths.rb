module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the homepage/
      root_path
    when /^admin root page in administration$/
      admin_root_path
    when /^list of posts$/
      posts_path
    when /^list of posts in administration$/
      admin_posts_path
    when /^list of comments in administration$/
      admin_comments_path
    when /^post with id "([^\"]*)"$/
      post_path($1)
    when /^post with id (\d+) in administration$/
      admin_post_path($1)
    when /^edit post with id (\d+) in administration$/
      edit_admin_post_path($1)
    when /^new post in administration$/
      new_admin_post_path
    when /^delete post with id (\d+) in administration$/
      delete_admin_post_path($1)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
