require_relative 'district_repository'

class HeadcountAnalyst

  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(current, other)
    # require "pry"; binding.pry
    other = other.values[0]
    first = calculate_current_average(current)
    second = calculate_other_average(other)
    result = first / second
    return result
  end

  def calculate_current_average(current)
    contents = @dr.find_by_name(current.upcase).enrollment.kindergarten_participation
    total_current = 0
    contents.each do |key, value|
      total_current += value
      end
    total_current = total_current / (contents.count)
    return total_current
  end

  def calculate_other_average(other)
    contents = @dr.find_by_name(other.upcase).enrollment.kindergarten_participation
    total_other = 0
    contents.each do |key, value|
      total_other += value
      end
    total_other = total_other / (contents.count)
    return total_other
  end

  def kindergarten_participation_rate_variation_trend(district, state)
    state = state.values[0]

    district_years = @dr.find_by_name(district.upcase).enrollment.kindergarten_participation
    state_years = @dr.find_by_name(state.upcase).enrollment.kindergarten_participation

    trend = state_years.merge(district_years) do |key, s_value, d_value|
      (d_value / s_value).to_s[0..4].to_f
    end
    return trend.sort.to_h
  end

end
