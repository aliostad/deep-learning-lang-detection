from .. import hierarchical as p
from ..cleantokens import token
from ..unparse import maybeerror as me
from ..unparse import combinators
import unittest as u


m = me.MaybeError
l = combinators.ConsList

def good(rest, state, result):
    return m.pure({'rest': rest, 'state': state, 'result': result})

def bad(message, position):
    return m.error({'message': message, 'position': position})

def run(parser, i):
    return combinators.run(parser, i, 1)

def node(name, count, **kwargs):
    kwargs['_name'] = name
    kwargs['_state'] = count
    return kwargs

# some tokens
loop = token('reserved', (1,1), keyword='loop')
stop = token('reserved', (2,2), keyword='stop')
save_c = token('reserved', (3,3), keyword='save close')
save_o = token('reserved', (4,4), keyword='save open', value='hi')
data_o = token('reserved', (5,5), keyword='data open', value='bye')
id1 = token('identifier', (6,6), value='matt')
id2 = token('identifier', (7,7), value='dog')
val1 = token('value', (8,8), value='hihi')
val2 = token('value', (9,9), value='blar')


class TestCombinations(u.TestCase):

    def testLoop(self):
        inp = [loop, id1, id2, val1, val2, stop]
        output = good(l([]), 7,
                      node('loop', 1, open=loop, close=stop, keys=[id1, id2], values=[val1, val2]))
        self.assertEqual(run(p.loop, inp), output)

    def testDatum(self):
        inp = [id2, val1, save_c]
        output = good(l([save_c]), 3, 
                      node('datum', 1, key=id2, value=val1))
        self.assertEqual(run(p.datum, inp), output)
    
    def testSaveBasic(self):
        inp = [save_o, save_c, stop]
        output = good(l([stop]), 3,
                      node('save',
                           1, 
                           open=save_o,
                           close=save_c,
                           datums=[],
                           loops=[]))
        self.assertEqual(run(p.save, inp), output)
    
    def testSaveComplex(self):
        inp = [save_o, id1, val2, loop, stop, save_c, save_o]
        output = good(l([save_o]), 7, 
                      node('save',
                           1,
                           open=save_o,
                           close=save_c,
                           datums=[node('datum', 2, key=id1, value=val2)],
                           loops=[node('loop', 4, open=loop, close=stop, keys=[], values=[])]))
        self.assertEqual(run(p.save, inp), output)

    def testDataBasic(self):
        inp = [data_o, id1]
        output = good(l([id1]), 2,
                      node('data',
                           1,
                           open=data_o,
                           saves=[]))
        self.assertEqual(run(p.data, inp), output)
        
    def testDataComplex(self):
        inp = [data_o, save_o, id1, val1, save_c, save_c]
        output = good(l([save_c]), 6,
                      node('data',
                           1,
                           open=data_o,
                           saves=[node('save',
                                       2, 
                                       open=save_o,
                                       close=save_c,
                                       datums=[node('datum', 3, key=id1, value=val1)],
                                       loops=[])]))
        self.assertEqual(run(p.data, inp), output)
        
    def testNMRStar(self):
        inp = [data_o, save_o, save_c]
        output = good(l([]), 4,
                      node('data',
                           1,
                           open=data_o,
                           saves=[node('save', 2, open=save_o, close=save_c, datums=[], loops=[])]))
        self.assertEqual(run(p.nmrstar, inp), output)
    

class TestErrors(u.TestCase):
    
    def testLoopInvalidContent(self):
        inp = [loop, id1, id1, val1, save_c, stop]
        output = m.error([('loop', 1), ('loop close', 5)])
        self.assertEqual(run(p.loop, inp), output)
        
    def testDatumMissingValue(self):
        inp = [id2, save_c]
        output = m.error([('datum', 1), ('value', 2)])
        self.assertEqual(run(p.datum, inp), output)
        
    def testLoopMissingStop(self):
        inp = [loop, id1, id2, val1, val2]
        output = m.error([('loop', 1), ('loop close', 6)])
        self.assertEqual(run(p.loop, inp), output)

    def testSaveUnclosed(self):
        inp = [save_o, id1, val1]
        output = m.error([('save', 1), ('save close', 4)])
        self.assertEqual(run(p.save, inp), output)
        
    def testSaveInvalidContent(self):
        inp = [save_o, id2, val2, stop, save_c]
        output = m.error([('save', 1), ('save close', 4)])
        self.assertEqual(run(p.save, inp), output)
    
    def testSaveDatumAfterLoop(self):
        inp = [save_o, id1, val1, loop, id2, val2, stop, id2, val2, save_c]
        output = m.error([('save', 1), ('save close', 8)])
        self.assertEqual(run(p.save, inp), output)
        
    def testDataInvalidContent(self):
        inp = [data_o, loop, save_o, save_c]
        # it just hits the loop_, says, "I don't know how to deal with that",
        #   and doesn't consume it
        output = good(l(inp[1:]), 2,
                      node('data', 1, open=data_o, saves=[]))
        self.assertEqual(run(p.data, inp), output)
        
    def testNMRStarUnconsumedTokensRemaining(self):
        inp = [data_o, loop, save_o, save_c]
        output = m.error([('unparsed tokens remaining', 2)])
        self.assertEqual(run(p.nmrstar, inp), output)
    
    def testNMRStarNoOpenData(self):
        inp = [save_o, loop, stop, save_c]
        output = m.error([('data block', 1)])
        self.assertEqual(run(p.nmrstar, inp), output)
