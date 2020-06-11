require '../../lib/array'

#テクニカル指標の親クラス
class Indicator
  include Enumerable
  
  def initialize(stock)
    @stock = stock
  end

  def each 
    @indicator.each {|value| yield value}
  end

  #要素がnilの時は:no_valueをthrowする
  def [](index)
    if index.kind_of? Numeric and (@indicator[index].nil? or index < 0)
      throw :no_value
    else
      @indicator[index]
    end
  end

  def calculate 
    @indicator = calculate_indicator
    self
  end

  #指標計算の実装。子クラスでオーバーライドする
  def calculate_indicator; end
end



