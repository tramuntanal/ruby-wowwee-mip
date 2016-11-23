class HumanInputInterpreter
  def initialize
  end

  def sound_key_to_code(input)
    code= case input
    when /\d+/    then input.to_i
    when /[a-z]+/ then input.ord - 96
    when /[A-Z]+/ then input.ord - 38
    else input.to_i
    end

    if code <= 0 or code > 106
      raise ArgumentError.new("Invalid code #{input}")
    end
    code
  end

  def drive_key_to_code(input)
    case input
    when "\e[A"
      :fwd
    when "\e[B"
      :back
    when "\e[C"
      :right
    when "\e[D"
      :left
    end
  end
end
