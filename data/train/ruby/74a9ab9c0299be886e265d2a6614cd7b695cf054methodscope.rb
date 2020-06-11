


class Processor

  def process(other)
    other.protected_process
  end

  def protected_process
    private_process
  end
  protected :protected_process

  def private_process
    puts "done!"
  end
  private :private_process
end

processor = Processor.new

processor.protected_process rescue nil ## protected method called error(NoMethodError)
processor.private_process rescue nil ## private method called error(NoMethodError)

# 他のオブジェクト(同じクラス)の protected を呼び出せる
processor.process(Processor.new)

