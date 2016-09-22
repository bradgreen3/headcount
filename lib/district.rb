require_relative './enrollment_repository'

class District
  attr_accessor :enrollment,  :statewide_test, :economic_profile

  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

end
