# require './Company.rb'
# require_relative 'Building.rb'

module DataLoad
  APARTMENT_DATA = YAML.load(File.read("apartment_data.yaml"))
  # puts APARTMENT_DATA

  def greystone_properties
    greystone = Company.new
    APARTMENT_DATA.each do |company,details|
      details[:buildings].each do |building|
        new_building = Building.new(
          name: building[:name],
          amenities: building[:amenities],
          city: building[:city],
          state: building[:state],
          zip_code: building[:zip_code],
          cross_street_1: building[:cross_street_1],
          cross_street_2: building[:cross_street_2],
          close_to: building[:close_to],
          distance_to_UCLA: building[:distance_to_UCLA],
          address: building[:address]
          )
        building[:apartments].each do |apartment|
          new_apartment = Apartment.new(
            unit: apartment[:unit],
            rent: apartment[:rent],
            lease: apartment[:lease],
            available: apartment[:available],
            sqft: apartment[:sqft],
            bedrooms: apartment[:bedrooms]
          )
          new_building.add_apartment(new_apartment)
        end
        greystone.add_building(new_building)
      end
    end
    greystone
  end

  def greystone_apartments
    apartments = []
    greystone_properties.buildings.each do |building|
      apartments << building.apartments.sample unless building.apartments.empty?
    end
    apartments
  end


end
