module DataLoad
  APARTMENT_DATA = YAML.load(File.read("apartment_data.yaml"))[:companies]
  
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
          if apartment[:roommate_groups]
            apartment[:roommate_groups].each do |group|
              new_group = RoommateGroup.new(
                roommate_high: group[:roommate_high],
                roommate_low: group[:roommate_low],
                move_in_start: group[:move_in_start],
                move_in_end: group[:move_in_end]
              )
              if group[:prospects]
                group[:prospects].each do |prospect|
                  new_prospect = Prospect.new(
                    name: prospect[:name],
                    sex: prospect[:sex]
                  )
                  new_group.add_prospect(new_prospect)
                end
              end
              new_apartment.add_roommate_group(new_group)
            end
          end
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
      apartments << building.apartment_weighted_sample unless building.apartments.empty?
    end
    apartments
  end


end
