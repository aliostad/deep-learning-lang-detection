# coding: utf-8
# 外出旅行， 可以有很多方式， 自行车， 自驾， 火车， 飞机 等等，
# 如果通过条件判断去计算需要花费的时间或者金钱， 那么代码会类似下面的样子：
class Travel
  def initialize(vehicle, mile)
    @vehicle = vehicle
    @mile = mile
  end

  def calculate
    case @vehicle
    when '自行车'
      1
    when '自驾'
      2
    when '火车'
      3
    when '飞机'
      4
    end
  end
end

# test
t = Travel.new('自行车', 1)
p t.calculate

# 缺点：
# 1. 当需要计算新的工具所需要话费的时间的时候 需要不断的改变Travel类
# 2. 工具的计算方式和Travel类耦合
# 3. 不容易扩展组合交通工具的计算

# refactoring
class Travel
  def initialize(vehicle, mile)
    @vehicle = vehicle
    @mile = mile
  end

  def calculate
    @vehicle.calculate
  end
end

class Bike
  def calculate
    1
  end
end

class Compose
  def calculate
  end
end

# test
t = Travel.new(Bike.new, 1)
p t.calculate

# 职责区分
