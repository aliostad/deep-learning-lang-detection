# Define expressions
DefineScalarExpression("procid", "procid(mesh)")

# Create plots
# Create plot 1
#OpenDatabase("localhost:/scratch/todi/bcumming/jean-favre/output.bov", 0, "BOV_1.0")
OpenDatabase("localhost:./output.bov", 0, "BOV_1.0")
AddPlot("Pseudocolor", "phi", 0, 0)
atts = PseudocolorAttributes()
atts.minFlag = 1
atts.maxFlag = 1
atts.min = 0.0
atts.max = 1.0
SetPlotOptions(atts)

DrawPlots()

SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 1
#SaveWindowAtts.outputDirectory = "."
SaveWindowAtts.fileName = "phi_image."
SaveWindowAtts.advancedMultiWindowSave = 0
SaveWindowAtts.width = 640
SaveWindowAtts.height = 720
SetSaveWindowAttributes(SaveWindowAtts)

SaveWindow()

exit()
