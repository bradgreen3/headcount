class Enrollment
  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

  def kindergarten
    @hash[:kindergarten_participation]
  end

  def high_school_graduation
    @hash[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    @hash[:kindergarten_participation].each do |key, value|
      @hash[:kindergarten_participation][key] = three_digiter(value)
    end
 end

 def kindergarten_participation_in_year(year)
  #  binding.pry
    find_year = @hash[:kindergarten_participation][year]
    three_digiter(find_year)
  end

  def three_digiter(var)
    var = (var*1000).floor/1000.0
    var
  end

  def graduation_rate_by_year
    @hash[:high_school_graduation].each do |key, value|
      @hash[:high_school_graduation][key] = three_digiter(value)
    end
  end

  def graduation_rate_in_year(year)
    grad_year = @hash[:high_school_graduation][year]
    three_digiter(grad_year)
  end

end
