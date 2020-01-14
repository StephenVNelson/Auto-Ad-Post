require_relative 'Apartment'
require 'webdrivers/chromedriver'
require 'pry'
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

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

  attr_reader :apartment, :credentials

  def initialize(apartment)
    @apartment = apartment
    @credentials = YAML.load(File.read("credentials.yml"))
    @@posts += 1
  end

  def craigslist(shared: false)
    visit 'https://accounts.craigslist.org/login/home'
    puts "posts: #{@@posts}"
    if @@posts <= 1
      fill_in('inputEmailHandle', with: @credentials[:craigslist][:username])
      fill_in('inputPassword', with: @credentials[:craigslist][:password])
      find('#login').click
      page.all("input[value='delete']").each do |delete|
        first("input[value='delete']").click
        click_link("strathmore@gmgapts.com")
      end
    end
    within(:css, "form.new_posting_thing") do
      click_button('go')
    end
    choose('westside-southbay-310')
    choose('housing offered')
    shared ? find(:css, '[value="18"]').click : find(:css, '[value="1"]').click
    fill_in("PostingTitle", with: @apartment.titles(shared: shared))
    fill_in("GeographicArea", with: @apartment.building.city)
    fill_in("postal", with: @apartment.building.zip_code)
    fill_in("PostingBody", with: @apartment.descriptions(unlinked: true, shared: shared))
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

  def post_to_ucla_off_campus_housing(shared: false)
    visit "https://www.facebook.com/groups/1835635240040670/"
    find("html").send_keys(:escape)
    # if @@posts <= 1
    #   click_link("Members")
    #   until page.has_css?("#groupsMemberSection_self_bio") do
    #     puts "Wait delete post options"
    #   end
    #   has_view = false
    #   within("#groupsMemberSection_self_bio") do
    #     if page.has_link?('View')
    #       has_view = true
    #       click_link('View')
    #     end
    #   end
    #   if has_view
    #     total = all("[data-testid='post_chevron_button']").count
    #     all("[data-testid='post_chevron_button']").each_with_index do |option,i|
    #       # binding.pry if i >= 1
    #       puts "chevron button #{i + 1} of #{total}"
    #       sleep 1
    #       # binding.pry if (i+1) == total
    #       first("[data-testid='post_chevron_button']").click
    #       sleep 1
    #       click_link("Delete post")
    #       # all("div", text: "Delete post").last.click
    #       sleep 1
    #       click_button("Delete")
    #       sleep 1
    #     end
    #     binding.pry
    #   end
    #   click_link("Discussion")
    # end
    find(".fbReactComposerMoreButton").click
    first(".fbReactComposerAttachmentSelector_MEDIA").click
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    # binding.pry
    first("[style='outline: none; user-select: text; white-space: pre-wrap; overflow-wrap: break-word;']")
      .set(@apartment.descriptions(shared: shared))
    while page.has_css?("div[role='progressbar']", wait: 1) do
      sleep 1
      puts "G1 Photo Load"
    end
    sleep 1
    while page.has_css?("[data-testid='react-composer-post-button']:disabled")
      sleep 1
      puts "wait 1"
    end
    find("[data-testid='react-composer-post-button']").click
    while page.has_css?("[data-testid='react-composer-post-button']:disabled")
      sleep 1
      puts "wait 1"
    end
  end

  def post_to_ucla_housing_and_roommate_search(shared: false)
    visit "https://www.facebook.com/groups/1414484008814397/"
    find("html").send_keys(:escape)
    find(".fbReactComposerMoreButton").click
    first(".fbReactComposerAttachmentSelector_MEDIA").click
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    find("[style='outline: none; user-select: text; white-space: pre-wrap; overflow-wrap: break-word;']")
      .set(@apartment.descriptions(shared: shared))
    while page.has_css?("div[role='progressbar']", wait: 0) do
      sleep 1
    end
    while page.has_css?("[data-testid='react-composer-post-button']:disabled")
      sleep 1
      puts "wait 1"
    end
    find("[data-testid='react-composer-post-button']").click
    while page.has_css?("[data-testid='react-composer-post-button']:disabled")
      sleep 1
      puts "wait 1"
    end
  end

  def post_to_ucla_housing_rooms_apartments_sublets(shared: false)
    visit "https://www.facebook.com/groups/415336998925847/"
    find("html").send_keys(:escape)
    find("[name='xhpc_message_text']").set(@apartment.descriptions(unlinked: true, shared: shared))
    find("[data-tooltip-content='Photo/Video']").click
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    while page.has_css?("div[role='progressbar']", wait: 0) do
      sleep 1
      puts "progress 3"
    end
    while page.has_css?("[data-testid='react-composer-post-button']:disabled")
      sleep 1
      puts "wait 1"
    end
    find("[data-testid='react-composer-post-button']").click
    while page.has_css?("[data-testid='react-composer-post-button']:disabled")
      sleep 1
      puts "wait 1"
    end
  end

  def post_to_fb_marketplace(shared: false)
    visit('https://www.facebook.com/marketplace/selling/')
    find("html").send_keys(:escape)
    if @@posts <= 1
      within("div[role='main']") do
        while page.has_css?("span[role='progressbar']")
          sleep 1
          puts "waiting for main"
        end
      end
      postings = page.all('span', text: 'Manage')
      puts "there are #{postings.count} postings"
      postings.each_with_index do |posting, idx|
        puts "index:#{idx} of #{postings.count}"
        within("div[role='main']") do
          while page.has_css?("span[role='progressbar']")
            sleep 1
            puts "waiting for main"
          end
        end
        # binding.pry if idx > 0
        page.all('span', text: 'Manage')[0].click
        page.all('span', text: 'Delete Listing')[0].click
        click_button("Delete")
        visit('https://www.facebook.com/marketplace/selling/')
        find("html").send_keys(:escape)
      end
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
    within("div[data-testid='react-composer-root']") do
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
      find('textarea').set(@apartment.descriptions(shared: shared))
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
    sleep 1
    click_button("Publish")
    sleep 10
  end

  def fb(shared: false)
    Capybara.ignore_hidden_elements = false
    if @@posts <= 1
      visit "https://www.facebook.com/"
      fill_in("email", with: @credentials[:facebook][:username])
      fill_in("pass", with: @credentials[:facebook][:password])
      click_button("Log In")
    end
    post_to_ucla_off_campus_housing(shared: shared)
    post_to_ucla_housing_and_roommate_search(shared: shared)
    post_to_ucla_housing_rooms_apartments_sublets(shared: shared)
    post_to_fb_marketplace(shared: false)
    Capybara.ignore_hidden_elements = true
  end


  def post_everywhere(shared: false)
    craigslist(shared: shared)
    fb(shared: shared)
  end

end


Company.new.greystone_apartments.each do |apartment|
  Post.new(apartment).post_everywhere(shared: false)
end
