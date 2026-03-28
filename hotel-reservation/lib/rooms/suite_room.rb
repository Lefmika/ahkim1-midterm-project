require_relative 'room'

class SuiteRoom < Room
  BASE_RATE = 80.0
  RATE_PER_NIGHT = 40.0
  SUITE_FEE = 75.0

  def cost
    BASE_RATE + (@nights * RATE_PER_NIGHT) + SUITE_FEE
  end
end