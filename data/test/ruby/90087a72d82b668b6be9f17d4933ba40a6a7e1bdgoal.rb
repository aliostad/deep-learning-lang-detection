#Goal model config and models
class Goal < ActiveRecord::Base
    validates :frequency, :goal, presence: true #, length:{minimum 25}
	belongs_to :user
	belongs_to :type_goal
	belongs_to :type_goalgoer
	validates_presence_of :frequency, :goal



	def calculate_steps(one)
       if self.type_goal.tip == "Steps"
         self.progress = self.progress + one.steps
       end
    end
    def calculate_calories(one)
       if self.type_goal.tip == "Calories"
        self.progress = self.progress + one.calories
       end
    end
    def calculate_dream
       if self.type_goal.tip == "Dream"
         self.progress = self.goal
       end
    end
    def calculate_weight
       if self.type_goal.tip == "Weight"
         self.progress = User.find(self.user_id).weight
       end
    end

    def calculate_heart_rate
      right_now=Time.now
      @today=User.find(self.user_id).bands.first.band_informations.where('registered_date BETWEEN ? AND ?',right_now.beginning_of_day, right_now.end_of_day).average(:heart_rate)
      if self.type_goal.tip == "Heart Rate"
      self.progress = @today
      end
    end

    def calculate_day(one)
      right_now=Time.now
      if self.frequency=="Day" && right_now.month == one.registered_date.month && right_now.day == one.registered_date.day && right_now.year == one.registered_date.year
       calculate_calories(one)
      calculate_steps(one)
      calculate_dream
      calculate_weight
      calculate_heart_rate
      end 
    end

    def calculate_month(one)
      right_now=Time.now
      if self.frequency=="Month" && right_now.month == one.registered_date.month && right_now.year == one.registered_date.year
      calculate_calories(one)
      calculate_steps(one)
      calculate_dream
      calculate_weight
      end 
    end

    def calculate_year(one)
      right_now=Time.now
      if self.frequency=="Year" && right_now.year == one.registered_date.year
       calculate_calories(one)
      calculate_steps(one)
      calculate_dream
      calculate_weight
      end 
    end

    def complete_goal
      if self.progress >= self.goal
        self.complete = true
      else 
        self.complete = false
      end
    end
end
