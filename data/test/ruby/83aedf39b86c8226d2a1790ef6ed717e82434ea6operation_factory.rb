class OperationFactory
  attr_accessor :result
  
  def initialize(*args)
    @result = 0
    case args.last
    when "+"
      @result = AddOperation.input(*args).calculate
    when "-"
      @result = SubOperation.input(*args).calculate
    when "*"
      @result = MulOperation.input(*args).calculate
    when "/"
      @result = DivOperation.input(*args).calculate
    when "^"
      @result = PowOperation.input(*args).calculate
    end
  end
  
  class << self
    def build(*args)
      new(*args)
    end
  end
  
  private_class_method :new
end