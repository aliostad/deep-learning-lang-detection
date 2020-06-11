from tourist import *
from uniquify3 import *
from pyAST import *

debug = False


class FreeVarVisitor(Visitor):

    _reservedNames = ['input', 'type_error']
    heapSet = set()

    # Return a list of vars to heapify.##############################3
    def getHeapSet(self):
        return list(self.heapSet)
    # Reset the list/set of vars to heapify
    def resetHeapSet(self):
        self.heapSet.clear()

    # Visitor Methods ----------------------------------------------------------
    def visitModule(self, n, args=None):
        loosies = self.dispatch(n.node)
        locVars = UniquifyVisitor().findLocals(n)
        letGoSet = loosies - set(locVars)
        self.heapSet |= letGoSet
        return letGoSet

    def visitStmt(self, n, args=None):
        loosies = set()
        for stmt in n.nodes:
            loosies |= self.dispatch(stmt)
        return loosies

    def visitLambda(self, n, args=None):
        loosies = self.dispatch(n.code)
        locVars = UniquifyVisitor().findLocals(n)
        if debug:
            print str(n.argnames) + ": " + str(
                loosies - set(locVars) - set(n.argnames))
        letGoSet = loosies - set(locVars) - set(n.argnames)
        self.heapSet |= letGoSet
        return letGoSet

    def visitName(self, n, args=None):
        if n.name == 'True' or n.name == 'False':
            return set([])
        return set([n.name])

    def visitPrintnl(self, n, args=None):
        return self.dispatch(n.nodes[0])

    def visitConst(self, n, args=None):
        return set([])

    def visitAssign(self, n, args=None):
        if isinstance(n.nodes[0], Subscript):
            return self.dispatch(n.expr) | self.dispatch(n.nodes[0])
        return self.dispatch(n.expr)

    def visitAssName(self, n, args=None):
        return set([])

    def visitCallFunc(self, n, args=None):
        if isinstance(n.node, Name) and (n.node.name in reservedFuncs):
            return set([])
        args = set([])
        for element in n.args:
            args |= self.dispatch(element)
        names = self.dispatch(n.node)
        return args | names

    def visitAdd(self, n, args=None):
        return self.dispatch(n.left) | self.dispatch(n.right)

    def visitIntAdd(self, n, args=None):
        return self.dispatch(n.left) | self.dispatch(n.right)

    def visitBigAdd(self, n, args=None):
        return self.dispatch(n.left) | self.dispatch(n.right)

    def visitUnarySub(self, n, args=None):
        return self.dispatch(n.expr)

    def visitOr(self, n, args=None):
        return self.visitList(n)

    def visitAnd(self, n, args=None):
        return self.visitList(n)

    def visitNot(self, n, args=None):
        return self.dispatch(n.expr)

    def visitCompare(self, n, args=None):
        ret = set([])
        ret |= self.dispatch(n.expr)
        ret |= self.dispatch(n.ops[0][1])
        return ret

    def visitIntCompare(self, n, args=None):
        ret = set([])
        ret |= self.dispatch(n.expr)
        ret |= self.dispatch(n.ops[0][1])
        return ret

    def visitBigCompare(self, n, args=None):
        ret = set([])
        ret |= self.dispatch(n.expr)
        ret |= self.dispatch(n.ops[0][1])
        return ret

    def visitIsCompare(self, n, args=None):
        ret = set([])
        ret |= self.dispatch(n.expr)
        ret |= self.dispatch(n.ops[0][1])
        return ret

    def visitIfExp(self, n, args=None):
        return self.dispatch(n.test) | self.dispatch(n.then) | self.dispatch(
            n.else_)

    def visitIf(self, n, args=None):
        return self.dispatch(
            n.tests[0][0]) | self.dispatch(n.tests[0][1]) |\
               self.dispatch(n.else_)

    def visitList(self, n, args=None):
        ret = set([])
        for expr in n.nodes:
            ret |= self.dispatch(expr)
        return ret

    def visitDict(self, n, args=None):
        ret = set([])
        for (key, value) in n.items:
            ret |= self.dispatch(key)
            ret |= self.dispatch(value)
        return ret

    def visitSubscript(self, n, args=None):
        return self.dispatch(n.expr) | self.dispatch(n.subs[0])

    def visitReturn(self, n, args=None):
        return self.dispatch(n.value)

    def visitLet(self, n, args=None):
        return (self.dispatch(n.rhs) | self.dispatch(n.body)) - self.dispatch(
            n.var)

    def visitInjectFrom(self, n, args=None):
        return self.dispatch(n.typ) | self.dispatch(n.arg)

    def visitProjectTo(self, n, args=None):
        return self.visitInjectFrom(n)

    def visitGetTag(self, n, args=None):
        return self.dispatch(n.arg)

    def visitDiscard(self, n, args=None):
        return self.dispatch(n.expr)

    def visitIndirectCall(self, n, args=None):
        args = set([])
        for e in n.args:
            args |= self.dispatch(e)
        names = self.dispatch(n.node)
        return args | names

    def visitClosure(self, n, args=None):
        return self.dispatch(n.name) | set(n.env)

    def visitWhile(self, n, args=None):
        return self.dispatch(n.test) | self.dispatch(n.body)


