require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require 'csv'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
    @enrollment_repository = EnrollmentRepository.new
    @statewide_testing = StatewideRepository.new
  end

  def load_data(hash)
    filename = hash[:enrollment][:kindergarten]
    contents = CSV.read filename, headers: true, header_converters: :symbol
    contents.each do |row|
      if find_by_name(row[:location]).nil?
        @districts[row[:location].upcase] = District.new({:name => row[:location].upcase})
      end
    end
    @enrollment_repository.load_data(hash)
    associater
    @statewide_testing.load_data(hash)
    # binding.pry
    associater_statewide

  end

  def associater
    @districts.each do |name, instance|
      instance.enrollment = @enrollment_repository.find_by_name(name)
    end
  end

  def associater_statewide
    @districts.each do |name, instance|

      instance.statewide_testing = @statewide_testing.find_by_name(name)
    end
  end

  #need method to associate enrollments and districts
  #initialize enrollment repo above?

  #   @districts.each do |name, district|
  #     district.enrollment??  = @enrollments.find_by_name(name)
  #   end
  # end

  #then return this into the load file so it does it automatically?

  def find_by_name(name)
    name = name.upcase
    if @districts[name]
      @districts[name]
    else
      return nil
    end
  end

  def find_all_matching(input)
    @districts.select do |name, district|
      district if name.upcase.include?(input.upcase)
    end.values
    # binding.pry
  end

end
