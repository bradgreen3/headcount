require_relative 'economic_profile'
require 'csv'

class EconomicProfileRepository

  attr_reader :economic_profile_repo

  def initialize
    @economic_profile_repo = {}
  end

  def load_data(hash)
    create_economic_profile_repo(hash)
  end

  def create_economic_profile_repo(hash)
    hash[:economic_profile].each do |symbol, filename|
      contents = CSV.read filename, headers: true, header_converters: :symbol
      contents.each do |row|
        check_for_existing_economic_instance(symbol, row)
      end
    end
  end

  def check_for_existing_economic_instance(symbol, row)
    if find_by_name(row[:location].upcase).nil?
      create_statewide_economic_instance(symbol, row)
    end
    if symbol == :median_household_income
      find_by_name(row[:location].upcase).
        send(symbol.to_s)[row[:timeframe].
        split("-").map(&:to_i)] = row[:data].to_f
    end
    if symbol == :children_in_poverty && row[:dataformat] == "Percent"
      find_by_name(row[:location].upcase).
        send(symbol.to_s)[row[:timeframe].to_i] = row[:data].to_f
    end
    if symbol == :free_or_reduced_price_lunch &&
        row[:poverty_level] == "Eligible for Free or Reduced Lunch"
      a = find_by_name(row[:location].upcase).
        send(symbol.to_s)[row[:timeframe].to_i] ||= {}
      if row[:dataformat] == "Percent"
        a[:percentage] = row[:data].to_f
      elsif row[:dataformat] == "Number"
        a[:total] = row[:data].to_i
        end
      end
    if symbol == :title_i
      find_by_name(row[:location].upcase).
        send(symbol.to_s)[row[:timeframe].to_i] = row[:data].to_f
    end

  end

  def create_statewide_economic_instance(symbol, row)
    @economic_profile_repo[row[:location].upcase] = EconomicProfile.new(
        {:median_household_income => {} ,
        :children_in_poverty => {},
        :free_or_reduced_price_lunch => {},
        :title_i => {},
        :name => row[:location].upcase })
  end

  def find_by_name(name)
    if @economic_profile_repo[name]
       @economic_profile_repo[name]
    else
      return nil
    end
  end

end
