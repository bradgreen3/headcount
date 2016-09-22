require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'enrollment'
require_relative 'statewide_test_repository'
require_relative 'statewide_test'
require_relative 'economic_profile_repository'
require 'csv'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
    @enrollment_repository = EnrollmentRepository.new
    @statewide_test = StatewideTestRepository.new
    @economic_profile = EconomicProfileRepository.new
  end

  def load_data(hash, statewide_testing = nil)
    filename = hash[:enrollment][:kindergarten]
    contents = CSV.read filename, headers: true, header_converters: :symbol
    contents.each do |row|
      if find_by_name(row[:location]).nil?
        @districts[row[:location].upcase] = District.new({
          :name => row[:location].upcase})
      end
    end
    @enrollment_repository.load_data(hash)
    associater
    if hash[:statewide_testing]
      @statewide_test.load_data(hash)
      associater_statewide
    end
    if hash[:economic_profile]
      @economic_profile.load_data(hash)
      associater_economic
    end
  end

  def associater
    @districts.each do |name, instance|
      instance.enrollment = @enrollment_repository.find_by_name(name)
    end
  end

  def associater_statewide
    @districts.each do |name, instance|
      instance.statewide_test = @statewide_test.find_by_name(name)
    end
  end

  def associater_economic
    @districts.each do |name, instance|
      instance.economic_profile = @economic_profile.find_by_name(name)
    end
  end

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
  end

end
