class Enrollment
  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

  def kindergarten_participation
    @hash[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @hash[:kindergarten_participation].each do |key, value|
      @hash[:kindergarten_participation][key] = three_digiter(value)
    end
 end

 def kindergarten_participation_in_year(year)
    find_year = @hash[:kindergarten_participation][year]
    three_digiter(find_year)
  end

  def three_digiter(var)
    var = (var*1000).floor/1000.0
    var
  end

end
