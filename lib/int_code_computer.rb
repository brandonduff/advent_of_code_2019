class IntCodeComputer
  attr_reader :input

  def self.process(input)
    new(input).process
  end

  def initialize(input)
    @input = input
  end

  def process
    input.each_slice(4).with_object(input) do |(op_code, first_operand_index, second_operand_index, store_location), result|
      break result if operations[op_code] == :exit

      result[store_location] = result[first_operand_index].send(operations[op_code], result[second_operand_index])
    end
  end

  def operations
    {
      1 => :+,
      2 => :*,
      99 => :exit
    }
  end
end