module Sensu
  module Settings
    module Validators
      module Handler
        # Validate pipe handler.
        # Validates: command
        #
        # @param handler [Hash] sensu handler definition.
        def validate_pipe_handler(handler)
          must_be_a_string(handler[:command]) ||
            invalid(handler, "handler command must be a string")
        end

        # Validate socket (tcp/udp) handler.
        # Validates: socket (host, port)
        #
        # @param handler [Hash] sensu handler definition.
        def validate_socket_handler(handler)
          socket = handler[:socket]
          if is_a_hash?(socket)
            must_be_a_string(socket[:host]) ||
              invalid(handler, "handler host must be a string")
            must_be_an_integer(socket[:port]) ||
              invalid(handler, "handler port must be an integer")
          else
            invalid(handler, "handler socket must be a hash")
          end
        end

        # Validate transport handler.
        # Validates: pipe (type, name, options)
        #
        # @param handler [Hash] sensu handler definition.
        def validate_transport_handler(handler)
          pipe = handler[:pipe]
          if is_a_hash?(pipe)
            must_be_a_string(pipe[:type]) ||
              invalid(handler, "handler transport pipe type must be a string")
            must_be_either(%w[direct fanout topic], pipe[:type]) ||
              invalid(handler, "handler transport pipe type is invalid")
            must_be_a_string(pipe[:name]) ||
              invalid(handler, "handler transport pipe name must be a string")
            must_be_a_hash_if_set(pipe[:options]) ||
              invalid(handler, "handler transport pipe options must be a hash")
          else
            invalid(handler, "handler transport pipe must be a hash")
          end
        end

        # Validate set handler.
        # Validates: handlers
        #
        # @param handler [Hash] sensu handler definition.
        def validate_set_handler(handler)
          if is_an_array?(handler[:handlers])
            items_must_be_strings(handler[:handlers]) ||
              invalid(handler, "handler set handlers must each be a string")
          else
            invalid(handler, "handler set handlers must be an array")
          end
        end

        # Validate handler type.
        # Validates: type
        #
        # @param handler [Hash] sensu handler definition.
        def validate_handler_type(handler)
          must_be_a_string(handler[:type]) ||
            invalid(handler, "handler type must be a string")
          case handler[:type]
          when "pipe"
            validate_pipe_handler(handler)
          when "tcp", "udp"
            validate_socket_handler(handler)
          when "transport"
            validate_transport_handler(handler)
          when "set"
            validate_set_handler(handler)
          else
            invalid(handler, "unknown handler type")
          end
        end

        # Validate handler filtering.
        # Validates: filter, filters
        #
        # @param handler [Hash] sensu handler definition.
        def validate_handler_filtering(handler)
          must_be_an_array_if_set(handler[:filters]) ||
            invalid(handler, "handler filters must be an array")
          if is_an_array?(handler[:filters])
            items_must_be_strings(handler[:filters]) ||
              invalid(handler, "handler filters items must be strings")
          end
          must_be_a_string_if_set(handler[:filter]) ||
            invalid(handler, "handler filter must be a string")
        end

        # Validate handler severities.
        # Validates: severities
        #
        # @param handler [Hash] sensu handler definition.
        def validate_handler_severities(handler)
          must_be_an_array_if_set(handler[:severities]) ||
            invalid(handler, "handler severities must be an array")
          if is_an_array?(handler[:severities])
            must_be_either(%w[ok warning critical unknown], handler[:severities]) ||
              invalid(handler, "handler severities are invalid")
          end
        end

        # Validate a Sensu handler definition.
        # Validates: timeout, mutator, handle_flapping, handle_silenced
        #
        # @param handler [Hash] sensu handler definition.
        def validate_handler(handler)
          validate_handler_type(handler)
          validate_handler_filtering(handler)
          validate_handler_severities(handler)
          must_be_a_numeric_if_set(handler[:timeout]) ||
            invalid(handler, "handler timeout must be numeric")
          must_be_a_string_if_set(handler[:mutator]) ||
            invalid(handler, "handler mutator must be a string")
          must_be_boolean_if_set(handler[:handle_flapping]) ||
            invalid(handler, "handler handle_flapping must be boolean")
          must_be_boolean_if_set(handler[:handle_silenced]) ||
            invalid(handler, "handler handle_silenced must be boolean")
        end
      end
    end
  end
end
