class DayThree
  attr_reader :input, :current_position, :first_count, :second_count

  def initialize input
    @input = input
    @current_position = origin
    @first_count = 0
    @second_count = 0
  end

  def find_answer
    advance until finished?
  end

  def advance
    @current_position = advanceable_neighbors.detect(-> { raise 'no valid neighbors' }) { |p| p.wire? }
    bump_count
    @current_position.visited
    if @current_position.intersection?
      @current_position = origin
      @finished = true if @first_found
      @first_found = true
    end
  end

  def origin
    board.detect { |p| p.origin? }
  end

  def board
    @board ||= Board.new input
  end

  def advanceable_neighbors
    neighbors = board.neighbors @current_position
    neighbors.reject { |neighbor| neighbor.visited? }
  end

  def finished?
    @finished
  end

  def answer
    [first_count, second_count].min
  end

  private

  def bump_count
    if @first_found
      @second_count += 1
    else
      @first_count += 1
    end
  end
end

class Board
  attr_reader :input
  include Enumerable

  def initialize input
    @input = input
  end

  def each(&block)
    elements.each(&block)
  end

  def rows
    input.split "\n"
  end

  def column_length
    rows.first.chars.length
  end

  def neighbors board_cell
    select { |cell| board_cell.position.neighbors.include? cell.position }
  end

  def elements
    @elements ||= rows.map.with_index do |row, row_num|
      row.chars.map.with_index do |cell, cell_num|
        BoardCell.new row_num, cell_num, cell
      end
    end.flatten
  end
end

class BoardCell
  attr_reader :char, :position

  def initialize x, y, char = "."
    @char = char
    @position = Point.new x, y
  end

  def origin?
    char == "O"
  end

  def wire?
    %w(| + - X).include? char
  end

  def intersection?
    char == 'X'
  end

  def visited?
    @visited
  end

  def visited
    @visited = true
  end

  def == other
    position == other.position && char == other.char
  end
end

class Point
  attr_reader :x, :y

  def initialize x, y
    @x = x
    @y = y
  end

  def == other
    other.x == x &&
        other.y == y
  end

  def neighbors
    [
        self.class.new(x - 1, y),
        self.class.new(x + 1, y),
        self.class.new(x, y - 1),
        self.class.new(x, y + 1)
    ]
  end
end


