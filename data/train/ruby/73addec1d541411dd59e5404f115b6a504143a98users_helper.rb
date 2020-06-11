module UsersHelper
  def friends?(user, friend)
    Friendship.friends?(user, friend)
  end    
  
  def random_greeting(user)
    if user.name.blank?
      "#{:greetings.l.sort_by {rand}.first} #{user.login.gsub(/-/," ")}!"
    else
      "#{:greetings.l.sort_by {rand}.first} #{user.name}!"
    end
  end
  
  def experience_duration(experience)
    str = ''
    str += Date::MONTHNAMES[experience.from_month].to_s+" "+experience.from_year.to_s
    str += " to "
    if experience.current
      diff = (Date.today - Date.civil(experience.from_year, experience.from_month)).to_i
      calculate_year = diff/365
      calculate_month = (diff%365)/30
      str += " Present "
    else
      diff = ( Date.civil(experience.end_year,experience.end_month) - Date.civil(experience.from_year,experience.from_month)).to_i
      calculate_year = diff/365
      calculate_month = (diff%365)/30
			str += Date::MONTHNAMES[experience.end_month].to_s+" "+ experience.end_year.to_s
    end
    
    arr = []
    if !calculate_year.blank? && calculate_year > 0
      arr << pluralize(calculate_year, 'year')
    end 
    if !calculate_month.blank? && calculate_month > 0
      arr << pluralize(calculate_month, 'month')
    end 
    
    if arr.size > 0
      str += "("+arr.join(" ")+")"
    end
    return str
  end
  
  
end
