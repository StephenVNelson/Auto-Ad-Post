module PostPreferenceManagement

  def load_preferences
    YAML.load(File.read("post_preferences.yml"))
  end

  def save_preferences
    if all_posts.count > 0 
      File.open("post_preferences.yml", "w") {
        |file| file.write(post_preferences.to_yaml)
      }
    else 
      raise StandardError.new("About to overwrite posts database with no data")
    end
  end

  def uniq_property_values(property)
    all_posts.map {|post| post[property.to_sym]}.uniq
  end

  # fitlers all_posts so you only have the ones that match all the criteria in the array
  def query_posts(property, criteria)
    matches = criteria.each_with_object([]) do |criterian,filtered|
      filtered << all_posts.select {|p| p[property.to_sym] == criterian}
    end.flatten
    raise StandardError.new("The query returned no values.") if matches.length == 0
    matches
  end

  # need to convert a Post object to a hash before it's put into yaml
  def convert_post_to_hash(post)
    {
      group_name: post.group_name,
      site: post.site,
      type: post.type,
      url: post.url,
      last_posted: Date.today,
      post_span: post.post_span,
      options: post.options
    }
  end

  def update_posting(post)
    updated_posts = all_posts.map do |all_post|
      if all_post[:group_name] == post.group_name
        convert_post_to_hash(post)
      else
        all_post
      end
    end
    @all_posts = updated_posts
    post_preferences[:posts] = all_posts
    save_preferences
  end

end