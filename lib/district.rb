class District
  attr_accessor :enrollment
  def initialize(hash)
    @hash = hash
    @enrollment = nil
  end

  def name
    @hash[:name]
  end

end
