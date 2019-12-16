require_relative 'Building'
require_relative 'Description'

class Apartment < Building
  include Description

 attr_reader :unit, :rent, :lease, :available, :sqft
 attr_accessor :building

 def initialize(unit: "", rent: 0, lease: "", available: Date.today, sqft: 0, building: nil)
   @unit = unit
   @rent = rent
   @lease = lease
   @available = available
   @sqft = sqft
   @building = building
 end

end
