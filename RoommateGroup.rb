require_relative 'Apartment'

class RoommateGroup < Apartment

  attr_reader :roommate_high, :roommate_low, :move_in_start, :move_in_end
  attr_accessor :apartment, :prospects

  def initialize(apartment: nil, roommate_high: 0, roommate_low: 0, prospects: [], move_in_start: Date.today, move_in_end: (Date.today + 1))
    @apartment = apartment
    @roommate_high = roommate_high
    @roommate_low = roommate_low
    @move_in_start = move_in_start
    @move_in_end = move_in_end
    @prospects = prospects
  end

  def add_prospect(prospect)
    prospect.roommate_group = self
    @prospects << prospect
    prospect
  end

end
