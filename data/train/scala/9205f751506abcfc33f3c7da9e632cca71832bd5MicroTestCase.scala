

import org.junit.Assert
import org.junit.Before
import org.junit.After
import microprocesador.Microprocesador
import org.junit.Test


import instrucciones.NOP
import instrucciones.LODV
import instrucciones.ADD
import instrucciones.SWAP
import instrucciones.DIV
import exception.DivisionPorCeroException
import instrucciones.LOD
import instrucciones.STR


class MicroTestCase {
  var micro: Microprocesador =_
  
  @Before
  def setUp(){
  micro = new Microprocesador()
  }
  
  @After
  def tearDown(){
    micro.regA = 0
    micro.regB = 0
    micro.pc = 1
  }
  
  @Test
  def puedeEjecutarTresNOP(){
    micro.load(new NOP)
    micro.load(new NOP)
    micro.load(new NOP)
    micro.execute()
    Assert.assertEquals(micro.pc, 4)
  }
  
  @Test
  def puedeSumarDiezYVeintidos(){
    micro.load(new LODV(10))
    micro.load(new SWAP)
    micro.load(new LODV(22))
    micro.load(new ADD)
    micro.execute()
    Assert.assertEquals(micro.regA, 0)
    Assert.assertEquals(micro.regB, 32)
  }
  
  @Test
  def puedeSumarDoscientosYCientocincuenta(){
    micro.load(new LODV(100))
    micro.load(new SWAP)
    micro.load(new LODV(50))
    micro.load(new ADD)
    micro.execute
    Assert.assertEquals(micro.regA, 23)
    Assert.assertEquals(micro.regB, 127)
  }
  
  @Test(expected = classOf[DivisionPorCeroException]) 
  def noPuedeDividirPorCero(){
    micro.load(new LODV(0))
    micro.load(new SWAP)
    micro.load(new LODV(2))
    micro.load(new DIV)
    micro.execute()
  }
    
  @Test
  def puedeSumarTresNumeros(){
    micro.load(new LODV(2))
    micro.load(new STR(0))
    micro.load(new LODV(8))
    micro.load(new SWAP)
    micro.load(new LODV(5))
    micro.load(new ADD)
    micro.load(new SWAP)
    micro.load(new LOD(0))
    micro.load(new ADD)
    micro.execute
    Assert.assertEquals(micro.regB, 2)
    Assert.assertEquals(micro.regA, 0)
  }
}