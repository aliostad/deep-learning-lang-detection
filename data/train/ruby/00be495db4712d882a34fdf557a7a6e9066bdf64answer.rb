def main
  all_staff_manage = []
 
  loop do
    staff_num = gets.chomp.to_i
    break if staff_num == 0
    all_staff_manage << StaffManage.new.make_staffs(staff_num)
  end
 
  all_staff_manage.each do |staff_manage|
    staff_manage.output()
  end
end
 
class StaffManage
  def initialize()
    @staffs = Hash.new(0)
    @result = []
  end
 
  def make_staffs staff_num
    staff_num.times do
      id,rate,number = gets.chomp.split(' ').map{|x| x.to_i}
      @staffs[id] += rate * number
    end
    self
  end
 
  def output()
    check()
    if @result.empty?
      puts 'NA'
    else
      @result.each{|id| puts id}
    end
  end
 
  private
  def check()
    @staffs.each do |key, value|
      @result << key if value >= 1000000
    end
  end
end
 
main
