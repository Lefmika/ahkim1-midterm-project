require_relative 'room'

class CabanaRoom < Room
  BASE_RATE = 80.0
  RATE_PER_NIGHT = 40.0
  PEAK_MULTIPLIER = 1.5

  def cost
    (BASE_RATE + (@nights * RATE_PER_NIGHT)) * PEAK_MULTIPLIER
  end
end