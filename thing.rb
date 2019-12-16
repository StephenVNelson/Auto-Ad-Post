require 'yaml'
apartment_data = YAML.load(File.read("apartment_data.yaml"))

class Apartment

  attr_reader :posting_title, :city, :post_code, :description, :rent, :sqft, :date_available, :app_fees, :cross_street_1, :cross_street_2, :shared, :fb_description, :login, :password, :complex

  def initialize(complex: :strathmore, shared: false)
    @data = YAML.load(File.read("apartment_data.yaml"))[complex]
    @complex = complex
    # set_apartment(complex)
    # set_preferences
    @shared = shared
    @posting_title = set_posting_title
    @city = "Los Angeles"
    @post_code = "90024"
    @description = set_description
    @fb_description = set_fb_description
    @rent = set_rent
    @sqft = "450"
    @date_available = "Sun, 1 Dec 2019"
    @app_fees = "$40 app fee: background check, $500 holding deposit: reserve apartment"
    @cross_street_1 = "Strathmore"
    @cross_street_2 = "Veteran"
  end
  #
  # def set_apartment(apartment)
  #   case apartment
  #   when "Veteran"
  #     @posting_title = set_posting_title("Veteran")
  #   else
  #     # @posting_title =
  #   end
  # end



end
