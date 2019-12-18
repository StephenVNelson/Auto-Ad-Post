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
    end
    within(:css, "form.new_posting_thing") do
      click_button('go')
    end
    choose('westside-southbay-310')
    choose('housing offered')
    shared ? find(:css, '[value="18"]').click : find(:css, '[value="1"]').click
    # find(:css, '[value="1"]').click
    fill_in("PostingTitle", with: @apartment.titles(shared: shared))
    fill_in("GeographicArea", with: @apartment.building.city)
    fill_in("postal", with: @apartment.building.zip_code)
    fill_in("PostingBody", with: @apartment.descriptions(shared: shared))
    fill_in("price", with: @apartment.rent)
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
    find(".fbReactComposerMoreButton").click
    first(".fbReactComposerAttachmentSelector_MEDIA").click
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    find("[style='outline: none; user-select: text; white-space: pre-wrap; overflow-wrap: break-word;']")
      .set(@apartment.descriptions(shared: shared))
    sleep 5
    find("[data-testid='react-composer-post-button']").click
    sleep 5
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
    sleep 5
    find("[data-testid='react-composer-post-button']").click
    sleep 10
  end

  def post_to_ucla_housing_rooms_apartments_sublets(shared: false)
    visit "https://www.facebook.com/groups/415336998925847/"
    find("html").send_keys(:escape)
    find("[name='xhpc_message_text']").set(@apartment.descriptions(unlinked: true, shared: shared))
    find("[data-tooltip-content='Photo/Video']").click
    Dir.entries("./Photos/#{@apartment.building.name}").each do |file|
      attach_file("composer_photo", Dir.pwd + "/Photos/#{@apartment.building.name}/#{file}") if file.match(/^[^.]/)
    end
    sleep 8
    find("[data-testid='react-composer-post-button']").click
    sleep 8
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
    Capybara.ignore_hidden_elements = true
  end


  def post_everywhere(shared: false)
    craigslist(shared: shared)
    fb(shared: shared)
  end

end


Company.new.greystone_apartments.each do |apartment|
  Post.new(apartment).post_everywhere(shared: true)
end
# apartment = Company.new.greystone_apartments[1]
# binding.pry
# Post.new(apartment).post_everywhere(shared: true)


# apartment = Apartment.new(complex: "Strathmore", shared: false)
# PostIt.new(apartment)
#   .craigslist
#   .fb
