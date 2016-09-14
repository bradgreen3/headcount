require 'pry'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_can_load_and_find_by_name
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_it_can_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    assert_equal 2, dr.find_all_matching("Adam").length
    assert_equal 0, dr.find_all_matching("blah").length
  end

  def test_it_returns_nil_when_district_not_there
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    # enrollment = er.find_by_name("ACA 20")

    assert_equal nil, dr.find_by_name("ACA 20")
  end


end
