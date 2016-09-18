require_relative './enrollment_repository'

class District
  attr_accessor :enrollment,  :statewide_test

  def initialize(hash, district_repository = nil, statewide_testing = nil)
    @hash = hash
    @enrollment = nil
    @statewide_test = nil
  end

  def name
    @hash[:name]
  end

  def statewide_test
    @hash[:name]
  end

end
