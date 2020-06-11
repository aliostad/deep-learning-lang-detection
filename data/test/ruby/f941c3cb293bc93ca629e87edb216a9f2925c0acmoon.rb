module Solar
  class Moon
    attr_reader :mass, :distance_from_planet, :composition

    def initialize(planet: nil)
      if planet.nil?
        fail TypeError, "Moons must be generated from a planet."
      end

      @planet               = planet
      @mass                 = calculate_mass
      @radius               = calculate_radius
      @distance_from_planet = calculate_distance_from_planet
      @composition          = calculate_composition
    end

    def calculate_mass # in Solar Mass
      # TODO
    end

    def calculate_distance_from_planet # in AU
      # TODO
    end

    def calculate_radius # in Solar Radii
      # TODO
    end

    def calculate_composition
      # TODO
    end

    def to_s
      %Q(
            Mass:   #{@mass} Solar Mass
            Radius: #{@radius} Solar Radii
            Distance From Planet: #{@distance_from_planet} AU
            Composition: #{@composition}
      )
    end
  end
end
