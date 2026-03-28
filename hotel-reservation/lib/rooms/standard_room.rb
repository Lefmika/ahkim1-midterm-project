require_relative 'room'

class StandardRoom < Room
  BASE_RATE = 80.0
  RATE_PER_NIGHT = 40.0

  def cost
    BASE_RATE + (@nights * RATE_PER_NIGHT)
  end
end