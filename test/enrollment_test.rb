require 'pry'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test
  def test_can_hold_a_name
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal "ACADEMY 20" , e.name
  end

  # def test_can_hold_participation_hash
  #   e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  #   assert_equal ({2010=>0.3915, 2011=>0.35356, 2012=>0.2677}), e.district_enrollment
  # end

  def test_can_return_participation_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal ({2010 => 0.391, 2011 => 0.353, 2012 => 0.267}), e.kindergarten_participation_by_year
  end

  def test_can_return_participation_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end


end
