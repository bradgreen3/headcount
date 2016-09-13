require  './lib/load'
require 'pry'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'

class LoadTest < Minitest::Test
  def test_it_can_load_a_csv_file
    l = Load.new
    l.load_file("./test/fixtures/kindergartners in full-day program.csv")

    assert_instance_of CSV, l.data
  end


end
