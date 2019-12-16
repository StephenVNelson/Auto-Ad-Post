require_relative 'Company'
# require './DataLoad.rb'

  class Building < Company

    attr_reader :name, :apartments, :ammenities, :city, :zip_code, :cross_street_1, :cross_street_2
    attr_accessor :company

    def initialize(name: "", apartments: [], ammenities: [], city: "", zip_code: "", company: nil, cross_street_1: "", cross_street_2: "")
      @name = name
      @apartments = apartments
      @ammenities = ammenities
      @city = city
      @zip_code = zip_code
      @company = company
      @cross_street_1 = cross_street_1
      @cross_street_2 = cross_street_2
    end

    def add_apartment(apartment)
      apartment.building = self
      @apartments << apartment
      apartment
    end

  end
