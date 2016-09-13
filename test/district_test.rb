require_relative  '../lib/district'
require 'pry'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'

class DistrictTest < Minitest::Test
  def test_it_can_receive_and_output_a_name
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name 
  end

end
