class ReverseFunctionCalculator
    def calculate_weight(distance)
        if distance == 0
            1.0
        else
            1.0 / distance

        end
    end
end

class SubtractionFunctionCalculator
    def initialize(subtraction_constant = 1)
        @subtraction_constant = subtraction_constant
    end

    def calculate_weight(distance)
        result = @subtraction_constant - distance
        if result >= 0
            result.to_f
        else
            0.0
        end
    end
end

class WeightCalculator
    def initialize(sigma = 10.0)
        @sigma = sigma
    end

    def calculate_weight(distance)
        Math.exp(distance**2/(2*@sigma**2))
    end
end
