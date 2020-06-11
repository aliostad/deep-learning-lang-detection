  def display_menu
    puts "Geometry Calculater\n" +
      "1. Calculate the area of a Circle\n" +
      "2. Calculate the area of a Rectangle\n" +
      "3. Calculate the area of a Triangle\n" +
      "4. Exit"
  end

  def user_input
    print "Enter your choice (1-4)\n"
    gets.chop
  end

  def menu_select(choice)
    choices = {
      "1" => "calculate_area_of_circle",
      "2" => "calculate_area_of_rectangle",
      "3" => "calculate_area_of_triangle",
      "4" => "exit" 
    }

    method = choices[choice]
    Geometry.new.send method
  end

class Geometry
  def calculate_area_of_circle
    puts "Enter radius of circle"
    radius = gets.to_f

    area = printf("total area is %.4f",Math::PI * (radius ** 2))
  end

  def calculate_area_of_rectangle
    puts "enter length of rectangle"
    length = gets.to_f

    puts "enter width of rectangle"
    width = gets.to_f

    area =  length * width
    "total area is #{area}"
  end


  def calculate_area_of_triangle
    puts "enter size of triangle base"
    base = gets.to_f

    puts "enter height of rectangle"
    height = gets.to_f

    area = base * height * 0.5
    puts "total area is #{area}"
  end
end 
    
while (true)
  display_menu
  puts menu_select user_input
end
