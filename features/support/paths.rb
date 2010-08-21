module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /home\s?page/
      '/'

    when /new website page/
      new_website_path

    when /create website page/
      websites_path

    when /show website page/
      website_path

    when /about page/
      about_path

    when /(.*)'s website page/
      website_path(Website.find_by_url($1))

    when /an invalid website show page/
      website_path(9999999) # Should be larger then any ID in the database

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        # If the page name starts in a path, strip it and try again
        if page_name.starts_with?("the ")
          begin
            return path_to(page_name[4..page_name.length])
          rescue
          end
        end

        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise RuntimeError, "Can't find mapping from \"#{page_name}\" to a path.\n Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
