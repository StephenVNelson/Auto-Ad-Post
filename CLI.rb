require "tty-prompt"
require 'yaml'
require_relative 'Post'
require_relative 'PostPreferencesManagement'

class CLI < Post
  include PostPreferenceManagement

  attr_accessor :post_preferences, :posts, :all_posts
  attr_reader :prompt, :apartments, :default

  def initialize 
    @prompt = TTY::Prompt.new
    @post_preferences = load_preferences
    @all_posts = post_preferences[:posts]
    @default = use_default?
    @apartments = Company.new.greystone_apartments
  end
  
  def use_default?
    default = prompt.yes?("Would you like to use default settings?")
    post_preferences[:default] = default
    save_preferences
    default
  end

  def choose_postings
    choices = {
      "Website" => "site", 
      "Group Name" => "group_name",
      "Type" => "type"
    }
    property = prompt.select("Select By?", choices)
    choices = uniq_property_values(property)
    criteria = prompt.multi_select("Select where you want to post", choices)
    query_posts(property, criteria)
  end

  def get_edit_options
    options = posts
    .each_with_index
    .map do |post, idx| 
      group = post[:group_name].upcase
      options = post[:options].join('|')
      {"#{group}: #{options}" => idx}
    end
    prompt.multi_select("Select the post options you would like to configure: ", ["No Changes", *options])
  end

  def configure_post(post)
    options = post_preferences[:options]
    chosen_options = prompt.multi_select("Select desired options for #{post[:group_name]}:", options)
    post[:options] = chosen_options
  end

  def edit_options
    options = get_edit_options
    unless options[0] == "No Changes"
      options.each {|opt| configure_post(posts[opt - 1])}
    end
  end

  def post 
    posts.shuffle.each do |options|
      apartments.shuffle.each do |apartment|
        post = Post.new(apartment, options)
        post.post
        update_posting(post) 
      end
    end
  end
  
  def run
    @posts = default ? all_posts : choose_postings
    edit_options unless default
    post
  end


end

CLI.new.run
