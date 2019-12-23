require 'minitest/autorun'
require 'amplifier_driver'

class AmplifierDriverTest < Minitest::Test
  def test_can_run_two_amplifiers
    phase_settings = [1,2]
    # take two numbers (input instruction, phase setting), add them and output result
    program = [3, 0, 3, 1, 1, 0, 1, 3, 4, 3]

    driver = AmplifierDriver.build(program: program, phase_settings: phase_settings)
    assert_equal 1 + 2, driver.result
  end

  def test_sample_input
    program = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
    phase_settings = [4,3,2,1,0]
    driver = AmplifierDriver.build(program: program, phase_settings: phase_settings)
    assert_equal 43210, driver.result
  end

  def test_another_sample_input
    program = [3,23,3,24,1002,24,10,24,1002,23,-1,23,
               101,5,23,23,1,24,23,23,4,23,99,0,0]
    phase_settings = [0,1,2,3,4]
    driver = AmplifierDriver.build(program: program, phase_settings: phase_settings)
    assert_equal 54321, driver.result
  end

  def test_third_sample_input
    program = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
               1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    phase_settings = [1,0,4,3,2]
    driver = AmplifierDriver.build(program: program, phase_settings: phase_settings)
    assert_equal 65210, driver.result
  end

  def test_finding_best_phase_settings
    skip
    program = File.read('day_seven_input.txt').split(',').map(&:to_i)
    result = [0,1,2,3,4].permutation(5).map do |phase_setting|
      [phase_setting, AmplifierDriver.build(program: program, phase_settings: phase_setting).result]
    end.max { |a,b| a.last <=> b.last }
    p result
  end
end

