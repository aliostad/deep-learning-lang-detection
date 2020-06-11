class HotelReservation < ActiveRecord::Base
    before_save :days_in_advance, :calculate_total_amount, :calculate_benchmark_rate_difference
    def days_in_advance
        self.days_in_advance = (self.check_in_date - self.reservation_date).to_i
    end

    def calculate_total_amount
        self.total_amount = (self.daily_rate * self.number_of_room_nights).to_f.round(2)
    end

    def calculate_benchmark_rate_difference
        self.benchmark_rate_difference = ((self.benchmark_rate - self.daily_rate) * self.number_of_room_nights).to_f.round(2)
    end
end
