import sys
import compiler
from compiler.ast import *
from explicate1 import gen_is_true, letify
from explicate2 import ExplicateVisitor2
from explicit import Let

class ExplicateVisitor3(ExplicateVisitor2):

    def visitLet(self, n):
        return Let(n.var, self.dispatch(n.rhs), self.dispatch(n.body))

    def visitIf(self, n):
        test = self.dispatch(n.tests[0][0])
        then = self.dispatch(n.tests[0][1])
        else_ = self.dispatch(n.else_)
        return If([(letify(test, lambda t: gen_is_true(t)), then)], else_)

    def visitWhile(self, n):
        test = self.dispatch(n.test)
        body = self.dispatch(n.body)
        return While(letify(test, lambda t: gen_is_true(t)), body, n.else_)
