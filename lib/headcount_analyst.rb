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
    contents.inject(0) do |result, value|
      result += value[1]
      result
    end/contents.count
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
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
      kindergarten_participation_against_high_school_graduation(name) >= 0.6 &&
        kindergarten_participation_against_high_school_graduation(name) <= 1.5
      return true
    else
      return false
    end
  end

  def find_multi_correlations(name)
    all = []
    name.each  do |name|
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
    @weighting = hashes[:weighting]
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
    all.map do |name,data|
      data[:math].map do |year, num|
        if num == 0.0
          data[:math].delete(year)
        end
      end
      data[:writing].map do |year, num|
        if num == 0.0
          data[:writing].delete(year)
        end
      end
      data[:reading].map do |year, num|
        if num == 0.0
          data[:reading].delete(year)
        end
      end
    end
    # all = all.each do |name, data|
    #   data.map do |subject, stats|
    #     stats.sort_by {|key| key}
      # end
    # end
    # all
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
      leader = (all[key][@subject].values.last -
      all[key][@subject].values.first)/
      (all[key][@subject].keys.sort[-1] - all[key][@subject].keys.sort[0])
    end
    final = [winner[0], leader]
    end
  end

  def math_thing(data)
    (((data[@subject].values.last) - (data[@subject].values.first))/
    ((data[@subject].keys.sort[-1]) - (data[@subject].keys.sort[0]))).round(3)
  end

  def year_over_year_growth_multiple(all)
    winners = all.map do |name, data|
      next if data[@subject] == {}
      [name, math_thing(data)]
    end
    blah = []
    winners = winners[0..(@top-1)]
    winners.map do |winner|
      blah << winner[0]
    end
    leaders = []
    truncated = []
    winners.each do |key, value|
      leaders << ((all[key][@subject].values.last -
      all[key][@subject].values.first)/
      (all[key][@subject].keys.sort[-1] - all[key][@subject].keys.sort[0]))
    leaders.map do |num|
      truncated << num.round(3)
      end
    end
    blah.zip(truncated)
  end

  def check_for_error(hashes)
    if grade == nil
      raise InsufficientInformationError
      # "A grade must be provided to answer this question"
    elsif GRADES.include?(@grade) == false
      raise UnknownDataError
      # "#{@grade} is not a known grade."
    end
  end

  def across_all_subjects(all)
    m_lead = math_leader(all)
    w_lead = writing_leader(all)
    r_lead = reading_leader(all)
    if @weighting
      weighting_finder(m_lead, w_lead, r_lead)
    else
    m_lead.find_all {|key, value| r_lead.include?(key) == false}

    w_lead.find_all {|key, value| m_lead.include?(key) == false}
    # castaways = m_lead.find_all {|key, value| r_lead.include?(key) == false}.to_h
      # m_lead.each do |key, value|
      #   if castaways.include?(key)
      #     m_lead.delete(key)
      #   end
      # end

# binding.pry
      # castaways = m_lead.find_by {|key, value| w_lead.include?(key) == false}
      # w_lead.each do |key, value|
      #   if castaways.include?(key)
      #     w_lead.delete(key)
      #   end
      # end

    w_m = m_lead.merge!(w_lead) do |key, oldv, newv|
      oldv += newv
    end
    all_added_div = w_m.merge!(r_lead) do |key, oldv, newv|
      oldv += newv
      end
    sorted = all_added_div.sort_by(&:last).reverse

    answer = sorted[0]
    f = answer[1].round(3)
    answer[1] = f
    answer
    end
  end


  def weighting_finder(m_lead, w_lead, r_lead)
    m_lead.each do |key, value|
      m_lead[key] = value * (@weighting[:math])
    end
     w_lead.each do |key, value|
      w_lead[key] = value * (@weighting[:writing])
    end
    r_lead.each do |key, value|
      r_lead[key] = value * (@weighting[:reading])
    end
    w_m = w_lead.merge(m_lead){|key, oldv, newv| newv + oldv}
    all_added_div = w_m.merge(r_lead){|key, oldv, newv| (newv + oldv)}
    sorted = all_added_div.sort_by(&:last).reverse
    answer = sorted[0]
    f = answer[1].round(3)
    answer[1] = f
    answer
  end

  def math_leader(all)
    m_lead = {}
    all.each do |key,value|
      next if value[:math] == {}
      highest_year = value[:math].keys.sort[-1]
      lowest_year = value[:math].keys.sort[0]
      m_lead[key] = ((value[:math][highest_year] - value[:math][lowest_year])/
      (highest_year - lowest_year)).round(3)
    end
    m_lead = m_lead.select {|key, val| !val.nan?}
    no_nan_math = m_lead.sort_by(&:last).reverse.to_h
  end

  def writing_leader(all)
    w_lead = {}
    all.each do |key,value|
      next if value[:writing] == {}
      highest_year = value[:writing].keys.sort[-1]
      lowest_year = value[:writing].keys.sort[0]
      w_lead[key] = ((value[:writing][highest_year] -
      value[:writing][lowest_year])/
      (highest_year - lowest_year)).round(3)
      end
    w_lead = w_lead.select {|key, val| !val.nan?}
    no_nan_writing = w_lead.sort_by(&:last).reverse.to_h
  end

  def reading_leader(all)
    r_lead = {}
    all.each do |key,value|
      next if value[:reading] == {}
      highest_year = value[:reading].keys.sort[-1]
      lowest_year = value[:reading].keys.sort[0]
      r_lead[key] = ((value[:reading][highest_year] - value[:reading][lowest_year])/
      (highest_year - lowest_year)).round(3)
      end
    r_lead = r_lead.select {|key, val| !val.nan?}
    no_nan_reading = r_lead.sort_by(&:last).reverse.to_h
  end

end
