class ArrayIO
  attr_reader :std_in

  def initialize(input = [])
    @std_in = input
  end

  def get
    std_in.shift
  end

  def put(value)
    std_out << value
  end

  def std_in=(value)
    @std_in = value
  end

  def add_input(input)
    std_in << input
  end

  def last_output
    std_out.last
  end

  def std_out
    @std_out ||= []
  end
end