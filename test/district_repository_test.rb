require 'pry'
require 'csv'
require_relative 'test_helper'
require_relative '../lib/district_repository'


class DistrictRepositoryTest < Minitest::Test

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
        }})

  end

  def test_it_can_load_and_find_by_name
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_it_can_find_all_matching
    assert_equal 2, @dr.find_all_matching("Adam").length
    assert_equal 0, @dr.find_all_matching("blah").length
    assert_equal [], @dr.find_all_matching("blah")
  end

  def test_it_returns_nil_when_district_not_there_in_find_by_name
    enrollment = @dr.find_by_name("ACA 20")
    assert_equal nil, @dr.find_by_name("ACA 20")
  end

  def test_district_repo_accepts_enrollment_repo_data
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal 0.436 , district.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_district_repo_accepts_statewide_repo_data
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal 0.713, district.statewide_test.proficient_for_subject_by_race_in_year(:math, :white, 2012)
  end

  def test_district_repo_accepts_economic_profile_repo_data
    dr = DistrictRepository.new
    dr.load_data({
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
        },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
        }})

    district = dr.find_by_name("ACADEMY 20")
    assert_equal 87056.0, district.economic_profile.median_household_income_in_year(2008)
  end



end
