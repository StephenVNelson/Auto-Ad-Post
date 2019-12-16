require 'date'
require 'yaml'
require 'pry'
require_relative 'DataLoad'
# require_relative 'Building'
# require_relative 'Apartment'
class Company
  include DataLoad

  attr_accessor :app_fee, :holding_deposit, :buildings, :company_name

  def initialize(app_fee: 40, holding_deposit: 500, buildings: [], company_name: "Greystone")
    @company_name = company_name
    @app_fee = app_fee
    @holding_deposit = holding_deposit
    @buildings = buildings
  end

  def add_building(building)
    building.company = self
    @buildings << building
    building
  end

end
