require 'pry'
require 'csv'
require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/economic_profile'

class EconomicProfileTest < Minitest::Test

  def setup
    @epr = EconomicProfileRepository.new
    @epr.load_data({
        :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
          :children_in_poverty => "./data/School-aged children in poverty.csv",
          :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
          :title_i => "./data/Title I students.csv"
        }
      })
  end

  def test_data_returns_properly_for_each_file
    data = @epr.find_by_name("ACADEMY 20")
    ec = EconomicProfile.new(data)
    assert_equal ([[2005, 2009], 85060.0]) ,  ec.hash.median_household_income.first
    assert_equal ([1995, 0.032]),
    ec.hash.children_in_poverty.first
    assert_equal ([2014, {:total=>3132, :percentage=>0.12743}]),
    ec.hash.free_or_reduced_price_lunch.first
    assert_equal ([2009, 0.014]),
    ec.hash.title_i.first

  end

  def test_it_can_return_average_median_household_income_in_year
    economic_profile = @epr.find_by_name("ACADEMY 20")

    assert_equal 87056.0, economic_profile.median_household_income_in_year(2008)
    assert_raises UnknownDataError do economic_profile.median_household_income_in_year(2030)
    end
  end

  def test_it_can_return_median_household_income_average
    economic_profile = @epr.find_by_name("ACADEMY 20")

    assert_equal 87635.4, economic_profile.median_household_income_average
  end

  def test_it_can_return_children_in_poverty_by_year
    economic_profile = @epr.find_by_name("ACADEMY 20")

    assert_equal 0.042, economic_profile.children_in_poverty_in_year(2005)
    assert_raises UnknownDataError do economic_profile.children_in_poverty_in_year(2030)
    end
  end

  def test_it_can_return_reduced_price_lunch_percentage_by_year
    economic_profile = @epr.find_by_name("ACADEMY 20")

    assert_equal 0.0587, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2005)
    assert_raises UnknownDataError do economic_profile.free_or_reduced_price_lunch_percentage_in_year(2030)
    end
  end

  def test_it_can_return_free_or_reduced_lunch_number_in_year
    economic_profile = @epr.find_by_name("ACADEMY 20")

    assert_equal 1204, economic_profile.free_or_reduced_price_lunch_number_in_year(2005)
    assert_raises UnknownDataError do economic_profile.free_or_reduced_price_lunch_number_in_year(2030)
    end
  end

  def test_it_can_return_title_i_percent_in_year
    economic_profile = @epr.find_by_name("ACADEMY 20")

    assert_equal 0.01072, economic_profile.title_i_in_year(2012)
    assert_raises UnknownDataError do economic_profile.title_i_in_year(2005)
    end
  end


end
