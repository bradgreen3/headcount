require_relative 'error'

class StatewideTest
  attr_reader :hash
  attr_accessor :statewide_testing

RACES = [:all_students, :asian, :black,
        :pacific_islander, :hispanic,
        :native_american, :two_or_more, :white]
SUBJECTS = [:math, :reading, :writing]
YEARS = [2008, 2009, 2010, 2011, 2012, 2013, 2014]
GRADES = [3,8]

  def initialize(hash)
    @hash = hash
  end

  def name
    @hash[:name]
  end

  def third_grade(input)
    @hash[:third_grade][input]
  end

  def eighth_grade(input)
    @hash[:eighth_grade][input]
  end

  def math(input)
    @hash[:math][input]
  end

  def reading(input)
    @hash[:reading][input]
  end

  def writing(input)
    @hash[:writing][input]
  end

  def proficient_by_grade(grade)
    if GRADES.include?(grade) == false
      raise UnknownDataError
    elsif grade == 3
      third_grade_proficiency
    elsif grade == 8
      eighth_grade_proficiency
    end
  end

  def third_grade_proficiency
    result_hash = new_hash
    @hash[:third_grade][:math].each do |key,value|
      result_hash[key][:math] = three_digiter(value)
    end
    @hash[:third_grade][:reading].each do |key,value|
      result_hash[key][:reading] = three_digiter(value)
    end
    @hash[:third_grade][:writing].each do |key,value|
      result_hash[key][:writing] = three_digiter(value)
    end
    result_hash
  end

  def eighth_grade_proficiency
    result_hash = new_hash
    @hash[:eighth_grade][:math].each do |key,value|
      result_hash[key][:math] = three_digiter(value)
    end
    @hash[:eighth_grade][:reading].each do |key,value|
      result_hash[key][:reading] = three_digiter(value)
    end
    @hash[:eighth_grade][:writing].each do |key,value|
      result_hash[key][:writing] = three_digiter(value)
    end
    result_hash
  end

  def proficient_by_race_or_ethnicity(race)
    if RACES.include?(race)
      proficient_by_race(race)
    else raise UnknownRaceError
    end
  end

  def proficient_by_race(race)
    result_hash = new_hash_ethnicity
    @hash[:math][race.to_sym].each do |key,value|
      result_hash[key][:math] = three_digiter(value)
    end
    @hash[:reading][race.to_sym].each do |key,value|
      result_hash[key][:reading] = three_digiter(value)
    end
    @hash[:writing][race.to_sym].each do |key,value|
      result_hash[key][:writing] = three_digiter(value)
    end
    result_hash
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if SUBJECTS.include?(subject) == false ||
      YEARS.include?(year) == false ||
      GRADES.include?(grade) == false
      raise UnknownDataError
    elsif grade == 3
      value = @hash[:third_grade][subject.to_sym][year.to_i]
    elsif grade == 8
      value = @hash[:eighth_grade][subject.to_sym][year.to_i]
    end
    if value == 0.0
      return "N/A"
    else value
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if SUBJECTS.include?(subject) == false ||
      YEARS.include?(year) == false ||
      RACES.include?(race) == false
      raise UnknownDataError
    else
      value = @hash[subject.to_sym][race.to_sym][year.to_i]
      three_digiter(value)
    end
  end

private

  def new_hash_ethnicity
    setup_ethnicity_hash =
    { 2011=>{:math=>nil, :reading=>nil, :writing=>nil},
      2012=>{:math=>nil, :reading=>nil, :writing=>nil},
      2013=>{:math=>nil, :reading=>nil, :writing=>nil},
      2014=>{:math=>nil, :reading=>nil, :writing=>nil}}
  end

  def new_hash
    setup_hash =
    { 2008 => {:math=>nil, :reading=>nil, :writing=>nil},
      2009 => {:math=>nil, :reading=>nil, :writing=>nil},
      2010=>{:math=>nil, :reading=>nil, :writing=>nil},
      2011=>{:math=>nil, :reading=>nil, :writing=>nil},
      2012=>{:math=>nil, :reading=>nil, :writing=>nil},
      2013=>{:math=>nil, :reading=>nil, :writing=>nil},
      2014=>{:math=>nil, :reading=>nil, :writing=>nil}}
  end

  def three_digiter(var)
    var = (var*1000).floor/1000.0
    var
  end

end
