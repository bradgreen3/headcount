class District
  attr_accessor :enrollment,  :statewide_testing
  def initialize(hash)
    @hash = hash
    @enrollment = nil
    @statewide_testing = nil
  end

  def name
    @hash[:name]
  end

end
