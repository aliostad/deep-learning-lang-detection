require 'kramer/dsl'

module Uno
  class Parser
    GrammarFile = File.expand_path('../grammar.kram', __FILE__)
    Grammar = Kramer::DSL.parse(File.read(GrammarFile))

    def self.parse(str)
      new.parse(str)
    end

    def parse(str)
      i = Grammar.new(str)
      if i.success?
        process(i.result.value)
      else
        raise i.failure_message
      end
    end

    def process(node)
      send("process_#{node.name}", node.value)
    end

    ## Numbers
    def process_num(node)
      [:integer, node[:value].val.to_i]
    end

    ## Strings
    def process_str(node)
      [:string, node[:value].val]
    end

    ## Records
    def process_recempty(node)
      [:recempty]
    end

    def process_record(node)
      [:record, process(node[:value].val)]
    end

    def process_recmerge(node)
      [:recmerge, process(node[:rest].val), process(node[:field].val)]
    end

    def process_recset(node)
      [:recset, node[:name].val, process(node[:value].val)]
    end

    def process_recupdate(node)
      [:recupdate, node[:name].val, process(node[:value].val)]
    end

    def process_recsplat(node)
      [:recsplat, process(node[:value].val)]
    end

    def process_recremove(node)
      [:recremove, node[:name].val]
    end

    def process_recmethod(node)
      [:recmethod, node[:name].val, process(node[:value].val)]
    end

    ## Assignment
    def process_assign(node)
      [:assign, node[:name].val, process(node[:value].val)]
    end

    ## Variables
    def process_var(node)
      [:var, node[:name].val]
    end

    ## Access/methods
    def process_access(node)
      [:access, process(node[:base].val), node[:name].val]
    end

    def process_method(node)
      [:method, process(node[:base].val), node[:name].val, []]
    end

    def process_call(node)
      args = node[:args] ? process(node[:args].val) : []
      expr = process(node[:expr].val)

      if expr[0] == :method
        expr[3].concat args
        expr
      else
        [:call, expr, args]
      end
    end

    def process_arg(node)
      rest = process(node[:rest].val) if node[:rest]
      [*rest, process(node[:value].val)]
    end

    ## Ops
    def process_op(node)
      [:op, node[:op].val, process(node[:left].val), process(node[:right].val)]
    end

    ## Block

    def process_block(node)
      vars = process(node[:vars].val)
      [:block, vars]
    end

    def process_bvariants(node)
      rest = process(node[:rest].val) if node[:rest]
      [*rest, process(node[:value].val)]
    end

    def process_bvariant(node)
      params = node[:params] ? process(node[:params].val) : []
      params = [params] if params[0] == :param
      [:bvariant, process(node[:code].val), params]
    end

    def process_params(node)
      left = process(node[:left].val)
      right = process(node[:right].val)

      [left, right].inject([]) do |memo, arr|
        if arr[0] == :param
          memo << arr
        else
          memo.concat(arr)
        end
      end
    end

    def process_param(node)
      cond = process(node[:cond].val) if node[:cond]
      [:param, node[:name].val, cond]
    end

    ## If

    def process_if(node)
      [:if, process(node[:cond].val), process(node[:body].val)]
    end

    ## Exprs
    def process_exprs(node)
      [:exprs, process(node[:left].val), process(node[:right].val)]
    end
  end
end

