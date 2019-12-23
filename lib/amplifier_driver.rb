require 'array_io'
require 'int_code_computer'

class AmplifierDriver
  attr_writer :program, :io, :phase_settings

  def self.build(program:, phase_settings:)
    new.tap do |driver|
      driver.program = program
      driver.phase_settings = phase_settings
    end
  end

  def result
    process
    io.last_output
  end

  private

  def process
    phase_settings.each do |phase_setting|
      io.add_input(phase_setting)
      io.add_input(io.last_output)
      IntCodeComputer.new(program, io).process
    end
  end

  def io
    @io ||= ArrayIO.new.tap { |io| io.put(0) }
  end

  def program
    @program.dup
  end

  attr_reader :phase_settings
end