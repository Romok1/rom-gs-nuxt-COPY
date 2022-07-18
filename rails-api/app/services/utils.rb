module Utils
  def self.range(range)
    (range.min..range.max).to_a
  rescue StandardError
    []
  end
end
