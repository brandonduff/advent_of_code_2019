class String
  def to_masses
    split(')').map(&:to_mass)
  end

  def to_mass
    DaySix::Mass.new(self)
  end
end

module DaySix
  class System
    def self.from_raw_input(raw_input)
      new.tap do |system|
        raw_input.split("\n").each do |orbit|
          system.add_orbit(orbit)
        end
      end
    end

    def masses
      @masses ||= []
    end

    def traversals_to_santa
      traverse unless terminus.distance
      terminus.distance
    end

    def traverse
      masses_to_visit = [origin]
      until masses_to_visit.empty? do
        masses_to_visit.concat(masses_to_visit.shift.visit)
      end
    end

    def add_orbit(orbit_data)
      new_masses = orbit_data.to_masses
      new_masses = add_masses(new_masses)
      new_masses.last.orbits(new_masses.first)
      new_masses.first.neighbors << new_masses.last
    end

    def add_masses(new_masses)
      new_masses.map(&method(:get_or_add_mass))
    end

    def get_or_add_mass(mass)
      masses << mass unless masses.include?(mass)
      masses.find { |m| m == mass }
    end

    def total_orbits
      masses.sum { |mass| mass.orbitees.count }
    end

    def origin
      masses.find(&:origin?)
    end

    def terminus
      masses.find(&:terminus?)
    end
  end

  class Mass
    attr_reader :code, :orbitee
    attr_writer :distance

    def initialize(code)
      @code = code
    end

    def ==(other)
      @code == other.code
    end

    def orbits(other_mass)
      @orbitee = other_mass
      neighbors << other_mass
    end

    def orbitees
      [orbitee, *orbitee&.orbitees].compact
    end

    def origin?
      code == 'YOU'
    end

    def terminus?
      code == 'SAN'
    end

    def visit
      @visited = true
      unvisited_neighbors.each do |n|
        n.distance = distance + 1
      end
    end

    def visited?
      @visited
    end

    def unvisited_neighbors
      neighbors.reject(&:visited?)
    end

    def neighbors
      @neighbors ||= []
    end

    def distance
      return -2 if origin? # excludes SAN and YOU from being counted
      @distance
    end
  end
end