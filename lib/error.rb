class UnknownDataError < ArgumentError

end

class UnknownRaceError < ArgumentError

end

class InsufficientInformationError < ArgumentError
  # A grade must be provided to answer this question
end
