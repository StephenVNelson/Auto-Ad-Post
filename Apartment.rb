require_relative 'Building'
require_relative 'Description'

class Apartment < Building
  include Description

  attr_reader :unit, :rent, :lease, :sqft, :bedrooms, :roommate_groups
  attr_accessor :building, :available

  def initialize(unit: "", rent: 0, lease: "", available: Date.today, sqft: 0, building: nil, bedrooms: 0, roommate_groups: [])
    @unit = unit
    @rent = rent
    @lease = lease
    @available = available
    @sqft = sqft
    @building = building
    @bedrooms = bedrooms
    @roommate_groups = roommate_groups
  end

  def max_tenants
    (@bedrooms * 2) + 1
  end

  def add_roommate_group(group)
    group.apartment = self
    @roommate_groups << group
    group
  end

end
