module BooHiss
  class Processor < SexpProcessor
    def self.run(callback, sexp)
      new(callback).process(sexp)
    end
    
    def initialize(callback)
      super()
      @callback = callback
      self.warn_on_default = false
      self.auto_shift_type = true
    end

    def process_call(exp)
      recv = process(exp.shift)
      meth = exp.shift
      args = process(exp.shift)

      out = [:call, recv, meth]
      out << args if args

      stack = caller.map { |s| s[/process_\w+/] }.compact

      if stack.first != "process_iter" then
        @callback.handle out
      else
        Sexp.from_array(out)
      end
    end

    def process_defn(exp)
      result = [:defn, exp.shift]
      result << process(exp.shift) until exp.empty?
      @callback.handle result
    end

    # So process_call works correctly
    def process_iter(exp)
      Sexp.from_array([:iter, process(exp.shift), process(exp.shift), process(exp.shift)])
    end

    def process_asgn(type, exp)
      var = exp.shift
      if exp.empty? then
        @callback.handle [type, var]
      else
        @callback.handle [type, var, process(exp.shift)]
      end
    end

    def process_cvasgn(exp)
      process_asgn :cvasgn, exp
    end

    def process_dasgn(exp)
      process_asgn :dasgn, exp
    end

    def process_dasgn_curr(exp)
      process_asgn :dasgn_curr, exp
    end

    def process_iasgn(exp)
      process_asgn :iasgn, exp
    end

    def process_gasgn(exp)
      process_asgn :gasgn, exp
    end

    def process_lasgn(exp)
      process_asgn :lasgn, exp
    end

    def process_lit(exp)
      @callback.handle [:lit, exp.shift]
    end

    def process_str(exp)
      @callback.handle [:str, exp.shift]
    end

    def process_if(exp)
      @callback.handle [:if, process(exp.shift), process(exp.shift), process(exp.shift)]
    end

    def process_true(exp)
      @callback.handle [:true]
    end

    def process_false(exp)
      @callback.handle [:false]
    end

    def process_while(exp)
      cond, body, head_controlled = grab_conditional_loop_parts(exp)
      @callback.handle [:while, cond, body, head_controlled]
    end

    def process_until(exp)
      cond, body, head_controlled = grab_conditional_loop_parts(exp)
      @callback.handle [:until, cond, body, head_controlled]
    end

    def grab_conditional_loop_parts(exp)
      cond = process(exp.shift)
      body = process(exp.shift)
      head_controlled = exp.shift
      return cond, body, head_controlled
    end
  end
end
