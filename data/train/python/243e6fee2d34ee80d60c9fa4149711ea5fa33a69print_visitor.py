from visitor86 import Visitor
from ir import *


class PrintVisitor(Visitor):

    def visitModule(self, n):
        return self.dispatch(n.node)

    def visitStmt(self, n):
        return '{\n' + '\n'.join([self.dispatch(s) for s in n.nodes]) + '\n}'

    def visitCallX86(self, n):
        return 'call ' + n.name

    def visitPush(self, n):
        return 'push ' + self.dispatch(n.arg)

    def visitPop(self, n):
        return 'pop ' + repr(n.bytes)

    def visitIntMoveInstr(self, n):
        return '%s = %s' % (self.dispatch(n.lhs),
                             self.dispatch(n.rhs[0]))

    def visitIntAddInstr(self, n):
        return '%s += %s' % (self.dispatch(n.lhs),
                             self.dispatch(n.rhs[0]))

    def visitIntLEAInstr(self, n):
        return '%s = %s + %s' % (self.dispatch(n.lhs),
                                 self.dispatch(n.rhs[0]),
                                 self.dispatch(n.rhs[1]))

    def visitIntSubInstr(self, n):
        return '%s -= %s' % (self.dispatch(n.lhs),
                             self.dispatch(n.rhs[0]))

    def visitIntNegInstr(self, n):
        x = self.dispatch(n.lhs)
        return '%s = -%s' % (x,x)

    def visitName(self, n):
        return n.name

    def visitRegister(self, n):
        return n.name

    def visitConst(self, n):
        return repr(n.value)
