module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      root_path
    when /^list of posts$/
      posts_path
    when /^list of posts in administration$/
      admin_posts_path
    when /^blog post with id (\d+) in administration$/
      admin_post_path($1)
    when /^edit blog post with id (\d+) in administration$/
      edit_admin_post_path($1)
    when /^new blog post in administration$/
      new_admin_post_path
    when /^delete blog post with id (\d+) in administration$/
      delete_admin_post_path($1)


    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)


#  World do |world|
#    world.extend NavigationHelpers
#    world
#  end

