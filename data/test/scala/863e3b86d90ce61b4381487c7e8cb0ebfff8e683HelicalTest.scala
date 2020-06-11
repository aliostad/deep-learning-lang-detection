package org.yaml.helicalyaml

import org.junit._
import Assert._
import org.yaml.helicalyaml._

@Test
class HelicalTest {

    @Test
    def testDumpScalar() {
    	val yaml = new HelicalYaml()
        assertEquals("aaa\n", yaml.dump("aaa"))
        assertEquals("1\n", yaml.dump(1))
        assertEquals("false\n", yaml.dump(false))
    }
    
    @Test
    def testLoadScalar() {
    	val yaml = new HelicalYaml()
        assertEquals("aaa", yaml.load("aaa"))
        assertEquals(1, yaml.load("1"))
        assertEquals(false, yaml.load("false"))
    }
    
    @Test
    def testDumpList() {
    	val yaml = new HelicalYaml()
        assertEquals("[1, 2, 3]\n", yaml.dump(List(1, 2, 3)))
        assertEquals("[3, 2, 1]\n", yaml.dump(3 :: 2 :: 1 :: Nil))
    }
    
    @Test
    def testDumpNil() {
    	val yaml = new HelicalYaml()
        assertEquals("[]\n", yaml.dump(Nil))
    }
    
    @Test
    def testDumpMap() {
    	val yaml = new HelicalYaml()
        assertEquals("{aaa: 1, bbb: 2, ccc: 3}\n", yaml.dump(Map("aaa" -> 1, "bbb" -> 2, "ccc" -> 3)))
    }
    
    @Test(expected=classOf[org.yaml.snakeyaml.error.YAMLException])
    def testDumpTuple() {
    	val yaml = new HelicalYaml()
    	//TODO Tuple does not work
        yaml.dump(("aaa", 3, true))
    }
}


