require_relative 'Mamel'

class Dog < Mamel

  attr_reader :bark
  attr_accessor :mamel

  def initialize(bark: false, mamel: nil)
    @mamel = mamel
    @bark = bark
    # super({fur: fur, legs: legs})
  end

end

m = Mamel.new(legs: 8)
puts m.add_dog.mamel.legs
