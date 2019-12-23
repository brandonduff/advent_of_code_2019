require 'minitest/autorun'
require 'amplifier_driver'

class AmplifierDriverTest < Minitest::Test
  def test_can_run_one_amplifier
    program = [3, 0, 3, 1, 4, 1].to_memory
    phase_settings = [4, 3, 2, 1, 0]

    driver = AmplifierDriver.build(num_amplifiers: 1, program: program, phase_settings: phase_settings )
  end
end