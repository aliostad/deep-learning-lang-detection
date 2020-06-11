#coding:utf-8
=begin

类的实例：
类的实例都不能调用类的protected方法和private方法
在类的内部，方法前都不加self或类名，虽有定义的方法都一随意调用

类的子类
父类的的private和protected都可以被子类所继承

=end
class Base

  def initialize()
  end

  def defa
    set_defaults()
    calculate_and_set_baz()
  end

  protected
  def set_defaults()
    # defaults for this type
    p 'set_defaults'
    @foo = 7
    calculate_and_set_baz()
  end

  private
  def calculate_and_set_baz()
    p 'calculate_and_set_baz2222'
    @baz = "Something that only base classes have like a file handle or resource"
  end
end

class Derived < Base
  def defa
    set_defaults()
    calculate_and_set_baz()
  end

  protected
  def set_defaults()
    p 'set_defaults111111'
  end

end

b=Derived.new
b.defa