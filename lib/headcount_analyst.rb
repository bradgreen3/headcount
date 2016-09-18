require_relative 'district_repository'

class HeadcountAnalyst

  # attr_reader :enrollment, :districts

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
    contents.each {|key, value| total += value}
    #added shortened version of each
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
    #separate colorado variation from district? then we can just divide these
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
    # name = name.values[0]
    #separate out if statewide vs something else
    # find kinder part against if key = :for
    # if key is false, move to statewide
  # binding.pry
    name1 = name.keys[0]
    name2 = name.values[0]
    if name1 == :for && name2 == "STATEWIDE"
    statewide_correlation
    elsif name1 == :for && name2 != "STATEWIDE"
      find_correlation_window(name2)
    else name1 == :across
      find_multi_correlations(name2)
    end
  end

  def find_correlation_window(name)
    if
      kindergarten_participation_against_high_school_graduation(name) >= 0.6 && kindergarten_participation_against_high_school_graduation(name) <= 1.5
      return true
    else
      return false
    end
  end

  def find_multi_correlations(name)
    all = []
      # binding.pry
    name.each do |name|
      all << kindergarten_participation_against_high_school_graduation(name)
      all
      end
    result = []
    all.each do |num|
      if num >= 0.6 and num <= 1.5
        result << num
        end
      end
    if result.count / all.count >= 0.7
      return true
    else
      return false
    end
  end


  def statewide_correlation
    all = []
    @dr.districts.keys.each do |key|
       all << kindergarten_participation_against_high_school_graduation(key)
    end
    all_correlations = all.count {|x| x >= 0.6 && x <= 1.5}
    result = all_correlations.to_f / all.count.to_f
    if result > 0.7
      return true
    else
      return false
    end
  end

    #name = statewide here, cannot do this method on statewide






end
