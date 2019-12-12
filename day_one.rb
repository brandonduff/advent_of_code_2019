def total(element)
  mass = 0
  remainder = element
  loop do
    new_remainder = remainder / 3 - 2
    return mass if new_remainder <= 0

    mass += new_remainder
    remainder = new_remainder
  end
end

input = File.read('day_one_input.txt').split.map(&:to_i)
puts(input.sum { |e| total(e) })


