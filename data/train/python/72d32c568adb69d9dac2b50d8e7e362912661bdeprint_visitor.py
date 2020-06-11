from vis import Visitor
from ir_x86 import *

def liveness(n):
    if hasattr(n, 'live'):
        s = '\t{' + ','.join(n.live) + '}'
    else:
        s = '\t{}'
    return s
    

class PrintVisitor(Visitor):

    def visitModule(self, n):
        return self.dispatch(n.node)

    def visitStmt(self, n):
        return '{\n  ' + '\n  '.join([self.dispatch(s) + liveness(s) for s in n.nodes]) + '\n}'

    def visitCallX86(self, n):
        return 'call ' + n.name #+ liveness(n)

    def visitPush(self, n):
        return 'pushl ' + self.dispatch(n.arg) #+ liveness(n)

    def visitPop(self, n):
        return 'addl $' + repr(n.bytes) + ', %esp' #+ liveness(n)

    def visitIntMoveInstr(self, n):
        return ('movl %s, %s' % (self.dispatch(n.rhs[0]),
                                self.dispatch(n.lhs))) #+ liveness(n)

    def visitIntAddInstr(self, n):
        return ('addl %s, %s' % (self.dispatch(n.rhs[0]),
                                self.dispatch(n.lhs))) #+ liveness(n)

    def visitIntLEAInstr(self, n):
        return ('%s = %s + %s' % (self.dispatch(n.lhs),
                                 self.dispatch(n.rhs[0]),
                                 self.dispatch(n.rhs[1]))) #+ liveness(n)

    def visitIntSubInstr(self, n):
        return ('subl %s, %s' % (self.dispatch(n.rhs[0]), self.dispatch(n.lhs)
                                )) #+ liveness(n)

    def visitIntNegInstr(self, n):
        x = self.dispatch(n.lhs)
        return ('negl %s' % x)  #+ liveness(n)

    def visitName(self, n):
        return n.name

    def visitRegister(self, n):
        return '%' + n.name

    def visitConst(self, n):
        return repr(n.value)


class PrintVisitor2(PrintVisitor):

    def visitShiftLeftInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s << %s" % (self.dispatch(n.lhs),
                                      self.dispatch(n.rhs[0]),
                                      self.dispatch(n.rhs[1]))
        else:
            return "sall %s, %s" % (self.dispatch(n.rhs[0]),
                                    self.dispatch(n.lhs))

    def visitShiftRightInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s >> %s" % (self.dispatch(n.lhs),
                                      self.dispatch(n.rhs[0]),
                                      self.dispatch(n.rhs[1]))
        else:
            return "sarl %s, %s" % (self.dispatch(n.rhs[0]),
                                   self.dispatch(n.lhs))


    def visitIntOrInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s | %s" % (self.dispatch(n.lhs),
                                     self.dispatch(n.rhs[0]),
                                     self.dispatch(n.rhs[1]))
        else:
            return "orl %s, %s" % (self.dispatch(n.rhs[0]),
                                  self.dispatch(n.lhs))


    def visitIntAndInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s & %s" % (self.dispatch(n.lhs),
                                     self.dispatch(n.rhs[0]),
                                     self.dispatch(n.rhs[1]))
        else:
            return "andl %s, %s" % (self.dispatch(n.lhs),
                                 self.dispatch(n.rhs[0]))

    def visitIntNotInstr(self, n):
        x = self.dispatch(n.lhs)
        return 'negl %s' % x
    

    def visitCMPLInstr(self, n):
        return "cmpl %s, %s" % (self.dispatch(n.rhs[0]),
                                 self.dispatch(n.rhs[1]))

    def visitSetIfEqInstr(self, n):
        return "sete %s" % self.dispatch(n.lhs)

    def visitSetIfNotEqInstr(self, n):
        return "setne %s" % self.dispatch(n.lhs)

    def visitIntMoveZeroExtendInstr(self, n):
        return "movbzl %s, %s" % (','.join([self.dispatch(c) for c in n.rhs]),
                                 self.dispatch(n.lhs))

    def visitJumpEqInstr(self, n):
        return "je label_%s" % n.dest

    def visitIf(self, n):
        return "if %s then\n%s\nelse\n%s" % (self.dispatch(n.tests[0][0]),
                                             self.dispatch(n.tests[0][1]),
                                             self.dispatch(n.else_))

    def visitWhile(self, n):
        return "while %s:\n%s" % (self.dispatch(n.test),
                                  self.dispatch(n.body))

    def visitstr(self, n):
        return n
    
    def visitLabel(self, n):
        return "label_%s:" % n.name


class PrintVisitor3(PrintVisitor2):

    def visitFunName(self, n):
        return 'fun_' + n.name

    def visitFunction(self, n):
        params = ', '.join(n.argnames)
        code = self.dispatch(n.code)
        return 'def %s(%s):\n%s\n' % (n.name, params, code)

    def visitReturn(self, n):
        return 'return %s' % self.dispatch(n.value)

    def visitGoto(self, n):
        return 'goto %s' % n.target_l

    def visitStackLoc(self, n):
        return '%d(%%ebp)' % n.offset

    def visitPopValue(self, n):
        return 'popl %s' % n.target

    def visitIndirectCallX86(self, n):
        return 'call *%s' % self.dispatch(n.funptr)
