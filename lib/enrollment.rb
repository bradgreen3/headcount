class Enrollment
  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

  # def district_enrollment
  #   @hash[:kindergarten_participation]
  #   # binding.pry
  # end

  def kindergarten_participation_by_year
     @hash[:kindergarten_participation].each do |key, value|
       @hash[:kindergarten_participation][key] = (value*1000).floor/1000.0
     end
  end

  def kindergarten_participation_in_year(year)
    find_year = @hash[:kindergarten_participation][year]
    (find_year*1000).floor/1000.0
  end

end
