from print_visitor import PrintVisitor

class PrintVisitor2(PrintVisitor):

    def visitShiftLeftInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s << %s" % (self.dispatch(n.lhs),
                                      self.dispatch(n.rhs[0]),
                                      self.dispatch(n.rhs[1]))
        else:
            return "%s <<= %s" % (self.dispatch(n.lhs),
                                  self.dispatch(n.rhs[0]))

    def visitShiftRightInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s >> %s" % (self.dispatch(n.lhs),
                                      self.dispatch(n.rhs[0]),
                                      self.dispatch(n.rhs[1]))
        else:
            return "%s >>= %s" % (self.dispatch(n.lhs),
                                  self.dispatch(n.rhs[0]))


    def visitIntOrInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s | %s" % (self.dispatch(n.lhs),
                                     self.dispatch(n.rhs[0]),
                                     self.dispatch(n.rhs[1]))
        else:
            return "%s |= %s" % (self.dispatch(n.lhs),
                                 self.dispatch(n.rhs[0]))


    def visitIntAndInstr(self, n):
        if len(n.rhs) > 1:
            return "%s = %s & %s" % (self.dispatch(n.lhs),
                                     self.dispatch(n.rhs[0]),
                                     self.dispatch(n.rhs[1]))
        else:
            return "%s &= %s" % (self.dispatch(n.lhs),
                                 self.dispatch(n.rhs[0]))

    def visitIntNotInstr(self, n):
        x = self.dispatch(n.lhs)
        return '%s = ~%s' % (x,x)
    

    def visitCMPLInstr(self, n):
        return "%s == %s?" % (self.dispatch(n.rhs[0]), self.dispatch(n.rhs[1]))

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
