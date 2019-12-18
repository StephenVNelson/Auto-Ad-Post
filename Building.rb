require_relative 'Company'
# require './DataLoad.rb'

  class Building < Company

    attr_reader :name, :apartments, :ammenities, :city, :zip_code, :cross_street_1, :cross_street_2, :close_to, :distance_to_UCLA
    attr_accessor :company

    def initialize(name: "", apartments: [], ammenities: [], city: "", zip_code: "", company: nil, cross_street_1: "", cross_street_2: "", close_to: "", distance_to_UCLA: "")
      @name = name
      @apartments = apartments
      @ammenities = ammenities
      @city = city
      @zip_code = zip_code
      @company = company
      @cross_street_1 = cross_street_1
      @cross_street_2 = cross_street_2
      @close_to = close_to
      @distance_to_UCLA = distance_to_UCLA
    end

    def add_apartment(apartment)
      apartment.building = self
      @apartments << apartment
      apartment
    end

  end
