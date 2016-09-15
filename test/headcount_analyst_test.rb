require_relative '../lib/headcount_analyst'
require_relative 'test_helper'


class HeadcountAnalystTest < Minitest::Test

  def test_can_instantiate_headcount_analyst_class
    ha = HeadcountAnalyst.new("blah")
    assert_instance_of HeadcountAnalyst , ha
  end

  def test_can_calculate_current_district_average
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.406 , ha.calculate_current_average('ACADEMY 20'), 0.005
  end

  def test_can_calculate_other_district_average
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.530, ha.calculate_other_average('COLORADO'), 0.005
  end

  def test_can_compare_district_participation_to_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.766 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO'), 0.005
  end

  def test_can_compare_district_participation_to_other_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.447 , ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end

  def test_can_show_participation_rate_trends_over_years
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ({2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }), ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end


end
