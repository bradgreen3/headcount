require_relative '../lib/headcount_analyst'
require_relative 'test_helper'


class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv",
  },
  :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  }
})
  end

  def test_can_instantiate_headcount_analyst_class
    ha = HeadcountAnalyst.new("blah")
    assert_instance_of HeadcountAnalyst , ha
  end

  def test_can_calculate_district_average
    ha = HeadcountAnalyst.new(@dr)
    assert_in_delta 0.530, ha.calculate_average('COLORADO'), 0.005
  end

  def test_can_compare_district_participation_to_state
    ha = HeadcountAnalyst.new(@dr)
    assert_in_delta 0.766 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO'), 0.005
  end

  def test_can_compare_district_participation_to_other_district
    ha = HeadcountAnalyst.new(@dr)
    assert_in_delta 0.447 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end

  def test_can_show_participation_rate_trends_over_years
    ha = HeadcountAnalyst.new(@dr)
    assert_equal ({2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }), ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_it_can_compare_high_school_graduation_to_kindergarten_participation_rates
    ha = HeadcountAnalyst.new(@dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_correlation_returns_true_or_false
    ha = HeadcountAnalyst.new(@dr)

    assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_correlation_returns_true_or_false_against_state
    ha = HeadcountAnalyst.new(@dr)

    assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_correlation_returns_true_or_false_against_multiple_districcts
    ha = HeadcountAnalyst.new(@dr)

    assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(
  :across => ['ACADEMY 20', 'ADAMS COUNTY 14', 'AGATE 300', 'BENNETT 29J'])
  end

  def test_it_can_return_top_statewide_test_year_over_year_growth
    ha = HeadcountAnalyst.new(@dr)
    assert_equal ["SPRINGFIELD RE-4", 0.46315] ,  ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_it_can_return_top_statewide_test_year_over_year_growth
    ha = HeadcountAnalyst.new(@dr)
    assert_equal [["SPRINGFIELD RE-4", 0.895], ["MANCOS RE-6", 0.895], ["FOWLER R-4J", 0.845]] ,  ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
  end

  def test_year_over_year_growth_across_multiple_subjects
    ha = HeadcountAnalyst.new(@dr)
    assert_equal ["SWINK 33", 0.81353] ,  ha.top_statewide_test_year_over_year_growth(grade: 3)
  end


end
