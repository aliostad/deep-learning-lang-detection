from vis import Visitor
from compiler_utilities import *
from explicit import *
from compiler import *
from find_locals import FindLocalsVisitor

class FreeVarsVisitor(Visitor):

    def visitName(self, n):
        if n.name in builtin_functions:
            return set([])
        else:
            return set([n.name])

    def visitConst(self, n):
        return set([])

    def visitAdd(self, n):
        return self.dispatch(n.left) | self.dispatch(n.right)

    def visitUnarySub(self, n):
        return self.dispatch(n.expr)

    def visitCallFunc(self, n):
        sss = [self.dispatch(arg) for arg in n.args]
        ss = reduce(lambda a,b: a | b, sss, set([]))
        return ss | self.dispatch(n.node)

    def visitLambda(self, n):
        local_vars = FindLocalsVisitor().preorder(n.code)
        return (self.dispatch(n.code) - local_vars) - set(n.argnames)

    def visitIfExp(self, n):
        return self.dispatch(n.test) | self.dispatch(n.then) | self.dispatch(n.else_)        

    def visitCompare(self, n):
        return self.dispatch(n.expr) | self.dispatch(n.ops[0][1])

    def visitSubscript(self, n):
        return self.dispatch(n.expr) | self.dispatch(n.subs[0])

    def visitGetTag(self, n):
        return self.dispatch(n.arg)

    def visitInjectFrom(self, n):
        return self.dispatch(n.arg)

    def visitProjectTo(self, n):
        return self.dispatch(n.arg)

    def visitLet(self, n):
        return self.dispatch(n.rhs) | (self.dispatch(n.body) - set([n.var]))

    def visitSetSubscript(self, n):
        return self.dispatch(n.container) | self.dispatch(n.key) | self.dispatch(n.val)

    def visitStmt(self, n):
        sss  = [self.dispatch(s) for s in n.nodes]
        return reduce(lambda a,b: a | b, sss, set([]))

    def visitPrintnl(self, n):
        return self.dispatch(n.nodes[0])

    def visitAssign(self, n):
        return self.dispatch(n.expr)

    def visitDiscard(self, n):
        return self.dispatch(n.expr)

    def visitReturn(self, n):
        return self.dispatch(n.value)

    def visitInjectFrom(self, n):
        return self.dispatch(n.arg)

    def visitProjectTo(self, n):
        return self.dispatch(n.arg)

    def visitGetTag(self, n):
        return self.dispatch(n.arg)

    def visitLet(self, n):
        rhs = self.dispatch(n.rhs)
        body = self.dispatch(n.body)
        return rhs | (body - set([n.var]))
