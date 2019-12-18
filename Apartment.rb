require_relative 'Building'
require_relative 'Description'

class Apartment < Building
  include Description

 attr_reader :unit, :rent, :lease, :available, :sqft, :bedrooms
 attr_accessor :building

 def initialize(unit: "", rent: 0, lease: "", available: Date.today, sqft: 0, building: nil, bedrooms: 0)
   @unit = unit
   @rent = rent
   @lease = lease
   @available = available
   @sqft = sqft
   @building = building
   @bedrooms = bedrooms
 end

 def max_tenants
    (@bedrooms * 2) + 1
 end

end
