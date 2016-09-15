require 'pry'
require_relative 'enrollment'

class EnrollmentRepository
  def initialize
    @enrollments = {}
  end

  def load_data(hash)
    #iterate over given hash
    # data[:en].each do |sym, filename|
    #def load kind data
    # contents.each do |row|
    #   @en = row, location, +. enrollment.new

    # filename = hash[:enrollment][:kindergarten]
    # fileneme = hash[:enrollment][:high_school_graduation]
    hash[:enrollment].each do |symbol, filename|
      contents = CSV.read filename, headers: true, header_converters: :symbol
      contents.each do |row|
      if find_by_name(row[:location].upcase).nil?
        @enrollments[row[:location].upcase] = Enrollment.new({:name => row[:location].upcase, :kindergarten_participation => {}, :high_school_graduation => {}})
      end
      @enrollments[row[:location].upcase].send(symbol.to_s)[row[:timeframe].to_i] = row[:data].to_f
      # @enrollments[row[:location].upcase].high_school_graduation[row[:timeframe].to_i] = row[:data].to_f
    end


    end
  end

  def find_by_name(name)
    if @enrollments[name]
       @enrollments[name]
    else
      return nil
    end
    # binding.pry
  end

end
