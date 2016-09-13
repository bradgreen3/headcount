require_relative 'district'
require 'csv'

class DistrictRepository
  def initialize
    @districts = {}
  end

  def load_data(hash)
    filename = hash[:enrollment][:kindergarten]
    contents = CSV.read filename, headers: true, header_converters: :symbol
    contents.each do |row|
      if find_by_name(row[:location]).nil?
        @districts[row[:location]] = District.new({:name => row[:location]})
      end
    end
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(input)
    @districts.select do |name, district|
      district if name.upcase.include?(input.upcase)
    end.values
    # binding.pry
  end

end
