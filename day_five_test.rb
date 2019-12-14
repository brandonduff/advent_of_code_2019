require 'int_code_computer'

input = File.read('day_five_input.txt')
IntCodeComputer.from_raw_input(input).process
