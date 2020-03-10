require_relative 'RoommateGroup'

class Prospect < RoommateGroup

  attr_reader :sex, :name
  attr_accessor :roommate_group

  def initialize(name: '', sex: '', roommate_group: nil)
    @roommate_group = roommate_group
    @name = name
    @sex = sex
  end

end
