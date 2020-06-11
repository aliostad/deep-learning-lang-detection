#!/usr/bin/env ruby

module RedBook
	class AggregationPlugin < Plugin
	end

	operation(:calculate) {
		target { set :required; type :enum; restrict_to 'sum', 'average', 'max', 'min'}
		parameter(:on) { set :required }
		body { |params|
			result = @engine.calculate params[:calculate], params[:on]
			info "Result: #{result}"
		}
	}

	macro :duration, ":calculate sum :on duration"
	macro :sum, ":calculate sum :on <:sum>"
	macro :min, ":calculate min :on <:max>"
	macro :max, ":calculate max :on <:max>"
	macro :average, ":calculate average :on <:average>"


	class Engine

		def calculate(function, field)
			raise EngineError, "Empty dataset." if @dataset.blank?
			data = []
			sum = 0
			@dataset.each do |e|
				value = e.send RedBook.config.calculation_fields[field.to_sym] rescue nil
				value = (value.to_f == 0.0 && !value.in?('0.0', '0')) ? nil : value.to_f  
				next unless value
				data << value
				sum += value
			end
			case function.to_sym
			when :sum then
				return sum
			when :average then
				return sum/data.length
			when :max then
				return data.sort.reverse[0]
			when :min then
				return data.sort[0]
			else
				raise EngineError, "Function '#{function}' not supported."
			end
		end

	end

end
