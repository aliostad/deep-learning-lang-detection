package tuner.gui

import javax.swing.BoundedRangeModel
import javax.swing.event.ChangeEvent
import javax.swing.event.ChangeListener

class FloatRangeModel(minVal:Float,maxVal:Float,numSteps:Int) 
    extends BoundedRangeModel {

  var _min = minVal
  var _max = maxVal
  var steps = numSteps
  var _isAdj = false
  var _currentStep = 0
  var _extent = 0

  var listeners:List[ChangeListener] = Nil

  def minFloat = _min
  def minFloat_=(v:Float) = {_min = v}
  def maxFloat = _max
  def maxFloat_=(v:Float) = {_max = v}
  def getMinimum : Int = 0
  def getMaximum : Int = steps
  def getExtent : Int = _extent
  def getValueIsAdjusting : Boolean = _isAdj
  def setMinimum(m:Int) = {}
  def setExtent(e:Int) = {
    val oldExt = _extent
    _extent = e
    if(oldExt != e)
      fireStateChanged
  }
  def setMaximum(m:Int) = {
    val oldMax = _max
    steps = m
    if(steps != oldMax)
      fireStateChanged
  }
  def setValueIsAdjusting(b:Boolean) = {
    val old = _isAdj
    _isAdj = b
    if(old != _isAdj)
      fireStateChanged
  }

  def setValue(v:Int) = {
    val oldVal = _currentStep
    _currentStep = v
    if(oldVal != v)
      fireStateChanged
  }
  def getValue : Int = _currentStep
  def value = getValue

  def setRangeProperties(newVal:Int, newExtent:Int, 
                         newMin:Int, newMax:Int, 
                         newAdj:Boolean) = {
    var hasChanged = false
    if(newVal != _currentStep)
      hasChanged = true
    if(newAdj != _isAdj)
      hasChanged = true
    if(steps != newMax)
      hasChanged = true
    if(newExtent != _extent)
      hasChanged = true
    _currentStep = newVal
    _extent = newExtent
    _isAdj = newAdj
    steps = newMax

    if(hasChanged)
      fireStateChanged
  }

  def addChangeListener(l:ChangeListener) = 
    listeners = l::listeners
  def removeChangeListener(l:ChangeListener) = 
    listeners = listeners.diff(List(l))
  
  def fireStateChanged = {
    val evt = new ChangeEvent(this)
    listeners.foreach {l => l.stateChanged(evt)}
  }

}

