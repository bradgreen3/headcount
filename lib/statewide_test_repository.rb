require 'csv'
require_relative 'statewide_test'

class StatewideRepository

  attr_reader :statewide_testing

  def initialize
    @statewide_testing = {}
  end

  def load_data(hash)
    if hash != hash.empty?
    create_statewide_repo(hash)
    end
  end

  def create_statewide_repo(hash)
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
    # find_by_name(row[:location].upcase).send(symbol.to_s,  row[2].to_i)[row[:score].downcase.to_sym] = row[:data].to_f
    find_by_name(row[:location].upcase).send(symbol.to_s,  row[1].to_s.downcase.gsub("hawaiian/", "").tr(" ", "_").to_sym)[row[:timeframe].to_i] = row[:data].to_f
  end

  def create_statewide_instance(symbol, row)
    @statewide_testing[row[:location].upcase] = Statewide.new({:name => row[:location].upcase,
      :third_grade => {:math => {}, :reading => {}, :writing => {} },
      :eighth_grade => {:math => {}, :reading => {}, :writing => {} },
      :math => {:all_students => {}, :asian => {}, :black => {}, :pacific_islander => {}, :hispanic => {}, :native_american => {}, :two_or_more => {}, :white => {}},
      :reading => {:all_students => {}, :asian => {}, :black => {}, :pacific_islander => {}, :hispanic => {}, :native_american => {}, :two_or_more => {}, :white => {}},
      :writing => {:all_students => {}, :asian => {}, :black => {}, :pacific_islander => {}, :hispanic => {}, :native_american => {}, :two_or_more => {}, :white => {}}
      })

  end
        # @statewide_testing[row[:location].upcase] = Statewide.new({:name => row[:location].upcase, :third_grade => {:math => {row[:timeframe].to_i => row[:data].to_f}, :reading => {row[:timeframe].to_i => row[:data].to_f}, :writing => {row[:timeframe].to_i => row[:data].to_f}}, :eighth_grade => {}, :math => {}, :reading => {}, :writing => {}})
        # @statewide_testing[row[:location].upcase] = Statewide.new({:name => row[:location].upcase, :third_grade => {row[:timeframe].to_i =>{:math => {}, :reading => {}, :writing => {}}}, :eighth_grade => {}, :math => {}, :reading => {}, :writing => {}})
        # third_grade: {math: {row[:timeframe].to_i] => row[:data]}, reading: {row[:timeframe].to_i => row[:data]}, writing: {row[:timeframe].to_i => row[:data]}}
      # end
      # @statewide_testing[row[:location].upcase].send(symbol.to_s)[row[:timeframe].to_i] = row[:data].to_f
      # if @statewide_testing[row[:location].value == [row[:third_grade]]

      #if math hash within timeframe hash within third_grade is empty,

      # @statewide_testing[row[:location].upcase].send(:third_grade_math)[row[:timeframe].to_i] = row[:data].to_f
      # @statewide_testing[row[:third_grade]].send(:third_grade_math)[row[:timeframe].to_i] = row[:data].to_f

      # @statewide_testing[row[:location].upcase].send(:third_grade)[row[:reading].to_i] = row[:data].to_f
      # @statewide_testing[row[:location].upcase].send(:third_grade)[row[:writing].to_i] = row[:data].to_f
      # binding.pry
  #   end
  #   end
  # end

  def find_by_name(name)
    if @statewide_testing[name]
       @statewide_testing[name]
    else
      return nil
    end
  end


end
