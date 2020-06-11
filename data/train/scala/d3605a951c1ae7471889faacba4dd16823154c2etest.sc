
Write("MZ")
DelayMilliseconds(750)
Write("FD01")
DelayMilliseconds(750)
Write("C500002580")
DelayMilliseconds(750)

Loop() {

    #All Off
    Write("P5310000000000000000FF")
    DelayMilliseconds(750)

    #Auto Indicator
    Write("P5310020000000000000DF")
    DelayMilliseconds(750)

    #Front Defrost Indicator
    Write("P5310000090000000000F6")
    DelayMilliseconds(750)

    #Rear Defrost Indicator
    

    #Recirculating Air Indicator
    Write("P5310000200000000000DF")
    DelayMilliseconds(750)

    #Fresh Air Indicator
    Write("P5310000100000000000EF")
    DelayMilliseconds(750)

    #A/C Indicator
    Write("P53100008000000000007F")

    #Begin Blower Levels
    Write("P5310001000000000000FE")
    DelayMilliseconds(200)
    
    Write("P5310002000000000000FD")
    DelayMilliseconds(200)
    
    Write("P5310003000000000000FC")
    DelayMilliseconds(200)
    
    Write("P5310004000000000000FB")
    DelayMilliseconds(200)
    
    Write("P5310005000000000000FA")
    DelayMilliseconds(200)

    Write("P5310006000000000000F9")
    DelayMilliseconds(200)
    
    Write("P5310007000000000000F8")
    DelayMilliseconds(200)
    #End Blower Levels

    #Begin AC Display
    Write("P5310000010000000000FE")
    DelayMilliseconds(500)
    
    Write("P5310000020000000000FD")
    DelayMilliseconds(500)

    Write("P5310000030000000000FC")
    DelayMilliseconds(500)

    Write("P5310000040000000000FB")
    DelayMilliseconds(500)

    Write("P5310000050000000000FA")
    DelayMilliseconds(500)
    #End AC Display

    #All On
    Write("P53100AABA403038008071")
    DelayMilliseconds(500)

    #All On, Dim
    Write("P53100AABA40303800C031")
    DelayMilliseconds(500)
}