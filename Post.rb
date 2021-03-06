require_relative 'Prospect'
require_relative 'Apartment'
require 'webdrivers/chromedriver'
require 'pry'
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'yaml'

Capybara.configure do |c|
  c.run_server = false
  c.default_driver = :selenium
  c.app_host = 'http://www.google.com'
end
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

class Post < Apartment
  include Capybara::DSL
  include Description

  @@posts = 0

  attr_accessor :first_post
  attr_reader :apartment, :credentials, :site, :group_name, :type, :url, :last_posted, :post_span, :options, :matching, :shared, :linked

  def initialize(apartment, options)
    @site = options[:site]
    @group_name = options[:group_name]
    @type = options[:type]
    @url = options[:url]
    @last_posted = options[:last_posted]
    @post_span = options[:post_span]
    @options = options[:options]
    @apartment = apartment
    @credentials = YAML.load(File.read("credentials.yml"))
    @first_post = @@posts < 1
    @matching = @options.include?("matching")
    @linked = @options.include?("linked")
    @shared = @options.include?("shared")
    @@posts += 1
  end

  def self.four_days_ago?
    data = YAML.load(File.read("apartment_data.yaml"))
    last_updated = data[:last_update]
    old_enough = last_updated <= Date.today - 3
    if old_enough
      data[:last_update] = Date.today
      File.open("apartment_data.yaml", 'w') { |f| YAML.dump(data, f) }
    end
    old_enough
  end

  def wait_for(css: '', message: '', page_has_css: false)
    i = 0
    while page_has_css ? !page.has_css?(css) : page.has_css?(css)
      sleep 1
      print "#{group_name}: #{message}: #{i}\r"
      yield(css) if block_given?
      i += 1
    end
    puts ''
  end

  # CREATE METHODS
  def create_sales
    puts "Posting sales group to #{group_name}. shared: #{shared}, matching:#{matching}"
    click_link("Discussion")
    find("div[role='presentation'] > div > div > div > div > div > label > input").click
    fill_in(
      "What are you selling?",
      with: @apartment.titles(shared: shared)
    )
    wait_for(
      css: "div > div > div > div:nth-child(1) > div > div > label > input[placeholder='Price']",
      message: "price input",
      page_has_css: true
    ) { find("div > div > div > div:nth-child(1) > div > div > label > input[placeholder='What are you selling?']").click}
    fill_in(
      "Price",
      with: @apartment.adjusted_rent(shared: shared)
    )
    find("div > div > div > div:nth-child(1) > div:nth-child(5) > div:nth-child(1) > div > div > div > div > div > div > div > div[data-block='true'] > div")
      .set(@apartment.descriptions(shared: shared, matching: matching))
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    wait_for(css: "button:disabled", message: "'next' enabled:")
    click_button("Next")
    click_button("Publish")
    wait_for(
      css: "div > div > div > div > div > div > div > div > span > button > div > span[role='progressbar']", 
      message: "publishing."
    )
  end

  def create_discussion
    find(".fbReactComposerMoreButton").click
    first(".fbReactComposerAttachmentSelector_MEDIA").click
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    first("[style='outline: none; user-select: text; white-space: pre-wrap; overflow-wrap: break-word;']")
      .set(@apartment.descriptions(shared: shared, matching: matching))
    wait_for(css: "div[role='progressbar']", message: "Photo Load")
    sleep 1
    wait_for(css: "button:disabled", message: 'enabling')
    click_button('Post')
    wait_for(css: "button:disabled", message: 'enabling')
  end

  def create_cl_main
    within(:css, "form.new_posting_thing") do
      click_button('go')
    end
    choose('westside-southbay-310')
    choose('housing offered')
    shared ? find(:css, '[value="18"]').click : find(:css, '[value="1"]').click
    fill_in("PostingTitle", with: @apartment.titles(shared: shared))
    fill_in("GeographicArea", with: @apartment.building.city)
    fill_in("postal", with: @apartment.building.zip_code)
    fill_in("PostingBody", with: @apartment.descriptions(unlinked: true, shared: shared, matching: matching))
    rent = shared ? @apartment.rent / @apartment.max_tenants : @apartment.rent
    fill_in("price", with: rent)
    fill_in("Sqft", with: @apartment.sqft)
    find('#ui-id-2-button').click
    4.times {find('#ui-id-2-button').send_keys(:arrow_down)}
    find('#ui-id-2-button').send_keys(:enter)
    find('#ui-id-3-button').click
    find('#ui-id-3-button').send_keys(:arrow_down)
    find('#ui-id-3-button').send_keys(:enter)
    if !shared
      find('#Bedrooms-button').click
      find('#Bedrooms-button').send_keys(:arrow_down)
      find('#Bedrooms-button').send_keys(:enter)
    else
      find('#ui-id-1-button').click
      find('#ui-id-1-button').send_keys(:arrow_down)
      find('#ui-id-1-button').send_keys(:enter)
    end
    find('#ui-id-4-button').click
    3.times {find('#ui-id-4-button').send_keys(:arrow_down)}
    find('#ui-id-4-button').send_keys(:enter)
    fill_in('select date', with: @apartment.available)
    if !shared
      check('application_fee')
      fill_in('application_fee_explained', with: @apartment.building.company.app_fee)
    end
    check('show_address_ok')
    fill_in('xstreet0', with: @apartment.building.cross_street_1)
    fill_in("xstreet1", with: @apartment.building.cross_street_2)
    fill_in("city", with: @apartment.building.city)
    click_button('go')
    click_button('continue')
    find("#classic").click if @@posts <= 1
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("file", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    click_button("done with images")
    find(".bigbutton").click
    sleep 4
  end

  # DELETE METHODS
  def delete_sales
    click_link('Your Items')

    # if it doesn't have the "you don't have anything for sale" image
    if !page.has_css?("div[role='feed'] > div > img")
      all("div[role='feed'] > div").each do
        within(first("div[role='feed'] > div")) do
          click_button("More")
        end
        all("div > div > ul > li:nth-child(2) > a > span > span > i").last.click
        find("div > div > div > div > div > div > button", text: "Delete").click
        wait_for(
          css: "div[data-testid='delete_post_confirm_dialog']", message: "submitting delete:")
        if page.has_text?("Did you sell this item?")
          find('span', text: "I'd rather not answer").click
          click_button('Next')
          click_link('Your Items')
        end
      end
    end
  end

  def delete_discussion
    click_link("Members")
    until page.has_css?("#groupsMemberSection_self_bio") do
      puts "Wait delete post options"
    end
    has_view = false
    within("#groupsMemberSection_self_bio") do
      if page.has_link?('View')
        has_view = true
        click_link('View')
      end
    end
    if has_view
      total = all("[data-testid='post_chevron_button']").count
      all("[data-testid='post_chevron_button']").each_with_index do |option,i|
        puts "chevron button #{i + 1} of #{total}"
        sleep 1
        first("#fb_groups_member_bio_dialog > div > div > div > div > div >div a[data-testid='post_chevron_button']").click
        wait_for(
          css: "div.uiContextualLayerPositioner.uiLayer:not(.hidden_elem)",
          message: "wait for popup: ",
          page_has_css: true
        )
        # waits for the DOM to recognize the new HTML after the chevron is pressed. 
        until all("#post_menu").count == (i+1)
          sleep 1
        end
        all("#post_menu > div > ul > li").last.click
        click_button("Delete")
        sleep 3
        if page.has_text?("Did you sell this item?")
          find('span', text: "I'd rather not answer").click
          click_button('Next')
        end
      end
      find("html").send_keys(:escape)
    end
    click_link("Discussion")
  end

  def delete_cl_main
    page.all("input[value='delete']").each do |delete|
      first("input[value='delete']").click
      click_link("strathmore@gmgapts.com")
    end
  end

  def delete_marketplace
    within("div[role='main']") do
      # This is the code that makes everything run so slow
      wait_for(css: "span[role='progressbar']", message: "waiting for main:")
    end
    postings = page.all('span', text: 'Manage')
    puts "there are #{postings.count} postings"
    postings.each_with_index do |posting, idx|
      puts "index:#{idx} of #{postings.count}"
      within("div[role='main']") do
        wait_for(css: "span[role='progressbar']", message: "waiting for main:")
      end
      within(all("section").first.sibling("div")) do
        all("span").first.click
      end
      within("div.uiContextualLayerPositioner:not(.hidden_elem)") do
        find('span > span', text: 'Delete Listing').click
      end
      
      wait_for(
        css: "body > div > div > div > div > div > div > div > div > div > span > div > div:nth-child(2) > button > div > div",
        message: "clicking delete: "
      ) {|css| find(css).click} #click_button("Delete")

      wait_for(
        css: "body > div > div > div > div > div > div > div > div > div > div > div > div > div > div:nth-child(4) > div:nth-child(2) > label > div > span",
        message: "answering questionaire: "
      ) do |css|
        find(css).click
        click_button("Next")
      end
    end
    visit('https://www.facebook.com/marketplace/selling/')
    find("html").send_keys(:escape)
  end

  #MAIN POSTING METHODS FOR EACH POST TYPE

  def post_to_marketplace 
    sleep 1
    visit url
    find("html").send_keys(:escape)
    if @@posts <= 1
      delete_marketplace
    end
    page.find('button', text: "Sell Something").click
    click_link("Homes for Sale or Rent")
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    first("span", text: "Select").click
    find("span", text:"For rent").click
    selects = page.all('span', text: 'Select')
    page.all("span", text: "Select")[1].click
    find('span', text: 'Apartment/Condo').click
    within("div[aria-label='Create a new sale post on Marketplace']") do
      inputs = page.all('input')
      selects = page.all('span', text: 'Select')
      inputs[2].set(@apartment.bedrooms)
      inputs[3].set(@apartment.bedrooms)
      until inputs[4].value == @apartment.formatted_rent(shared: shared)
        inputs[4].set(@apartment.adjusted_rent(shared: shared))
      end
      inputs[5].set("#{@apartment.building.address}, #{@apartment.building.city} #{@apartment.building.state}")
      sleep 1
      inputs[5].send_keys(:enter)
      find('textarea').set(@apartment.descriptions(shared: shared, matching: matching))
      inputs[7].set(@apartment.sqft)
      inputs[8].set(@apartment.available)
      selects[2].click
    end
    find('span', text: '6 months').click
    selects[3].click
    find('span', text: 'Laundry in building').click
    selects[4].click
    find('span', text: 'Parking available').click
    selects[5].click
    page.all('span', text: 'None')[2].click
    selects[6].click
    find('span', text: 'Gas heating').click
    click_button('Next')
    wait_for(css: "button:disabled", message: 'clicking next')
    click_button("Publish")
    wait_for(css: "button:disabled", message: 'posting')
  end

  def post_to_discussion
    sleep 1
    visit url
    find("html").send_keys(:escape)
    delete_discussion if @@posts <= 1
    create_discussion
  end

  def post_to_cl_main
    visit url
    delete_cl_main if first_post
    create_cl_main
  end

  def post_to_sales
    sleep 1
    visit url
    find("html").send_keys(:escape)
    delete_sales if first_post
    create_sales
  end

  def login 
    case site
    when 'facebook'
      visit "https://www.facebook.com/"
      fill_in("email", with: @credentials[:facebook][:username])
      fill_in("pass", with: @credentials[:facebook][:password])
      click_button("Log In")
    when 'craigslist'
      visit 'https://accounts.craigslist.org/login/home'
      fill_in('inputEmailHandle', with: @credentials[:craigslist][:username])
      fill_in('inputPassword', with: @credentials[:craigslist][:password])
      find('#login').click
    end
  end

  def post
    puts "Unit: #{@apartment.unit}"
    login if first_post
    Capybara.ignore_hidden_elements = false if site == 'facebook'
    self.send("post_to_#{type}")
    Capybara.ignore_hidden_elements = true
  end

end

# Post.new.start_program

# Company.new.greystone_apartments.reverse.each_with_index do |apartment, i|
#   Post.new(apartment).post_everywhere
# end

# test descriptions
# Company.new.greystone_apartments.each do |apartment|
#   puts apartment.unit
#   puts apartment.descriptions(shared: true, matching: true, unlinked: false)
# end