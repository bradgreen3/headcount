require_relative './enrollment_repository'

class District
  attr_accessor :enrollment,  :statewide_test, :economic_profile

  def initialize(hash)
    @hash = hash
    # @enrollment = nil
    # @statewide_test = nil
  end

  def name
    @hash[:name]
  end

  # def statewide_test
  #   @hash[:name]
  # end

end
