OpenDatabase("localhost:/Users/jkulesza/tmp/simple_case_core_FSRmesh.vtk", 0)
AddPlot("FilledBoundary", "materials", 1, 1)
DrawPlots()

# Adjust fonts.
# Logging for SetAnnotationObjectOptions is not implemented yet.
AnnotationAtts = AnnotationAttributes()

AnnotationAtts.axes3D.autoSetTicks = 0

AnnotationAtts.axes3D.xAxis.tickMarks.visible = 1
AnnotationAtts.axes3D.xAxis.tickMarks.majorMinimum = 0
AnnotationAtts.axes3D.xAxis.tickMarks.majorMaximum = 42.84
AnnotationAtts.axes3D.xAxis.tickMarks.minorSpacing = 1.26
AnnotationAtts.axes3D.xAxis.tickMarks.majorSpacing = 1.26 

AnnotationAtts.axes3D.yAxis.tickMarks.visible = 0
AnnotationAtts.axes3D.zAxis.tickMarks.visible = 0

AnnotationAtts.axes3D.xAxis.title.visible = 0
AnnotationAtts.axes3D.xAxis.label.visible = 0
AnnotationAtts.axes3D.yAxis.title.visible = 0
AnnotationAtts.axes3D.yAxis.label.visible = 0
AnnotationAtts.axes3D.zAxis.title.visible = 0
AnnotationAtts.axes3D.zAxis.label.visible = 0

SetAnnotationAttributes(AnnotationAtts)          

# Adjust view to be an orthogonal plan view.
View3DAtts = View3DAttributes()
View3DAtts.viewNormal = (0, 0, 1)
View3DAtts.focus = (21.42, 0.63, 1.785)
View3DAtts.viewUp = (0, 1, 0)
View3DAtts.viewAngle = 30
View3DAtts.parallelScale = 21.5035
View3DAtts.nearPlane = -43.007
View3DAtts.farPlane = 43.007
View3DAtts.imagePan = (0, 0)
View3DAtts.imageZoom = 1
View3DAtts.perspective = 0
View3DAtts.eyeAngle = 2
View3DAtts.centerOfRotationSet = 0
View3DAtts.centerOfRotation = (21.42, 0.63, 1.785)
View3DAtts.axis3DScaleFlag = 0
View3DAtts.axis3DScales = (1, 1, 1)
View3DAtts.shear = (0, 0, 1)
View3DAtts.windowValid = 1
SetView3D(View3DAtts)

# Save file (plot of materials).
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 1
SaveWindowAtts.outputDirectory = "."
SaveWindowAtts.fileName = "simple_case_plot_material"
SaveWindowAtts.family = 0
SaveWindowAtts.format = SaveWindowAtts.PNG  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.quality = 90
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()

DeleteActivePlots()
AddPlot("Pseudocolor", "flux___1", 1, 1)
DrawPlots()

# Save file.
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 1
SaveWindowAtts.outputDirectory = "."
SaveWindowAtts.fileName = "simple_case_plot_flux_grp_1"
SaveWindowAtts.family = 0
SaveWindowAtts.format = SaveWindowAtts.PNG  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.quality = 90
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()
 
SetQueryFloatFormat("%g")
Query("Lineout", end_point=(42.84, 0.63, 1.785), num_samples=50, start_point=(0, 0.63, 1.785), use_sampling=0, 
    vars=("flux___1", "flux___2", "flux___3", "flux___4", "flux___5", "flux___6", "flux___7", "flux___8", "flux___9", "flux__10",   
          "flux__11", "flux__12", "flux__13", "flux__14", "flux__15", "flux__16", "flux__17", "flux__18", "flux__19", "flux__20", 
          "flux__21", "flux__22", "flux__23", "flux__24", "flux__25", "flux__26", "flux__27", "flux__28", "flux__29", "flux__30", 
          "flux__31", "flux__32", "flux__33", "flux__34", "flux__35", "flux__36", "flux__37", "flux__38", "flux__39", "flux__40", 
          "flux__41", "flux__42", "flux__43", "flux__44", "flux__45", "flux__46", "flux__47", "flux__48", "flux__49", "flux__50", 
          "flux__51", "flux__52", "flux__53", "flux__54", "flux__55", "flux__56"))
SetActiveWindow(2)

# Save file.
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 1
SaveWindowAtts.outputDirectory = "."
SaveWindowAtts.fileName = "simple_case_plot_flux_all"
SaveWindowAtts.family = 0
SaveWindowAtts.format = SaveWindowAtts.PNG  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.quality = 90
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()

# Save file.
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 1
SaveWindowAtts.outputDirectory = "."
SaveWindowAtts.fileName = "simple_case_data_flux_all"
SaveWindowAtts.family = 0
SaveWindowAtts.format = SaveWindowAtts.ULTRA # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()
 

exit()

