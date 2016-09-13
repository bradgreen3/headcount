class District
  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

end
