require_relative 'district_repository'

class HeadcountAnalyst

  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(current, other)
    other = other.values[0]
    first = calculate_average(current)
    second = calculate_average(other)
    result = first / second
    return result
  end

  def calculate_average(name)
    contents = @dr.find_by_name(name.upcase).enrollment.kindergarten
    total = 0
    contents.each do |key, value|
      total += value
      end
    total = total / (contents.count)
    return total
  end

  def kindergarten_participation_rate_variation_trend(district, state)
    state = state.values[0]
    district_years = @dr.find_by_name(district.upcase).enrollment.kindergarten
    state_years = @dr.find_by_name(state.upcase).enrollment.kindergarten
    trend = state_years.merge(district_years) do |key, s_value, d_value|
      (d_value / s_value).to_s[0..4].to_f
      end
    return trend.sort.to_h
  end

  def kindergarten_participation_against_high_school_graduation(name)
    kindergarten_average = calculate_average(name)
      co_average_participation = calculate_average('Colorado')
      kindergarten_variation =  kindergarten_average / co_average_participation
    high_average = calculate_high_school_average(name)
      co_average_grad = calculate_high_school_average('Colorado')
      grad_var =  high_average / co_average_grad
      result = kindergarten_variation / grad_var
      result.to_s[0..4].to_f
  end

  def calculate_high_school_average(name)
    contents = @dr.find_by_name(name.upcase).enrollment.high_school_graduation
    total = 0
    contents.each do |key, value|
      total += value
      end
    total = total / (contents.count)
    return total
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    name = name.values[0]
    if name == "STATEWIDE"
      # binding.pry
      statewide_correlation
    end
    if kindergarten_participation_against_high_school_graduation(name) >= 0.6 && kindergarten_participation_against_high_school_graduation(name) <= 1.5
      return true
    else
      return false
    end
  end

  def statewide_correlation

    kindergarten_participation_against_high_school_graduation(names)

    end
    #name = statewide here, cannot do this method on statewide


  end



end
