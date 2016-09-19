require 'pry'
require 'csv'
require_relative 'test_helper'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'

class StatewideTestTest < Minitest::Test

  def setup
    @str = StatewideTestRepository.new
    @str.load_data({:statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_it_can_return_data_of_third_grade
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_equal (
        {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
         2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
         2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
         2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
         2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
         2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
         2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}}),  statewide_test.proficient_by_grade(3)
  end

  def test_it_can_return_data_of_eighth_grade
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_equal (
        {2008 => {:math => 0.64, :reading => 0.843, :writing => 0.734},
         2009 => {:math => 0.656, :reading => 0.825, :writing => 0.701},
         2010 => {:math => 0.672, :reading => 0.863, :writing => 0.754},
         2011 => {:math => 0.653, :reading => 0.832, :writing => 0.745},
         2012 => {:math => 0.681, :reading => 0.833, :writing => 0.738},
         2013 => {:math => 0.661, :reading => 0.852, :writing => 0.75},
         2014 => {:math => 0.684, :reading => 0.827, :writing => 0.747}}),  statewide_test.proficient_by_grade(8)
  end

  def test_it_returns_unknown_data_error_if_other_grade
    statewide_test = @str.find_by_name("ACADEMY 20")
    assert_raises (UnknownDataError) do
      statewide_test.proficient_by_grade(4)
     end
  end

  def test_it_can_return_proficiency_based_on_race
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_equal (
        {2011 => {:math => 0.816, :reading => 0.897, :writing => 0.826},
         2012 => {:math => 0.818, :reading => 0.893, :writing => 0.808},
         2013 => {:math => 0.805, :reading => 0.901, :writing => 0.810},
         2014 => {:math => 0.800, :reading => 0.855, :writing => 0.789}}),  statewide_test.proficient_by_race_or_ethnicity(:asian)
  end

  def test_it_will_return_error_if_race_unknown

    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_raises (UnknownRaceError) do statewide_test.proficient_by_race_or_ethnicity(:blue)
    end
  end

  def test_it_can_return_proficiency_based_on_subject_and_year
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_equal 0.857, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_it_will_return_error_if_subject_unknown
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_raises (UnknownDataError) do statewide_test.proficient_for_subject_by_grade_in_year(:science, 3, 2008)
    end
  end

  def test_it_will_return_error_if_year_unknown

    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_raises (UnknownDataError) do statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2016)
    end
  end

  def test_it_will_return_error_if_grade_unknown
    statewide_test = @str.find_by_name("ACADEMY 20")
    assert_raises (UnknownDataError) do statewide_test.proficient_for_subject_by_grade_in_year(:math, 7, 2008)
    end
  end

  def test_it_can_return_proficiency_based_on_race
    statewide_test = @str.find_by_name("ACADEMY 20")

   assert_equal 0.818, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

  def test_it_will_return_error_if_subject_unknown
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_raises (UnknownDataError) do statewide_test.proficient_for_subject_by_race_in_year(:science, :white, 2008)
    end
  end

  def test_it_will_return_error_if_race_unknown
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_raises (UnknownDataError) do statewide_test.proficient_for_subject_by_race_in_year(:math, :blue, 2008)
    end
  end

  def test_it_will_return_error_if_year_unknown
    statewide_test = @str.find_by_name("ACADEMY 20")

    assert_raises (UnknownDataError) do statewide_test.proficient_for_subject_by_race_in_year(:math, :white, 2016)
    end
  end



end
