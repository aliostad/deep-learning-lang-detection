class ActivityLog < ActiveRecord::Base

	belongs_to :goal

  # this rounds points to the nearest ten
  def round_points(number)
    new_num = number/10.0
    rounded_num = new_num.round
    multiply_num = rounded_num*10
  end

  def calculate_points
    activity_by_type = Activity.find_by(type_of_activity: self.intensity)
    initial_points = (activity_by_type.met)*(self.duration)
    final_points = round_points(initial_points)
    final_points
  end

  def show_points
    if self.intensity && self.distance == nil
      self.calculate_points

    elsif self.distance && self.intensity
      goal = Goal.find(self.goal_id)

      if Activity.find(goal.activity_id).name == "Cycling"
        duration_in_hours = (self.duration)/60.0
        speed = (self.distance)/(duration_in_hours)
        if speed < 5.0
          initial_points = 2.0*(self.duration)
          final_points = round_points(initial_points)
          final_points
        elsif speed >= 5.0 && speed < 8.0
          self.intensity = "5.0-7.9 mph"
          self.calculate_points
        elsif speed >= 8.0 && speed < 10.0
          self.intensity = "8.0-9.9 mph"
          self.calculate_points  
        elsif speed >= 10.0 && speed < 12.0
          self.intensity = "10.0-11.9 mph"
          self.calculate_points
        elsif speed >= 12.0 && speed < 14.0
          self.intensity = "12.0-13.9 mph"
          self.calculate_points
        elsif speed >= 14.0 && speed < 16.0
          self.intensity = "14.0-15.9 mph"
          self.calculate_points  
        elsif speed >= 16.0 && speed < 20.0
          self.intensity = "16.0-19.0 mph"
          self.calculate_points  
        elsif speed >= 20.0
          self.intensity = ">20mph"
          self.calculate_points    
        end
      end

      if Activity.find(goal.activity_id).name == "Walking"
        duration_in_hours = (self.duration)/60.0
        speed = (self.distance)/(duration_in_hours)
        if speed < 2.0
          initial_points = 2.0*(self.duration)
          final_points = round_points(initial_points)
          final_points
        elsif speed >= 2.0 && speed < 2.5
          self.intensity = "2-2.4 mph"
          self.calculate_points
        elsif speed >= 2.5 && speed < 3.0
          self.intensity = "2.5-2.9 mph"
          self.calculate_points  
        elsif speed >= 3.0 && speed < 3.5
          self.intensity = "3.0-3.4 mph"
          self.calculate_points
        elsif speed >= 3.5 && speed < 4.0
          self.intensity = "3.5-3.9 mph"
          self.calculate_points
        elsif speed >= 4.0 && speed < 4.5
          self.intensity = "4.0-4.4 mph"
          self.calculate_points  
        elsif speed >= 4.5 && speed < 5.0
          self.intensity = "4.5-4.9 mph"
          self.calculate_points  
        elsif speed >= 5.0
          self.intensity = "5.0-5.4 mph"
          self.calculate_points    
        end
      end

      if Activity.find(goal.activity_id).name == "Running"
        duration_in_hours = (self.duration)/60.0
        speed = (self.distance)/(duration_in_hours)
        if speed < 4.0
          initial_points = 4.0*(self.duration)
          final_points = round_points(initial_points)
          final_points
        elsif speed >= 4.0 && speed < 5.0
          self.intensity = "4.0-4.9 mph"
          self.calculate_points
        elsif speed >= 5.0 && speed < 5.2
          self.intensity = "5.0-5.1 mph"
          self.calculate_points  
        elsif speed >= 5.2 && speed < 6.0
          self.intensity = "5.2-5.9 mph"
          self.calculate_points
        elsif speed >= 6.0 && speed < 6.7
          self.intensity = "6.0-6.6 mph"
          self.calculate_points
        elsif speed >= 6.7 && speed < 7.0
          self.intensity = "6.7-6.9 mph"
          self.calculate_points  
        elsif speed >= 7.0 && speed < 7.5
          self.intensity = "7.0-7.4 mph"
          self.calculate_points
        elsif speed >= 7.5 && speed < 8.0
          self.intensity = "7.5-7.6 mph"
          self.calculate_points
        elsif speed >= 8.0 && speed < 8.6
          self.intensity = "8.0-8.5 mph"
          self.calculate_points
        elsif speed >= 8.6 && speed < 9.0
          self.intensity = "8.6-8.9 mph"
          self.calculate_points
        elsif speed >= 9.0 && speed < 10.0
          self.intensity = "9.0-9.9 mph"
          self.calculate_points
        elsif speed >= 10.0 && speed < 11.0
          self.intensity = "10.0-10.9 mph"
          self.calculate_points
        elsif speed >= 11.0 && speed < 12.0
          self.intensity = "11.0-11.9 mph"
          self.calculate_points
        elsif speed >= 12.0 && speed < 13.0
          self.intensity = "12.0-12.9 mph"
          self.calculate_points
        elsif speed >= 13.0 && speed < 14.0
          self.intensity = "13.0-13.9 mph"
          self.calculate_points 
        elsif speed >= 14.0
          self.intensity = "14.0-14.9 mph"
          self.calculate_points
        end
      end

    else
      self.calculate_points
    end
  end

end
