module YAYJS::Passes
  class ASTPass
    def initialize
      @nesting_level = 0
    end

    def process(node)
      @nesting_level += 1

      begin
        if node.kind_of? YAYJS::AST::BaseInstructionNode
          process_baseinstructionnode node
        else
          send :"process_#{node.class.name.split("::").last.downcase}", node
        end
      ensure
        @nesting_level -= 1
      end
    end

    def process_iseqnode(node)
      if @nesting_level == 1
        YAYJS::AST::ISeqNode.new node.iseq, process(node.children[0])
      else
        node
      end
    end

    def process_blocknode(node)
      YAYJS::AST::BlockNode.new node.children.map { |n| process(n) }
    end

    def process_preconditionloopnode(node)
      YAYJS::AST::PreconditionLoopNode.new *node.children.map { |n| process(n) }
    end

    def process_postconditionloopnode(node)
      YAYJS::AST::PostconditionLoopNode.new *node.children.map { |n| process(n) }
    end

    def process_infiniteloopnode(node)
      YAYJS::AST::InfiniteLoopNode.new process(node.children[0])
    end

    def process_ifnode(node)
      YAYJS::AST::IfNode.new *node.children.map { |n| process(n) }
    end

    def process_casenode(node)
      YAYJS::AST::CaseNode.new node.children.map { |n| process(n) }
    end

    def process_casewhennode(node)
      YAYJS::AST::CaseWhenNode.new node.value, process(node.children[0])
    end

    def process_caseelsenode(node)
      YAYJS::AST::CaseElseNode.new process(node.children[0])
    end

    def process_ssastorenode(node)
      YAYJS::AST::SSAStoreNode.new node.variable, process(node.children[0])
    end

    def process_ssastoremultiplenode(node)
      YAYJS::AST::SSAStoreMultipleNode.new node.variables, process(node.children[0])
    end

    def process_ssafetchnode(node)
      YAYJS::AST::SSAFetchNode.new node.variable
    end

    def process_genericinstructionnode(node)
      YAYJS::AST::GenericInstructionNode.new node.instruction, node.children.map { |n| process(n) }
    end

    def process_breaknode(node)
      YAYJS::AST::BreakNode.new
    end

    def process_redonode(node)
      YAYJS::AST::RedoNode.new
    end

    def process_nextnode(node)
      YAYJS::AST::NextNode.new
    end

    def process_leavenode(node)
      YAYJS::AST::LeaveNode.new process(node.children[0])
    end

    def process_baseinstructionnode(node)
      node.class.new node.children.map { |n| process(n) }
    end

    def process_literalnode(node)
      YAYJS::AST::LiteralNode.new node.value
    end
  end
end
