import bpy
from . import tamy_material
from . import tamy_mesh
from . import tamy_scene
from ctypes import *


### ===========================================================================

### This method initializes the export procedure, making sure all relevant input data has correct values
### and that the editor is in the correct state
def initialize_exporter( ):

	if bpy.ops.object.mode_set.poll():
		bpy.ops.object.mode_set(mode='OBJECT')

### ===========================================================================	

### Export settings
class TamyExportSettings( Structure ):

	_fields_ = [("saveAnimations", c_bool),
				("saveMaterials", c_bool),
				("saveMeshes", c_bool),
				("savePrefabs", c_bool),
				("saveObjects", c_bool) ]
	
	def __init__( self, saveAnimations, saveMaterials, saveMeshes, savePrefabs, saveObjects ):
	
		self.saveAnimations = saveAnimations
		self.saveMaterials = saveMaterials
		self.saveMeshes = saveMeshes
		self.savePrefabs = savePrefabs
		self.saveObjects = saveObjects

### ===========================================================================

def export_scene(operator, context, filesystemRoot="", filepath="", bUseSelection=True, selectedArmature="", saveAnimations=True, saveMaterials=True, saveMeshes=True, savePrefabs=True, saveObjects=True ):

	# measure the execution time - just in case
	import time
	time1 = time.clock()
	
	# initialize export
	initialize_exporter()
	
	# dismantle the specified filepath into the filesystem path and the name of the saved scene
	import os
	exportDir, sceneName = os.path.split( filepath )
	
	# make a list of all materials and entities in the scene
	tamyScene = tamy_scene.TamyScene( sceneName )
	tamyScene.compile_scene( context, bUseSelection, selectedArmature )
	
	# and now export it all
	exportSettings = TamyExportSettings( saveAnimations, saveMaterials, saveMeshes, savePrefabs, saveObjects )
	tamyScene.export( filesystemRoot, exportDir, exportSettings )
	
	# and the execution took...
	print("Tamy export time: %.4f" % (time.clock() - time1))
	
	return {'FINISHED'}

### ===========================================================================
