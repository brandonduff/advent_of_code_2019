class Counter
  def self.count(first, last)
    (first.to_i...last.to_i).select { |num| Tester.valid?(num.to_s) }.length
  end
end

class Tester
  attr_reader :num

  def self.valid?(num)
    new(num).valid?
  end

  def self.valid_complex?(num)
    new(num).valid_complex?
  end

  def initialize(num)
    @num = num
  end

  def valid?
    has_double_digit? && is_increasing? && six_digits?
  end

  private

  def six_digits?
    num.length == 6
  end

  def is_increasing?
    num.chars.sort == num.chars
  end

  def has_double_digit?
    double_counting.any? { |el| el == 2 }
  end

  def double_counting
    @double_counting ||= num.chars.each_cons(2).with_object(Array.new(10, 0)).each do |(first, second), double_counting|
      double_counting[first.to_i] += 2 if first == second
    end
  end
end
