class Mamel

  attr_reader :fur, :legs, :dogs

  def initialize(fur: false, legs: 2)
    @fur = fur
    @legs = legs
    @dogs = []
  end

  def add_dog
    new_dog = Dog.new(mamel: self)
    @dogs << new_dog
    new_dog
  end

end
