import Image
import custom_utils
import Template
import Scaling
import Bitify
import SaveToPlayerFile


def Run():
	print 'running the inserter'

	[width, height] = Template.getTemplateData()

	for sprite in custom_utils.get_working_sprites():
		sprite.image = finalImage = Scaling.scale(sprite.image, width, height)
		sprite.image = finalImage = Bitify.bitify(sprite.image)
		SaveToPlayerFile.saveSprite(sprite)
		custom_utils.save_working_sprite(sprite)
	
	print 'save to player file'

	SaveToPlayerFile.savePlayerFile()
