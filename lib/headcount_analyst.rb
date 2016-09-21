require_relative 'district_repository'
require_relative 'error'

class HeadcountAnalyst
GRADES = [3,8]
SUBJECTS = [:math, :reading, :writing]

attr_reader :grade, :subject, :top

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

  def top_statewide_test_year_over_year_growth(hashes)
    @subject = hashes[:subject]
    @grade = hashes[:grade]
    @top = hashes[:top]
    check_for_error(hashes)
    return_data_by_grade
  end

  def return_data_by_grade
    if @grade == 3
      grade = :third_grade
    elsif @grade == 8
      grade = :eighth_grade
    end
    all = {}
    @dr.districts.each do |key, value|
      all[key] = @dr.find_by_name(key).statewide_test.hash[grade]
      all
    end
    if @subject == nil
      across_all_subjects(all)
    else
      year_over_year_growth(all)
    end
  end

  def year_over_year_growth(all)
    if @top
      year_over_year_growth_multiple(all)
    else
    leader = 0
    winner = all.max_by do |key,value|
      leader =  all[key][@subject][2014] - all[key][@subject][2008] / (2014 - 2008)
    end
    final = [winner[0], leader]
    end
  end

  def year_over_year_growth_multiple(all)
    winners = all.sort_by do |key, value|
      all[key][@subject][2014] - all[key][@subject][2008] / (2014 - 2008)
    end.reverse
    blah = []
    winners = winners[0..(@top-1)]
    winners.map do |winner|
      blah << winner[0]
    end
    leaders = []
    truncated = []
    winners.each do |key, value|
      leaders << all[key][@subject][2014] - all[key][@subject][2008] / (2014 - 2008)
    leaders.map do |num|
      truncated << num.round(3)
      end
    end
    blah.zip(truncated)
  end

  def check_for_error(hashes)
    if grade == nil
      raise InsufficientInformationError
    elsif GRADES.include?(@grade) == false
      raise UnknownDataError
    end
  end

  def across_all_subjects(all)
    m_leader = {}
    winner = all.each do |key,value|
      m_leader[key] = (all[key][:math][2014] - all[key][:math][2008] / (2014 - 2008))
    end
    m_leader.sort_by(&:last).reverse
    w_leader = {}
    winner = all.max_by do |key,value|
      w_leader[key] = all[key][:writing][2014] - all[key][:writing][2008] / (2014 - 2008)
    end
    w_leader.sort_by(&:last).reverse
    r_leader = {}
    winner = all.max_by do |key,value|
      r_leader[key] = all[key][:reading][2014] - all[key][:reading][2008] / (2014 - 2008)
    end
    r_leader.sort_by(&:last).reverse
    w_m_combined = w_leader.merge(m_leader){|key, oldval, newval| newval + oldval}
    all_combined_and_divided = w_m_combined.merge(r_leader){|key, oldval, newval| (newval + oldval) / 3}
    sorted = all_combined_and_divided.sort_by(&:last).reverse
    sorted[0]
  end

end
