require_relative 'enrollment'

class EnrollmentRepository
  def initialize
    @enrollments = {}
  end

  def load_data(hash)
    filename = hash[:enrollment][:kindergarten]
    contents = CSV.read filename, headers: true, header_converters: :symbol
    contents.each do |row|
      if find_by_name(row[:location]).nil?
        @enrollments[row[:location]] = Enrollment.new({:name => row[:location]})
      end
    end
  end

  def find_by_name(name)
    if @enrollments[name.upcase]
       @enrollments[name.upcase]
    else
      return nil
    end
    # binding.pry
  end

end
