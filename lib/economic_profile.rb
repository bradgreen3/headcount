require_relative 'error'
class EconomicProfile

YEARS = [2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013]
IYEARS = [2009, 2010, 2011, 2012, 2013, 2014]

  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

  def median_household_income
    @hash[:median_household_income]
  end

  def children_in_poverty
    @hash[:children_in_poverty]
  end

  def free_or_reduced_price_lunch
    @hash[:free_or_reduced_price_lunch]
  end

  def title_i
    @hash[:title_i]
  end

  def median_household_income_in_year(year)
    if YEARS.include?(year) == false
      raise UnknownDataError
    else
    fits_within = @hash[:median_household_income].keys.find_all {|key| year >= key[0] && year <= key[1]}
    sum = 0
    @hash[:median_household_income].each do |key, value|
      if fits_within.include?(key)
        sum += value
      end
    end
    sum / fits_within.count
  end
end

  def median_household_income_average
    sum = 0
    @hash[:median_household_income].each do |key, value|
        sum += value
    end
    sum / @hash[:median_household_income].count
  end

  def children_in_poverty_in_year(year)
    if YEARS.include?(year) == false
      raise UnknownDataError
    else
    @hash[:children_in_poverty][year]
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if YEARS.include?(year) == false
      raise UnknownDataError
    else
    @hash[:free_or_reduced_price_lunch][year][:percentage]
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if YEARS.include?(year) == false
      raise UnknownDataError
    else
    @hash[:free_or_reduced_price_lunch][year][:total]
    end
  end

  def title_i_in_year(year)
    if IYEARS.include?(year) == false
      raise UnknownDataError
    else
     @hash[:title_i][year]
    end
  end


end
