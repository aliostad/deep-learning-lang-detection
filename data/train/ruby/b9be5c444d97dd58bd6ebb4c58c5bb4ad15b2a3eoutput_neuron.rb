module ItsAlive
  class OutputNeuron < Neuron
    def initialize(count = 1, &block)
      super(&block)
      add_outputs(count)
    end

    def add_output
      add_outputs(1)
    end

    def add_outputs(count)
      count.times { @axon_synapses << Synapse.output_from(self) }
      self
    end

    def learn(desired)
      calculate_error(desired)
      calculate_delta
    end

    protected

    def calculate_delta
      @delta = -derivative * @error
    end

    def calculate_error(desired)
      @error = Error::SIGNAL.call(desired, @output)
    end
  end
end
