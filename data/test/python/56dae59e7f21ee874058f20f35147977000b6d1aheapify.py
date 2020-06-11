from vis import Visitor
from free_vars import FreeVarsVisitor
from compiler.ast import *
from explicit import *
from explicate2 import ExplicateVisitor2
from find_locals import FindLocalsVisitor
from compiler_utilities import *

needs_heapify = {}

class FreeInFunVisitor(Visitor):

    def visitModule(self, n):
        self.dispatch(n.node)

    def visitAdd(self, n):
        self.dispatch(n.left)
        self.dispatch(n.right)

    def visitUnarySub(self, n):
        self.dispatch(n.expr)

    def visitCallFunc(self, n):
        for arg in n.args:
            self.dispatch(arg) 
        self.dispatch(n.node)

    def visitFunction(self, n):
        local_vars = FindLocalsVisitor().preorder(n.code)
        free_in_fun = FreeVarsVisitor().preorder(n.code)
        for x in (free_in_fun - local_vars) - set(n.argnames):
            needs_heapify[x] = True

    def visitLambda(self, n):
        free_in_fun = FreeVarsVisitor().preorder(n.code)
        for x in free_in_fun - set(n.argnames):
            needs_heapify[x] = True

    def visitIfExp(self, n):
        self.dispatch(n.test)
        self.dispatch(n.then)
        self.dispatch(n.else_)        

    def visitCompare(self, n):
        self.dispatch(n.expr)
        self.dispatch(n.ops[0][1])

    def visitSubscript(self, n):
        self.dispatch(n.expr)
        self.dispatch(n.subs[0])

    def visitStmt(self, n):
        for s in n.nodes:
            self.dispatch(s)

    def visitPrintnl(self, n):
        self.dispatch(n.nodes[0])

    def visitAssign(self, n):
        self.dispatch(n.expr)

    def visitDiscard(self, n):
        self.dispatch(n.expr)

    def visitReturn(self, n):
        self.dispatch(n.value)

    def visitIf(self, n):
        self.dispatch(n.tests[0][0])
        self.dispatch(n.tests[0][1])
        self.dispatch(n.else_)

    def visitWhile(self, n):
        self.dispatch(n.test)
        self.dispatch(n.body)

    def visitInjectFrom(self, n):
        self.dispatch(n.arg)

    def visitProjectTo(self, n):
        self.dispatch(n.arg)

    def visitGetTag(self, n):
        self.dispatch(n.arg)

    def visitLet(self, n):
        self.dispatch(n.rhs)
        self.dispatch(n.body)

    def visitName(self, n):        
        pass

    def visitConst(self, n):        
        pass

    def visitstr(self, n):
	pass

    def visitSetSubscript(self, n):
        self.dispatch(n.container)
        self.dispatch(n.key)
        self.dispatch(n.val)


