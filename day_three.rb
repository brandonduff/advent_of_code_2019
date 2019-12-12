class String
  def to_instruction
    Instruction.new(chr, self[1..length].to_i)
  end
end

class DayThree
  def initialize(input)
    @input = input.split "\n"
  end

  def solution
    intersections.map(&:manhattan_distance).min
  end

  def complex_solution
    intersections.map do |intersection|
      first_board.steps_taken(intersection) + second_board.steps_taken(intersection)
    end.min
  end

  def intersections
    first_board.intersections_with second_board
  end

  def first_board
    @first_board ||= new_board @input.first
  end

  def second_board
    @second_board ||= new_board @input.last
  end

  def new_board instruction_input
    WirePositions.new instruction_input.split(",").map(&:to_instruction)
  end
end

class Instruction
  attr_reader :direction, :magnitude

  def initialize direction, magnitude
    @direction = direction
    @magnitude = magnitude
  end
end

class WirePositions
  attr_reader :instructions
  include Enumerable

  def initialize instructions
    @instructions = instructions
  end

  def each &block
    plotted_points.each &block
  end

  def intersections_with other_board
    intersections = plotted_points & other_board.plotted_points
    intersections.drop_while.with_index { |p, i| p == plotted_points.entries[i] }
  end

  def steps_taken point
    point.index self
  end

  protected

  def plotted_points
    @plotted_points ||= instructions.each_with_object([Point.new(0, 0)]) do |instruction, points|
      (0...instruction.magnitude).each do
        points << points.last + instruction
      end
    end
  end
end

class Point
  attr_reader :x, :y, :steps_taken

  def initialize x, y
    @x = x
    @y = y
  end

  def index board
    @index ||= board.find_index { |p| p == self }
  end

  def + instruction
    new_x, new_y =
      case instruction.direction
      when "R"
        [x + 1, y]
      when "U"
        [x, y + 1]
      when "L"
        [x - 1, y]
      when "D"
        [x, y - 1]
      end

    self.class.new new_x, new_y
  end

  def hash
    x.hash ^ y.hash
  end

  def == other
    return false unless other.is_a?(self.class)
    x == other.x && y == other.y
  end

  alias_method :eql?, :==

  def manhattan_distance
    x.abs + y.abs
  end
end
