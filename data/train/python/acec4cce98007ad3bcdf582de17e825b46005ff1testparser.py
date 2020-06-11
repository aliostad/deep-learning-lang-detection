from ..parser import parse_cst, parse_star_ast, parse_nmrstar_ast
from ..unparse import maybeerror
from ..starast import Data, Save, Loop
import unittest as u


good = maybeerror.MaybeError.pure
bad = maybeerror.MaybeError.error


class TestParser(u.TestCase):
    
    def testParseGood(self):
        self.assertEqual(parse_star_ast("data_hi save_me # oop \n   save_ "), 
                         good(Data('hi', {'me': Save({}, [])})))
    
    def testParseGoodComplex(self):
        inp = """
        data_start
         save_st1
          _a 1
          _b 2
         save_
         save_st2
          _c 3
          loop_
           _d _e
           w x y z m n
          stop_
         save_
        """
        ast = Data('start',
                   {'st1': Save({'a': '1', 'b': '2'}, []),
                    'st2': Save({'c': '3'}, [Loop(['d', 'e'], [['w', 'x'], ['y', 'z'], ['m', 'n']])])})
        self.assertEqual(parse_star_ast(inp), good(ast))


class TestParserErrors(u.TestCase):

    def test_cst_problem(self):
        self.assertEqual(parse_nmrstar_ast("data_hi save_me # oop \n "), 
                         bad({'phase': 'CST construction', 
                              'message': [('data', (1,1)), ('save', (1,9)), ('save close', 'EOF')]}))
    
    def test_star_ast_problem(self):
        self.assertEqual(parse_nmrstar_ast("data_hi save_me _a 1 _a 2 save_ "), 
                         bad({'phase': 'AST construction',
                              'message': {'message': 'duplicate key', 'nodetype': 'save',
                                          'key': 'a', 'first': (1,17), 'second': (1,22)}}))

    def test_nmrstar_ast_problem(self):
        self.assertEqual(parse_nmrstar_ast("data_hi save_me _A.a 1 _A.Sf_category 2 save_"),
                         bad({'phase': 'NMRSTAR AST construction', 
                              'message': {'message': 'missing key "Sf_framecode"', 'nodetype': 'save'}}))

    def test_unconsumed_input(self):
        self.assertEqual(parse_nmrstar_ast("data_hi _what?"), 
                         bad({'phase': 'CST construction',
                              'message': [('unparsed tokens remaining', (1,9))]}))

    def test_junk(self):
        self.assertEqual(parse_nmrstar_ast("what is this junk?  this isn't nmr-star"), 
                         bad({'phase': 'CST construction',
                              'message': [('data block', (1,1))]}))
