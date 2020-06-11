package bad.robot.radiate.ui

import org.specs2.mutable.Specification

class FadeInTest extends Specification {

  val fadeCount = 50

  "Sets the alpha transparency" >> {
    val listener = new PropertyChangeListenerStub
    val fade = new FadeIn

    for (_ <- 0 until fadeCount) {
      fade.fireEvent(List(listener))
    }
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.0; newValue=0.02; propagationId=null; source=0.02]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.02; newValue=0.04; propagationId=null; source=0.04]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.04; newValue=0.06; propagationId=null; source=0.06]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.06; newValue=0.08; propagationId=null; source=0.08]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.08; newValue=0.1; propagationId=null; source=0.10]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.1; newValue=0.12; propagationId=null; source=0.12]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.12; newValue=0.14; propagationId=null; source=0.14]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.14; newValue=0.16; propagationId=null; source=0.16]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.16; newValue=0.18; propagationId=null; source=0.18]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.18; newValue=0.2; propagationId=null; source=0.20]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.2; newValue=0.22; propagationId=null; source=0.22]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.22; newValue=0.24; propagationId=null; source=0.24]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.24; newValue=0.26; propagationId=null; source=0.26]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.26; newValue=0.28; propagationId=null; source=0.28]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.28; newValue=0.3; propagationId=null; source=0.30]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.3; newValue=0.32; propagationId=null; source=0.32]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.32; newValue=0.34; propagationId=null; source=0.34]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.34; newValue=0.36; propagationId=null; source=0.36]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.36; newValue=0.38; propagationId=null; source=0.38]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.38; newValue=0.4; propagationId=null; source=0.40]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.4; newValue=0.42; propagationId=null; source=0.42]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.42; newValue=0.44; propagationId=null; source=0.44]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.44; newValue=0.46; propagationId=null; source=0.46]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.46; newValue=0.48; propagationId=null; source=0.48]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.48; newValue=0.5; propagationId=null; source=0.50]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.5; newValue=0.52; propagationId=null; source=0.52]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.52; newValue=0.54; propagationId=null; source=0.54]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.54; newValue=0.56; propagationId=null; source=0.56]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.56; newValue=0.58; propagationId=null; source=0.58]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.58; newValue=0.6; propagationId=null; source=0.60]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.6; newValue=0.62; propagationId=null; source=0.62]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.62; newValue=0.64; propagationId=null; source=0.64]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.64; newValue=0.66; propagationId=null; source=0.66]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.66; newValue=0.68; propagationId=null; source=0.68]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.68; newValue=0.7; propagationId=null; source=0.70]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.7; newValue=0.72; propagationId=null; source=0.72]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.72; newValue=0.74; propagationId=null; source=0.74]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.74; newValue=0.76; propagationId=null; source=0.76]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.76; newValue=0.78; propagationId=null; source=0.78]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.78; newValue=0.8; propagationId=null; source=0.80]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.8; newValue=0.82; propagationId=null; source=0.82]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.82; newValue=0.84; propagationId=null; source=0.84]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.84; newValue=0.86; propagationId=null; source=0.86]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.86; newValue=0.88; propagationId=null; source=0.88]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.88; newValue=0.9; propagationId=null; source=0.90]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.9; newValue=0.92; propagationId=null; source=0.92]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.92; newValue=0.94; propagationId=null; source=0.94]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.94; newValue=0.96; propagationId=null; source=0.96]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.96; newValue=0.98; propagationId=null; source=0.98]") must_== true
    listener.contains("bad.robot.radiate.ui.AlphaTransparencyChangeEvent[propertyName=fade; oldValue=0.98; newValue=1.0; propagationId=null; source=1.00]") must_== true
  }

  s"Event does not fire (after it's fired $fadeCount times)" >> {
    val listener = new PropertyChangeListenerStub
    val fade = new FadeIn

    for (_ <- 0 to fadeCount) {
      fade.fireEvent(List(listener))
    }
    listener.size must_== fadeCount
  }

  s"Event is done after $fadeCount times" >> {
    val listener = new PropertyChangeListenerStub
    val fade = new FadeIn

    for (_ <- 0 until fadeCount - 1) {
      fade.fireEvent(List(listener))
    }
    fade.done must_== false
    fade.fireEvent(List(listener))
    fade.done must_== true
  }

}
