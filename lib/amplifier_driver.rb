require 'array_io'
require 'int_code_computer'

class AmplifierDriver
  attr_writer :program, :io, :phase_settings, :mode

  def self.build(program:, phase_settings:, mode: :normal)
    new.tap do |driver|
      driver.program = program
      driver.phase_settings = phase_settings
      driver.mode = mode
    end
  end

  def result
    process
    io.last_output
  end

  private

  def process
    return process_with_feedback if mode == :feedback

    phase_settings.each do |phase_setting|
      io.add_input(phase_setting)
      io.add_input(io.last_output)
      IntCodeComputer.new(program, io).process
    end
  end

  def process_with_feedback
    programs = phase_settings.map do |setting|
      IntCodeComputer.new(program, ArrayIO.new([setting]))
    end

    last_output = ArrayIO.new
    last_output.put(0)
    until programs.all?(&:halted?) do
      programs.each do |program|
        program.io.add_input(last_output.last_output)
        program.get_next_output
        last_output = program.io
      end
    end
    @io = last_output
  end

  def io
    @io ||= ArrayIO.new.tap { |io| io.put(0) }
  end

  def program
    @program.dup
  end

  attr_reader :phase_settings, :mode
end