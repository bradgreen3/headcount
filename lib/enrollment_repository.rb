require_relative 'enrollment'

class EnrollmentRepository
  def initialize
    @enrollments = {}
  end

  def load_data(hash)
    filename = hash[:enrollment][:kindergarten]
    contents = CSV.read filename, headers: true, header_converters: :symbol
    contents.each do |row|
      if find_by_name(row[:location].upcase).nil?
        @enrollments[row[:location].upcase] = Enrollment.new({:name => row[:location].upcase, kindergarten_participation: {}})
      end
      @enrollments[row[:location].upcase].kindergarten_participation[row[:timeframe].to_i] = row[:data].to_f
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
