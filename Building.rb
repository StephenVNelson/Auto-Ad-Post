require_relative 'Company'
# require './DataLoad.rb'

  class Building < Company

    attr_reader :name, :apartments, :amenities, :city, :zip_code, :cross_street_1, :cross_street_2, :close_to, :distance_to_UCLA, :state, :address
    attr_accessor :company

    def initialize(name: "", apartments: [], amenities: [], city: "", zip_code: "", company: nil, cross_street_1: "", cross_street_2: "", close_to: "", distance_to_UCLA: "", state: "", address: "")
      @name = name
      @apartments = apartments
      @amenities = amenities
      @city = city
      @state = state
      @zip_code = zip_code
      @company = company
      @cross_street_1 = cross_street_1
      @cross_street_2 = cross_street_2
      @close_to = close_to
      @distance_to_UCLA = distance_to_UCLA
      @address = address
    end

    def add_apartment(apartment)
      apartment.building = self
      @apartments << apartment
      apartment
    end

  end
