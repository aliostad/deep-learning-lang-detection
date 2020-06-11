from visit import *
DeleteAllPlots()
ResetView()

SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 1
SaveWindowAtts.outputDirectory = "."
SaveWindowAtts.fileName = 'particle-v-'
SaveWindowAtts.family = 1
SaveWindowAtts.format = SaveWindowAtts.PNG  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.width = 1285
SaveWindowAtts.height = 785
SaveWindowAtts.screenCapture = 0
SaveWindowAtts.saveTiled = 0
SaveWindowAtts.quality = 80
SaveWindowAtts.progressive = 0
SaveWindowAtts.binary = 0
SaveWindowAtts.stereo = 0
SaveWindowAtts.compression = SaveWindowAtts.PackBits  # None, PackBits, Jpeg, Deflate
SaveWindowAtts.forceMerge = 0
SaveWindowAtts.resConstraint = SaveWindowAtts.NoConstraint  # NoConstraint, EqualWidthHeight, ScreenProportions
SaveWindowAtts.advancedMultiWindowSave = 0
SetSaveWindowAttributes(SaveWindowAtts)

View3DAtts = View3DAttributes()
View3DAtts.viewNormal = (-0.616596, 0.605379, 0.503315)
View3DAtts.focus = (-7.1792e-09, -2.18366e-07, 0.000262933)
View3DAtts.viewUp = (0.348624, 0.783166, -0.51489)
View3DAtts.viewAngle = 30
View3DAtts.parallelScale = 0.000175567
View3DAtts.nearPlane = -0.000351133
View3DAtts.farPlane = 0.000351133
View3DAtts.imagePan = (0, 0)
View3DAtts.imageZoom = 1.00215
View3DAtts.perspective = 1
View3DAtts.eyeAngle = 2
View3DAtts.centerOfRotationSet = 0
View3DAtts.centerOfRotation = (-7.1792e-09, -2.18366e-07, 0.000262933)
View3DAtts.axis3DScaleFlag = 0
View3DAtts.axis3DScales = (1, 1, 1)
View3DAtts.shear = (0, 0, 1)
View3DAtts.windowValid = 1
SetView3D(View3DAtts)

AnnotationAtts = AnnotationAttributes()
AnnotationAtts.axes3D.zAxis.title.visible = 0
AnnotationAtts.axes3D.zAxis.label.visible = 0
AnnotationAtts.axes3D.zAxis.tickMarks.visible = 0
AnnotationAtts.axes3D.xAxis.title.visible = 0
AnnotationAtts.axes3D.xAxis.label.visible = 0
AnnotationAtts.axes3D.xAxis.tickMarks.visible = 0
AnnotationAtts.axes3D.yAxis.title.visible = 0
AnnotationAtts.axes3D.yAxis.label.visible = 0
AnnotationAtts.axes3D.yAxis.tickMarks.visible = 0
AnnotationAtts.userInfoFlag = 0
AnnotationAtts.databaseInfoFlag = 0
SetAnnotationAttributes(AnnotationAtts)

AddPlot("Pseudocolor", "particle/V", 1, 1)

DrawPlots()
SaveWindow()

DeleteAllPlots()
ResetView()
