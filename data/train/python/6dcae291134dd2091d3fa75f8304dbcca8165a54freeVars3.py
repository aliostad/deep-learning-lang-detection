from freeVars2 import *
from pyAST import *


class FreeVarVisitor(FreeVarVisitor):
    def visitAssAttr(self, n, args=None):
        return self.dispatch(n.expr)

    def visitGetattr(self, n, args=None):
        return self.dispatch(n.expr)

    def visitHasAttr(self, n, args=None):
        return self.dispatch(n.expr)

    def visitCreateClass(self, n, args=None):
        frees = set()
        for b in n.bases:
            frees |= self.dispatch(b)
        return frees

    def visitWhile(self, n, args=None):
        return self.dispatch(n.test) | self.dispatch(n.body)

    def visitIf(self, n, args=None):
        return self.dispatch(n.tests[0][0]) |\
               self.dispatch(n.tests[0][1]) |\
               self.dispatch(n.else_)

