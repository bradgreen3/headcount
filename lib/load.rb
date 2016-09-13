# require 'cleaner'

class Load
  attr_reader :data

  def initialize
    @data = []
  end

  def load_file(filename)
    contents = CSV.open filename, headers: true, header_converters: :symbol
    # contents.each do |content|
    #   content
    @data << contents
  end

end