class HeapifyVisitor(Visitor):

    def visitModule(self, n):
        local_vars = FindLocalsVisitor().preorder(n.node)
        body = self.dispatch(n.node)
        local_inits = [Assign(nodes=[AssName(x, 'OP_ASSIGN')],
                              expr=ExplicateVisitor2().preorder(List([Const(0)]))) \
                       for x in local_vars if x in needs_heapify.keys()]
        return Module(n.doc, Stmt(local_inits + body.nodes))

    def visitLambda(self, n):
        local_vars = FindLocalsVisitor().preorder(n.code)
        body = self.dispatch(n.code)
        local_inits = [Assign(nodes=[AssName(x, 'OP_ASSIGN')],
                              expr=ExplicateVisitor2().preorder(List([Const(0)]))) \
                       for x in local_vars if x in needs_heapify.keys()]

        param2new = {}
        params_free_in_fun = set([x for x in n.argnames if x in needs_heapify.keys()])
        for x in params_free_in_fun:
            param2new[x] = generate_name(x) 
        
        param_allocs = [Assign(nodes=[AssName(x, 'OP_ASSIGN')],
                               expr=ExplicateVisitor2().preorder(List([Const(0)]))) 
                        for x in params_free_in_fun]
        param_inits = [Discard(SetSubscript(Name(x), Const(0),
                                            Name(param2new[x])))
                       for x in params_free_in_fun]
        new_argnames = [param2new[x] if x in param2new else x 
                        for x in n.argnames]
        return Lambda(new_argnames, n.defaults, n.flags,
                      Stmt(param_allocs + param_inits + local_inits + body.nodes))

    def visitReturn(self, n):
        return Return(self.dispatch(n.value))

    def visitStmt(self, n):
        ss  = [self.dispatch(s) for s in n.nodes]
        return Stmt(ss)

    def visitPrintnl(self, n):
        e = self.dispatch(n.nodes[0])
        return Printnl([e], n.dest)

    def visitAssign(self, n):
        rhs = self.dispatch(n.expr)
        if isinstance(n.nodes[0], AssName):
            if n.nodes[0].name in needs_heapify.keys():
                return Discard(SetSubscript(Name(n.nodes[0].name), Const(0), rhs))
            else:
                return Assign(nodes=n.nodes, expr=rhs)
        else:
            raise Exception('Heapify: unhandled lhs of assign')

    def visitIf(self, n):
        test = self.dispatch(n.tests[0][0])
        then = self.dispatch(n.tests[0][1])
        else_ = self.dispatch(n.else_)
        return If([(test, then)], else_)

    def visitWhile(self, n):
        test = self.dispatch(n.test)
        body = self.dispatch(n.body)
        return While(test, body, n.else_)

    def visitConst(self, n):
        return n

    def visitName(self, n):
        if n.name in needs_heapify.keys():
            return Subscript(Name(n.name), 'OP_APPLY', [Const(0)])
        else:
            return n

    def visitAdd(self, n):
        left = self.dispatch(n.left)
        right = self.dispatch(n.right)
        return Add((left, right))

    def visitUnarySub(self, n):
        return UnarySub(self.dispatch(n.expr))
        
    def visitCallFunc(self, n):
        return CallFunc(self.dispatch(n.node),
                        [self.dispatch(a) for a in n.args])

    def visitCompare(self, n):
        left = self.dispatch(n.expr)
        right = self.dispatch(n.ops[0][1])
        return Compare(left, [(n.ops[0][0], right)])

    def visitAnd(self, n):
        left = self.dispatch(n.nodes[0])
        right = self.dispatch(n.nodes[1])
        return And([left, right])

    def visitOr(self, n):
        left = self.dispatch(n.nodes[0])
        right = self.dispatch(n.nodes[1])
        return Or([left, right])

    def visitIfExp(self, n):
        test = self.dispatch(n.test)
        then = self.dispatch(n.then)
        else_ = self.dispatch(n.else_)
        return IfExp(test, then, else_)

    def visitNot(self, n):
        expr = self.dispatch(n.expr)
        return Not(expr)

    def visitDict(self, n):
        items = [(self.dispatch(k),
                  self.dispatch(e)) for (k, e) in n.items]
        return Dict(items)
    
    def visitList(self, n):
        return List([self.dispatch(e) for e in n.nodes])

    def visitSubscript(self, n):
        expr = self.dispatch(n.expr)
        subs = [self.dispatch(e) for e in n.subs]
        return Subscript(expr, n.flags, subs)

    def visitSetSubscript(self, n):
        c = self.dispatch(n.container)
        k = self.dispatch(n.key)
        v = self.dispatch(n.val)
        return SetSubscript(c, k, v)

    def visitDiscard(self, n):
        e = self.dispatch(n.expr)
        return Discard(e)

    def visitInjectFrom(self, n):
        return InjectFrom(n.typ, self.dispatch(n.arg))

    def visitProjectTo(self, n):
        return ProjectTo(n.typ, self.dispatch(n.arg))

    def visitGetTag(self, n):
        return GetTag(self.dispatch(n.arg))

    def visitLet(self, n):
        rhs = self.dispatch(n.rhs)
        body = self.dispatch(n.body)
        return Let(n.var, rhs, body)

    def visitstr(self, n):
    	return n
