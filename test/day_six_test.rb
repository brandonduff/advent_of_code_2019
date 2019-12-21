require 'minitest/autorun'
require 'day_six'

module DaySix
  class DaySixTest < Minitest::Test
    def test_system_can_add_orbit_data
      system = System.new
      system.add_orbit('ABC)DEF')
      assert_includes system.masses, Mass.new('ABC')
      assert_includes system.masses, Mass.new('DEF')
      new_masses = system.masses.last(2)
      assert_equal new_masses.first, new_masses.last.orbitee
    end

    def test_can_add_multiple_orbit_data
      system = System.new
      system.add_orbit('COM)ABC')
      system.add_orbit('ABC)DEF')
      system.add_orbit('DEF)GHI')
      assert_includes system.masses.last.orbitees, system.masses[-2]
      assert_includes system.masses.last.orbitees, system.masses[-3]
      assert_includes system.masses.last.orbitees, system.masses[-4]
    end

    def test_direct_and_indirect_orbits
      system = System.new
      system.add_orbit('COM)ABC')
      assert_equal 1, system.total_orbits

      system.add_orbit('ABC)DEF')
      assert_equal 3, system.total_orbits

      system.add_orbit('COM)XYZ')
      assert_equal 4, system.total_orbits

      system.add_orbit('DEF)GHI')
      assert_equal 7, system.total_orbits
    end

    def test_example
      input = <<~INPUT
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
      INPUT
      assert_equal 42, System.from_raw_input(input).total_orbits
    end

    def test_part_one
      skip
      p System.from_raw_input(File.read('day_six_input.txt')).total_orbits
    end

    def test_finds_origin_and_terminus
      system = System.new
      system.add_orbit('COM)B')
      system.add_orbit('B)A')
      system.add_orbit('B)YOU')
      system.add_orbit('A)SAN')
      system.add_orbit('YOU)C')

      assert_equal Mass.new('YOU'), system.origin
      assert_equal Mass.new('SAN'), system.terminus
    end

    def test_adding_neighbors
      system = System.new
      system.add_orbit('COM)A')
      system.add_orbit('A)SAN')
      system.add_orbit('A)YOU')

      assert_includes system.get_or_add_mass(Mass.new('A')).neighbors, Mass.new('YOU')
      assert_includes system.get_or_add_mass(Mass.new('YOU')).neighbors, Mass.new('A')
    end

    def test_navigating_from_origin_to_terminus
      system = System.new
      system.add_orbit('COM)A')
      system.add_orbit('A)SAN')
      system.add_orbit('A)YOU')
      system.traverse
      assert_equal 0, system.traversals_to_santa
    end

    def test_orbital_transfers_example
      input = <<~INPUT
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
        K)YOU
        I)SAN
      INPUT
      system = System.from_raw_input(input)
      assert_equal 4, system.traversals_to_santa
    end

    def test_part_two
      skip
      assert_equal 391, System.from_raw_input(File.read('day_six_input.txt')).traversals_to_santa
    end
  end
end