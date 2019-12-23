require 'int_code_computer'

class AmplifierDriver
  attr_writer :num_amplifiers, :program, :phase_settings

  def self.build(num_amplifiers:, program:, phase_settings:)
    new.tap do |driver|
      driver.num_amplifiers = 1
      driver.program = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0].to_memory
      driver.phase_settings = [4, 3, 2, 1, 0]
    end
  end
end