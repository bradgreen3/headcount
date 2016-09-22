require 'csv'
require_relative 'statewide_test'
require_relative 'statewide_test_repository'

class StatewideTestRepository
  attr_reader :statewide_test

  def initialize
    @statewide_test = {}
  end

  def load_data(hash)
    create_statewide_repo(hash)
  end

  def create_statewide_repo(hash, statewide_testing = nil)
    hash[:statewide_testing].each do |symbol, filename|
      contents = CSV.read filename, headers: true, header_converters: :symbol
        contents.each do |row|
          check_for_existing_instance(symbol, row)
      end
    end
  end

  def check_for_existing_instance(symbol, row)
    if find_by_name(row[:location].upcase).nil?
      create_statewide_instance(symbol, row)
    end
    find_by_name(row[:location].upcase).send(symbol.to_s, row[1].to_s.
      downcase.gsub("hawaiian/", "").
      tr(" ", "_").to_sym)[row[:timeframe].to_i] =
      row[:data].to_f
  end

  def create_statewide_instance(symbol, row)
    @statewide_test[row[:location].upcase] = StatewideTest.new({
      :name => row[:location].upcase,
      :third_grade => {:math => {}, :reading => {}, :writing => {} },
      :eighth_grade => {:math => {}, :reading => {}, :writing => {} },
      :math => {:all_students => {}, :asian => {}, :black => {},
      :pacific_islander => {}, :hispanic => {}, :native_american => {},
      :two_or_more => {}, :white => {}},
      :reading => {:all_students => {}, :asian => {}, :black => {},
      :pacific_islander => {}, :hispanic => {}, :native_american => {},
      :two_or_more => {}, :white => {}},
      :writing => {:all_students => {}, :asian => {}, :black => {},
      :pacific_islander => {}, :hispanic => {}, :native_american => {},
      :two_or_more => {}, :white => {}}
      })
  end

  def find_by_name(name)
    if @statewide_test[name]
       @statewide_test[name]
    else
      return nil
    end
  end

end
